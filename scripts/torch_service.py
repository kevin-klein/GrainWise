from bottle import Bottle, request, response
from train_object_detection import get_model
from transforms import PILToTensor, Compose
from PIL import Image, ImageDraw
import torch
import numpy as np
import io
# from segment_anything import sam_model_registry, SamPredictor
# from mobile_sam import sam_model_registry, SamPredictor
import json
import cv2
import os
import torchvision.transforms as T

from transformers import SamModel, SamProcessor, infer_device


# sam_checkpoint = "models/mobile_sam_refined.pt"
# sam_checkpoint = "models/mobile_sam.pt"
# sam_checkpoint = "models/sam_vit_b_01ec64.pth"
# model_type = "vit_b"
# model_type = 'vit_t'

# device = "cuda"
device = infer_device()

# sam = sam_model_registry[model_type](checkpoint=sam_checkpoint)
# sam.to(device=device)
# sam.eval()

# sam_checkpoint = "models/slim_sam_finetuned/checkpoint-epoch100"
# sam_checkpoint = "nielsr/slimsam-50-uniform"
sam_checkpoint = os.environ["SAM_CHECKPOINT"]

sam = SamModel.from_pretrained(sam_checkpoint)
processor = SamProcessor.from_pretrained(sam_checkpoint)

labels = torch.load('models/rcnn_labels.model', weights_only=True)
labels = {v: k for k, v in labels.items()}

if torch.cuda.is_available():
    device = torch.device('cuda')
else:
    device = torch.device('cpu')
device = torch.device('cpu')

loaded_model = get_model(num_classes = len(labels.keys()), device=device)
# loaded_model.load_state_dict(torch.load('models/retinanet_v2_dfg.model', map_location=device))
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

    height, width = pil_image.size

    if 'control_points' in request.POST:
        points = json.loads(request.POST['control_points'])
        input_point = [points]
    else:
        input_point = [[[width / 2, height / 2]]]

    inputs = processor(images=pil_image, input_points=input_point, return_tensors="pt")

    outputs = sam(**inputs, multimask_output=False)

    masks = processor.post_process_masks(
        outputs.pred_masks, inputs["original_sizes"], inputs["reshaped_input_sizes"]
    )

    masks = np.array([mask.squeeze(0).cpu().detach().numpy() for mask in masks])

    # save_masks_as_images(masks)

    # mask_sizes = masks.sum(axis=(2, 3))

    # largest_idx = mask_sizes.argmax()

    mask = masks[0]
    # score = scores[largest_idx]


    mask_uint8 = (mask * 255).astype(np.uint8)
    mask_uint8 = mask_uint8.transpose(1, 2, 0)

    cv2.imwrite("mask.png", mask_uint8)

    # mask_uint8 = cv2.cvtColor(mask_uint8, cv2.COLOR_RGB2GRAY)
    contours, _ = cv2.findContours(mask_uint8, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    contour = max(contours, key = cv2.contourArea) if len(contours) > 0 else []

    return { 'predictions': {
        # 'score': score.item(),
        'contour': contour.astype(int).tolist() #(cv2.convexHull(contour).astype(int).tolist())
    } }

if __name__ == '__main__':
    app.run(debug=True, reloader=True, host='0.0.0.0', port=9001)
