"""
unet_inference.py

Script to run inference on images using a trained UNet model.
Outputs an image with the mask transparently overlaid on the original.

Usage:
  python unet_inference.py --input input.jpg --output overlay.png --model grain_unet_checkpoint.pth
  python unet_inference.py --input input_dir --output output_dir --model grain_unet_checkpoint.pth
"""

import os
import argparse
from pathlib import Path
from PIL import Image
import torch
import torch.nn as nn
import torchvision.transforms.functional as TF
import numpy as np
from glob import glob

# Import the UNet model definition from the training script
from train_unet import EnhancedViTSegmentation


class UNetInference:
    def __init__(self, model_path, device='auto', img_size=(224, 224)):
        """
        Initialize the UNet inference model.

        Args:
            model_path (str): Path to the trained model checkpoint
            device (str): Device to run inference on ('auto', 'cuda', 'cpu')
            img_size (tuple): Input image size (height, width)
        """
        if device == 'auto':
            self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        else:
            self.device = torch.device(device)

        self.img_size = img_size

        # Initialize model
        self.model = EnhancedViTSegmentation()
        self.load_model(model_path)
        self.model.to(self.device)
        self.model.eval()

        print(f"Model loaded on: {self.device}")
        print(f"Input size: {img_size}")

    def load_model(self, model_path):
        """Load trained model weights."""
        if not os.path.exists(model_path):
            raise FileNotFoundError(f"Model file not found: {model_path}")

        # Handle both full model and state_dict saves
        checkpoint = torch.load(model_path, map_location='cpu')
        if isinstance(checkpoint, dict) and 'model_state_dict' in checkpoint:
            self.model.load_state_dict(checkpoint['model_state_dict'])
        elif isinstance(checkpoint, dict):
            self.model.load_state_dict(checkpoint)
        else:
            self.model.load_state_dict(torch.load(model_path, map_location='cpu'))


    def save(self, image, output_path):
        """
        Save image.

        Args:
            image (PIL.Image): Image to save
            output_path (str): Output file path
        """
        image.save(output_path)

    def preprocess_image(self, image_path):
        """
        Preprocess image for model inference.

        Args:
            image_path (str): Path to input image

        Returns:
            torch.Tensor: Preprocessed image tensor
            PIL.Image: Original image
            tuple: Original image size (width, height)
        """
        # Load image
        original_image = Image.open(image_path).convert('RGB')

        original_size = original_image.size  # (width, height)

        # Resize to model input size
        image_resized = original_image.resize((self.img_size[1], self.img_size[0]), Image.BILINEAR)

        # Convert to tensor and normalize
        image_tensor = TF.to_tensor(image_resized).unsqueeze(0)  # Add batch dimension

        return image_tensor, original_image, original_size

    def predict_mask(self, image_path):
        """
        Run inference on a single image and return the mask.

        Args:
            image_path (str): Path to input image

        Returns:
            PIL.Image: Predicted mask (binary, same size as original)
            PIL.Image: Original image
        """
        # Preprocess
        image_tensor, original_image, original_size = self.preprocess_image(image_path)
        image_tensor = image_tensor.to(self.device)

        # Inference
        with torch.no_grad():
            output = self.model(image_tensor)

        # Postprocess mask
        # Remove batch dimension and apply sigmoid
        mask = torch.sigmoid(output).squeeze(0).squeeze(0)  # Remove batch and channel dim

        # Convert to numpy and threshold
        mask_np = mask.cpu().numpy()
        binary_mask = (mask_np > 0.5).astype(np.uint8) * 255

        # Convert to PIL Image and resize to original size
        mask_image = Image.fromarray(binary_mask)
        mask_image = mask_image.resize(original_image.size, Image.NEAREST)

        return mask_image, original_image

    def create_overlay(self, original_image, mask_image, overlay_color=(255, 0, 0), alpha=0.5):
        """
        Create a transparent overlay of the mask on the original image.

        Args:
            original_image (PIL.Image): Original RGB image
            mask_image (PIL.Image): Binary mask image (mode 'L')
            overlay_color (tuple): RGB color for the overlay (default: red)
            alpha (float): Transparency level (0.0-1.0, default: 0.5)

        Returns:
            PIL.Image: Image with transparent overlay (RGBA)
        """
        # Convert original to RGBA if needed
        if original_image.mode != 'RGBA':
            original_rgba = original_image.convert('RGBA')
        else:
            original_rgba = original_image.copy()

        # Create overlay image with the specified color
        overlay = Image.new('RGBA', original_rgba.size, overlay_color + (0,))  # Start transparent
        mask_array = np.array(mask_image)

        # Where mask is white, set the overlay to semi-transparent color
        overlay_array = np.array(overlay)
        mask_indices = mask_array > 0
        overlay_array[mask_indices] = (*overlay_color, int(255 * alpha))

        overlay = Image.fromarray(overlay_array, 'RGBA')

        # Composite the overlay onto the original image
        result = Image.alpha_composite(original_rgba, overlay)

        return result

    def predict_with_overlay(self, image_path, overlay_color=(255, 0, 0), alpha=0.5):
        """
        Run inference and return image with transparent overlay.

        Args:
            image_path (str): Path to input image
            overlay_color (tuple): RGB color for overlay
            alpha (float): Transparency level (0.0-1.0)

        Returns:
            PIL.Image: Image with transparent overlay
        """
        mask, original = self.predict_mask(image_path)
        overlay_image = self.create_overlay(original, mask, overlay_color, alpha)
        return overlay_image

    def process_directory(self, input_dir, output_dir, overlay_color=(255, 0, 0), alpha=0.5, output_format='png'):
        """
        Process all images in a directory with transparent overlays.

        Args:
            input_dir (str): Input directory containing images
            output_dir (str): Output directory for overlay images
            overlay_color (tuple): RGB color for overlay
            alpha (float): Transparency level
            output_format (str): Output image format
        """
        # Create output directory if it doesn't exist
        os.makedirs(output_dir, exist_ok=True)

        # Supported image extensions
        extensions = ['*.jpg', '*.jpeg', '*.png', '*.bmp', '*.tiff', '*.tif']
        image_paths = []

        for ext in extensions:
            image_paths.extend(glob(os.path.join(input_dir, ext)))
            image_paths.extend(glob(os.path.join(input_dir, ext.upper())))

        print(f"Found {len(image_paths)} images in {input_dir}")

        for i, image_path in enumerate(image_paths):
            try:
                print(f"Processing {i+1}/{len(image_paths)}: {os.path.basename(image_path)}")

                # Generate output path
                input_filename = Path(image_path).stem
                output_path = os.path.join(output_dir, f"{input_filename}_overlay.{output_format}")

                # Skip if output already exists
                if os.path.exists(output_path):
                    print(f"  Output exists, skipping: {output_path}")
                    continue

                overlay_image = self.predict_with_overlay(image_path, overlay_color, alpha)
                self.save(overlay_image, output_path)
                print(f"  Saved overlay: {output_path}")

            except Exception as e:
                print(f"  Error processing {image_path}: {e}")

        print(f"Finished processing {len(image_paths)} images")


