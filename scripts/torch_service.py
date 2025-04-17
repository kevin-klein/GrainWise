from bottle import Bottle, request, response
from train_object_detection import get_model
from transforms import PILToTensor, Compose
from PIL import Image, ImageDraw
import torch
import numpy as np
import io
from segment_anything import sam_model_registry, SamPredictor
import cv2

sam_checkpoint = "models/sam_vit_h_4b8939.pth"
model_type = "vit_h"

device = "cuda"

sam = sam_model_registry[model_type](checkpoint=sam_checkpoint)
sam.to(device=device)

labels = torch.load('models/rcnn_labels.model', weights_only=True)
labels = {v: k for k, v in labels.items()}

if torch.cuda.is_available():
    device = torch.device('cuda')
else:
    device = torch.device('cpu')

loaded_model = get_model(num_classes = len(labels.keys()), device=device)
loaded_model.load_state_dict(torch.load('models/rcnn_grain_wise.model', map_location=device, weights_only=True))

loaded_model.eval()

loaded_model.to(device)

app = Bottle()

def analyze_file(file):
    request_object_content = file.read()
    pil_image = Image.open(io.BytesIO(request_object_content))

    img, _ = PILToTensor()(pil_image)

    with torch.no_grad():
        prediction = loaded_model([img.to(device)])

    result = []
    for element in range(len(prediction[0]["boxes"])):
            boxes = prediction[0]["boxes"][element].cpu().numpy().tolist()
            score = np.round(prediction[0]["scores"][element].cpu().numpy(),
                    decimals= 4)

            label = labels[prediction[0]['labels'][element].cpu().item()]

            if score > 0.1:
                result.append({
                    'score': score.tolist(),
                    'box': boxes,
                    'label': label
                })
    del img
    return result

@app.post('/')
def upload():
    upload_file = request.POST['image']
    result = analyze_file(upload_file.file)

    return { 'predictions': result }

@app.post('/segment')
def upload_skeleton_angle():
    upload_file = request.POST['image']
    request_object_content = upload_file.read()
    pil_image = Image.open(io.BytesIO(request_object_content))
    open_cv_image = np.array(pil_image)

    height, width, channels = open_cv_image.shape

    predictor = SamPredictor(sam)
    predictor.set_image(open_cv_image)

    input_point = np.array([[width / 2, height / 2]])
    input_label = np.array([1])

    masks, scores, logits = predictor.predict(
        point_coords=input_point,
        point_labels=input_label,
        multimask_output=True,
    )

    max_score_index = np.argmax(scores)
    mask = masks[max_score_index]
    score = scores[max_score_index]

    contours, _  = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    return { 'predictions': {
        'score': score,
        'contour': contours[0]
    } }

if __name__ == '__main__':
    app.run(debug=True, reloader=True, host='0.0.0.0')
