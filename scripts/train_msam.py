# train_sam.py
import os
from glob import glob
from tqdm.auto import tqdm

import numpy as np
from PIL import Image, ImageOps, ImageDraw

import torch
from torch import nn
from torch.utils.data import DataLoader
from torch.optim import AdamW
from torch.utils.data import Dataset

from torchvision.transforms import v2 as transforms
from torchvision.transforms import InterpolationMode
import torchvision.transforms as T

import matplotlib.pyplot as plt

# Hugging Face imports
from transformers import SamModel, SamProcessor, infer_device

def tensor_to_pil(tensor):
    tensor = tensor.detach().cpu()
    if tensor.max() <= 1.0:
        tensor = tensor * 255
    tensor = tensor.byte()
    return T.ToPILImage()(tensor)

def draw_circle_on_image(pil_img, x, y, radius=10):
    # Create a copy to avoid modifying original
    img_with_circle = pil_img.copy()
    draw = ImageDraw.Draw(img_with_circle)

    # Calculate circle bounding box
    bbox = [x - radius, y - radius, x + radius, y + radius]

    # Draw red circle (outline)
    draw.ellipse(bbox, outline='red', width=3)

    # Optional: Draw a small red dot in the center
    dot_radius = 2
    dot_bbox = [x - dot_radius, y - dot_radius, x + dot_radius, y + dot_radius]
    draw.ellipse(dot_bbox, fill='red')

    return img_with_circle

class SingleImageSegDataset(Dataset):
    """
    A custom PyTorch Dataset for semantic segmentation.
    It loads an image and its corresponding mask and prepares them
    for the SegFormerForSemanticSegmentation model.
    """
    def __init__(self, image_dir, mask_dir, transform, image_transform, resize_to = (512, 512), hflip_prob = 0.5):
        self.image_dir = image_dir
        self.mask_dir = mask_dir
        self.transform = transform
        self.tf_to_tensor = transforms.ToTensor()
        self.image_transform = image_transform
        self.resize_to = resize_to
        self.hflip_prob = hflip_prob

        mask_paths = sorted(glob(os.path.join(mask_dir, "*.*")))

        self.pairs = []

        for img_path in mask_paths:
            basename = os.path.basename(img_path)
            image_path = os.path.join(image_dir, basename)
            if os.path.exists(image_path):
                self.pairs.append((image_path, img_path))
            else:
                print(f"Warning: No image found for {img_path}")

    def __len__(self):
        return len(self.pairs)

    def __getitem__(self, idx):
        image_path, mask_path = self.pairs[idx]
        image = Image.open(image_path).convert("RGB")

        orig_w, orig_h = image.size

        # Load the target mask and convert to class indices
        # Assuming your masks are binary (0=background, 1=foreground)
        mask = Image.open(mask_path).convert("L")  # Convert to grayscale
        mask = ImageOps.invert(mask)

        image = self.tf_to_tensor(image) # [C,H,W] float 0..1
        mask = self.tf_to_tensor(mask)

        image, mask = self._apply_transforms(image, mask)

        if self.image_transform:
            image = self.image_transform(image)

        np_mask = mask.numpy()
        coords = np.argwhere(np_mask > 0)
        _, y, x = np.array(coords[np.random.randint(len(coords))])

        # print(image_path)
        # print(mask_path)

        # pil = tensor_to_pil(mask)
        # pil = draw_circle_on_image(pil, x, y)
        # plt.imshow(pil)
        # plt.title(image_path)
        # plt.show()
        # raise

        # normalize mask to 0/1
        mask = (mask > 0).float()#.unsqueeze(0)

        # plt.imshow(tensor_to_pil(mask))
        # plt.title("late")
        # plt.show()

        return {
            "image_tensor": image,
            "center_point": np.array([[x, y]], dtype=np.float32),
            "mask": mask,
            "orig_size": (orig_h, orig_w),
            # "filename": image_path,
        }

    def _apply_transforms(self, image, mask):
        """Example transforms implemented with torchvision.functional so image+mask get identical ops.
           You can add/remove transforms here.
        """
        # Optional resize first (use bilinear for image, nearest for mask)
        if self.resize_to:
            image = transforms.functional.resize(image, self.resize_to, interpolation=InterpolationMode.BILINEAR)
            mask  = transforms.functional.resize(mask,  self.resize_to, interpolation=InterpolationMode.BILINEAR)

        # Random horizontal flip (same coin flip)
        # if random.random() < self.hflip_prob:
        #     image = transforms.functional.hflip(image)
        #     mask  = transforms.functional.hflip(mask)

        #     angle = random.randint(-90, 90)

        #     image = transforms.functional.rotate_image(image, angle)
        #     mask = transforms.functional.rotate_image(mask, angle)

        # (Add other transforms here — rotations, color jitter for image only, etc.)
        # Example: color jitter should be applied to image only, not mask:
        from torchvision.transforms import ColorJitter
        color_jitter = ColorJitter(brightness=0.2, contrast=0.2)
        image = color_jitter(image)

        return image, mask