def main():
    parser = argparse.ArgumentParser(description='UNet Image Segmentation with Transparent Overlay')
    parser.add_argument('--input', '-i', type=str, required=True,
                       help='Input image path or directory')
    parser.add_argument('--output', '-o', type=str, required=True,
                       help='Output image path or directory')
    parser.add_argument('--model', '-m', type=str, required=True,
                       help='Path to trained model checkpoint')
    parser.add_argument('--device', '-d', type=str, default='auto',
                       choices=['auto', 'cuda', 'cpu'],
                       help='Device to run inference on (default: auto)')
    parser.add_argument('--img_size', type=int, nargs=2, default=[224, 224],
                       metavar=('HEIGHT', 'WIDTH'),
                       help='Input image size (default: 224 224)')
    parser.add_argument('--output_format', '-f', type=str, default='png',
                       choices=['png', 'jpg', 'jpeg', 'bmp', 'tiff'],
                       help='Output image format (default: png)')
    parser.add_argument('--color', '-c', type=int, nargs=3, default=[255, 0, 0],
                       metavar=('R', 'G', 'B'),
                       help='Overlay color as RGB (default: 255 0 0 for red)')
    parser.add_argument('--alpha', '-a', type=float, default=0.5,
                       help='Overlay transparency (0.0-1.0, default: 0.5)')
    parser.add_argument('--save_mask', action='store_true',
                       help='Also save the binary mask separately')

    args = parser.parse_args()

    # Validate alpha value
    if not 0.0 <= args.alpha <= 1.0:
        print("Error: Alpha must be between 0.0 and 1.0")
        return

    # Initialize inference model
    try:
        inference_model = UNetInference(
            model_path=args.model,
            device=args.device,
            img_size=tuple(args.img_size)
        )
    except Exception as e:
        print(f"Error loading model: {e}")
        return

    # Check if input is file or directory
    if os.path.isfile(args.input):
        # Single image processing
        print(f"Processing single image: {args.input}")

        # Create output directory if needed
        output_dir = os.path.dirname(args.output)
        if output_dir:
            os.makedirs(output_dir, exist_ok=True)

        try:
            # Create overlay image
            overlay_color = tuple(args.color)
            overlay_image = inference_model.predict_with_overlay(
                args.input,
                overlay_color=overlay_color,
                alpha=args.alpha
            )

            overlay_image.save(args.output)

            # Optionally save mask separately
            if args.save_mask:
                mask, original = inference_model.predict_mask(args.input)
                mask_output = os.path.splitext(args.output)[0] + '_mask.png'
                mask.save(mask_output)
                print(f"Binary mask saved to: {mask_output}")

        except Exception as e:
            print(f"Error processing image: {e}")

    elif os.path.isdir(args.input):
        # Directory processing
        print(f"Processing directory: {args.input}")

        inference_model.process_directory(
            input_dir=args.input,
            output_dir=args.output,
            overlay_color=tuple(args.color),
            alpha=args.alpha,
            output_format=args.output_format
        )

    else:
        print(f"Input path not found: {args.input}")


if __name__ == '__main__':
    main()
