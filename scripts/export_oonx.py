import torch
from mobile_sam import sam_model_registry, SamPredictor

sam_checkpoint = "models/mobile_sam.pt"
model_type = 'vit_t'

sam = sam_model_registry[model_type](checkpoint=sam_checkpoint)

dummy_input = torch.randn(1, 3, 1024, 1024)
torch.onnx.export(sam.image_encoder, dummy_input, "models/mobile_sam.onnx")

