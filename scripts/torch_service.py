from bottle import Bottle, request, response
from train_object_detection import get_model
from transforms import PILToTensor, Compose
from PIL import Image, ImageDraw
import torch
import numpy as np
import io
from mobile_sam import sam_model_registry, SamPredictor
import json
import cv2
import os
import torchvision.transforms as T


sam_checkpoint = "models/mobile_sam.pt"

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

model_type = 'vit_t'

sam = sam_model_registry[model_type](checkpoint=sam_checkpoint)
sam.to(device=device)
sam.eval()

labels = torch.load('models/rcnn_labels.model', weights_only=True)
labels = {v: k for k, v in labels.items()}

if torch.cuda.is_available():
    device = torch.device('cuda')
else:
    device = torch.device('cpu')
device = torch.device('cpu')

loaded_model = get_model(num_classes = len(labels.keys()), device=device)
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

            if score > 0.1 and label == 'scale':
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

def save_masks_as_images(masks, output_dir="masks_out"):
    """
    Save all boolean masks to image files.
    Args:
        masks: np.ndarray or torch.Tensor of shape (N, H, W), dtype=bool
        output_dir: folder to save the images
    """
    os.makedirs(output_dir, exist_ok=True)

    for i, mask in enumerate(masks):
        if isinstance(mask, torch.Tensor):
            mask = mask.cpu().numpy()

        print(mask.squeeze(0).shape)

        im = T.ToPILImage()(mask.squeeze(0))
        im.save(os.path.join(output_dir, f"mask_{i:03d}.png"))

    print(f"Saved {len(masks)} masks to '{output_dir}/'")

@app.post('/segment')
def upload_grain_for_segmentation():
    upload_file = request.POST['image']
    request_object_content = upload_file.file.read()
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

    h, w = mask.shape[-2:]
    mask = mask.reshape(h, w)

    mask = mask.astype(dtype='uint8')
    mask *= 255

    contours, _  = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    return { 'predictions': {
        'score': score.item(),
        'contour': contours[0].astype(int).tolist()
    } }

if __name__ == '__main__':
    app.run(debug=True, reloader=True, host='0.0.0.0', port=9001)