# ---------- Training function ----------
def train(
    image_dir,
    mask_dir,
    output_dir="sam_finetuned",
    epochs=5,
    batch_size=4,
    lr=1e-5,
    weight_decay=0.0,
    device=None,
    num_workers=4,
    resize_to=(512,512),
    hflip_prob=0.5,
):
    device = device or infer_device()
    print("Using device:", device)

    # Load model + processor
    # model_name = "nielsr/slimsam-50-uniform"
    model_name = "models/slim_sam_finetuned/checkpoint-epoch100"
    processor = SamProcessor.from_pretrained(model_name)
    model = SamModel.from_pretrained(model_name)
    model.to(device)
    model.train()

    # IMPORTANT: to reduce memory, you can freeze the vision encoder and only train the prompt encoder + mask decoder.
    # Below we freeze the vision encoder parameters and only leave the prompt_encoder + mask_decoder trainable.
    # This is optional — uncomment whichever parts you want to train.
    # for name, p in model.named_parameters():
    #     p.requires_grad = True

    # Example: freeze vision encoder (saves memory & compute)
    # for n, p in model.named_parameters():
    #     if n.startswith("vision_encoder"):
    #         p.requires_grad = False

    # assume SingleImageSegDataset is in scope
    dataset = SingleImageSegDataset(
        image_dir=image_dir,
        mask_dir=mask_dir,
        transform=None,            # you already implement transforms in that class
        image_transform=None,      # optional normalization is handled by processor
        resize_to=resize_to,
        hflip_prob=hflip_prob,
    )

    dataloader = DataLoader(
        dataset,
        batch_size=batch_size,
        shuffle=True,
        # collate_fn=lambda b: collate_fn(b, processor),
        num_workers=num_workers,
        # pin_memory=True,
    )

    # Optimizer: only params that require_grad
    optimizer = AdamW([p for p in model.parameters() if p.requires_grad], lr=lr, weight_decay=weight_decay)
    criterion = nn.BCEWithLogitsLoss()

    os.makedirs(output_dir, exist_ok=True)

    global_step = 0
    for epoch in range(epochs):
        pbar = tqdm(dataloader, desc=f"Epoch {epoch+1}/{epochs}")
        epoch_loss = 0.0
        n_batches = 0
        for batch in pbar:
            # inputs is a dict returned by the processor with tensors on device
            # gt_masks is (B,1,H',W') float 0..1 on device

            masks = batch['mask'].to(device)

            optimizer.zero_grad()

            inputs = processor(
                images=batch['image_tensor'],
                input_points=batch['center_point'],
                return_tensors="pt",
                do_rescale=False,
            )
            inputs = inputs.to(device)

            # Forward
            outputs = model(**inputs, multimask_output=False)  # outputs.pred_masks etc.
            # outputs.pred_masks: (B, num_multimask_outputs, H', W') or (B,1,H',W') depending on config.

            # If SAM returns multiple mask proposals per input (num_multimask_outputs > 1),
            # we can pick the "best" mask per-image using the iou_scores or just take the first mask.
            # Here for simplicity we will use the first mask (index 0).
            # If outputs.iou_scores exist you could match best mask per-image instead.
            # if pred_masks.dim() == 4 and pred_masks.shape[1] > 1:
            #     # take first mask channel (or consider weighting)
            #     pred = pred_masks[:, 0:1, :, :]  # (B,1,H',W')
            # else:
            #     pred = pred_masks  # (B,1,H',W') or (B,H',W')

            # pred = processor.post_process_masks(
            #     outputs.pred_masks, inputs["original_sizes"], inputs["reshaped_input_sizes"]
            # )

            # print(outputs.pred_masks.shape)
            pred = outputs.pred_masks

            pred = pred.squeeze(2)

            pred = torch.nn.functional.interpolate(pred, size=(512, 512), mode='bilinear', align_corners=False)
            # pred = torch.sigmoid(pred[:, 0])

            # pil1 = tensor_to_pil(pred[0])
            # pil2 = tensor_to_pil(masks[0])

            # point = batch['center_point'][0][0].detach().cpu().numpy()
            # x, y = int(point[0]), int(point[1])

            # pil1 = draw_circle_on_image(pil1, x, y, 10)
            # pil2 = draw_circle_on_image(pil2, x, y, 10)

            # # Create combined image
            # width = pil1.width + pil2.width
            # height = max(pil1.height, pil2.height)

            # combined = Image.new('RGB', (width, height), (255, 255, 255))
            # combined.paste(pil1, (0, 0))
            # combined.paste(pil2, (pil1.width, 0))

            # # Display
            # combined.show()
            # plt.show()

            loss = criterion(pred, masks)
            # loss = (-masks * torch.log(pred + 0.00001) - (1 - masks) * torch.log((1 - pred) + 0.00001)).mean() # cross entropy loss

            loss.backward()
            optimizer.step()

            step_loss = loss.item()
            epoch_loss += step_loss
            n_batches += 1
            global_step += 1

            pbar.set_postfix({"loss": f"{step_loss:.4f}"})

        avg_loss = epoch_loss / max(1, n_batches)
        print(f"Epoch {epoch+1} finished — avg loss: {avg_loss:.4f}")

        # Save checkpoint (model + processor)
        ckpt_path = os.path.join(output_dir, f"checkpoint-epoch{epoch+1}")
        os.makedirs(ckpt_path, exist_ok=True)
        print("Saving checkpoint to:", ckpt_path)
        model.save_pretrained(ckpt_path)
        processor.save_pretrained(ckpt_path)

    print("Training finished. Final checkpoint saved to:", output_dir)


# ---------- If run as script ----------
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--image_dir", required=True)
    parser.add_argument("--mask_dir", required=True)
    parser.add_argument("--output_dir", default="sam_finetuned")
    parser.add_argument("--epochs", type=int, default=5)
    parser.add_argument("--batch_size", type=int, default=4)
    parser.add_argument("--lr", type=float, default=1e-5)
    parser.add_argument("--num_workers", type=int, default=1)
    parser.add_argument("--resize", type=int, nargs=2, default=(512,512))
    args = parser.parse_args()

    train(
        image_dir=args.image_dir,
        mask_dir=args.mask_dir,
        output_dir=args.output_dir,
        epochs=args.epochs,
        batch_size=args.batch_size,
        lr=args.lr,
        num_workers=args.num_workers,
        resize_to=tuple(args.resize),
    )

# poetry run python scripts/train_msam.py --image_dir training_data/grain_masks/images/ --mask_dir training_data/grain_masks/masks/ --output_dir models/slim_sam_finetuned --epochs 100 --batch_size 2
