import numpy as np
import torch
import torch.utils.data
from PIL import Image, ImageDraw
import torchvision
import time
import transforms as T
import torchvision.transforms as TT
import os
import xml.etree.ElementTree as ET
import torchvision.transforms.functional as FT
from tqdm.auto import tqdm

pil_transform = TT.ToPILImage()

name_map = {
    'skeleton_left_side': 'skeleton',
    'skeleton_right_side': 'skeleton',
    'arrow_left': 'arrow',
    'arrow_right': 'arrow',
    'arrow_up': 'arrow',
    'arrow_down': 'arrow',
    'skeleton_photo_left_side': 'skeleton_photo',
    'skeleton_photo_right_side': 'skeleton_photo',
    'compass_right': 'arrow',
    'compass_left': 'arrow',
    'compass_up': 'arrow',
    'compass_down': 'arrow',
    'grave_good': 'good',
    'stone': 'stone_tool',
    'skeletonm': 'skeleton'
}

class DfgDataset(torch.utils.data.Dataset):
    def __init__(self, root, transforms=None, labels={}):
        self.root = root
        self.transforms = transforms
        self.imgs = [x for x in sorted(os.listdir(root)) if x.endswith('.xml')]
        self.imgs = [os.path.join(self.root, img) for img in self.imgs]
        self.labels = labels
        # self.labels = torch.load('models/retinanet_labels_large.model')
        # self.labels = {v: k for k, v in self.labels.items()}
        self.counter = 0
        self.labels = {
            'scale': 0
        }

        # for xml_path in self.imgs:
        #     xml = ET.parse(xml_path)
        #     root = xml.getroot()

        #     objects = root.findall('object')
        #     labels = [object.find('name').text for object in objects]

        #     for name in labels:
        #         if name in name_map:
        #             name = name_map[name]

        #         if name not in self.labels:
        #             self.labels[name] = self.counter
        #             self.counter += 1

    def get_label(self, name):
        if name in name_map:
            name = name_map[name]
        return self.labels[name]


    def __getitem__(self, idx):
        # load images and bounding boxes
        xml_path = self.imgs[idx]
        img_path = xml_path.replace('.xml', '.jpg').replace('ý', 'y').replace('š', 's')
        img = Image.open(img_path).convert("RGB")

        xml = ET.parse(xml_path)
        root = xml.getroot()

        objects = root.findall('object')

        labels = []
        bnd_boxes = []
        for object in objects:
            label = object.find('name').text
            if label == 'scale':
                labels.append(self.get_label(label))
                bnd_boxes.append(object.find('bndbox'))

        labels = torch.tensor(labels)

        boxes = torch.tensor([
            [
                int(box.find('xmin').text), #* x_factor,
                int(box.find('ymin').text), #* y_factor,
                int(box.find('xmax').text), #* x_factor,
                int(box.find('ymax').text) #* y_factor
            ]

                for box in bnd_boxes
            ])

        return FT.to_tensor(img), {
            'boxes': boxes,
            'labels': labels,
        }

    def __len__(self):
        return len(self.imgs)

def collate_fn(batch):
    return tuple(zip(*batch))

def get_model(num_classes, device):
    # load an object detection model pre-trained on COCO
    # weights = torchvision.models.detection.RetinaNet_ResNet50_FPN_V2_Weights.COCO_V1
    # model = torchvision.models.detection.retinanet_resnet50_fpn_v2(weights=weights, trainable_backbone_layers=5)

    # out_channels = model.head.classification_head.conv[0].out_channels
    # num_anchors = model.head.classification_head.num_anchors
    # model.head.classification_head.num_classes = num_classes

    # cls_logits = torch.nn.Conv2d(out_channels, num_anchors * num_classes, kernel_size=3, stride=1, padding=1)
    # torch.nn.init.normal_(cls_logits.weight, std=0.01)  # as per pytorch code
    # torch.nn.init.constant_(cls_logits.bias, -math.log((1 - 0.01) / 0.01))  # as per pytorcch code
    # # # assign cls head to model
    # model.head.classification_head.cls_logits = cls_logits
    # model = torchvision.models.detection.retinanet_resnet50_fpn_v2(num_classes=num_classes, trainable_backbone_layers=5)

    model = torchvision.models.detection.fasterrcnn_resnet50_fpn_v2(num_classes=num_classes, trainable_backbone_layers=5)
    # model = torchvision.models.detection.fcos_resnet50_fpn(num_classes=num_classes)
    # model.load_state_dict(torch.load('models/fcos_grain_wise.model', map_location=device))
    # model.load_state_dict(torch.load('models/rcnn_dfg.model', map_location=device))
    # model.load_state_dict(torch.load('models/retinanet_v2_dfg_new.model', map_location=device))
    return model

def get_transform(train):
   transforms = []
   # converts the image, a PIL image, into a PyTorch Tensor
   transforms.append(T.PILToTensor())
#    if train:
      # during training, randomly flip the training images
      # and ground-truth for data augmentation
    #   transforms.append(T.RandomHorizontalFlip(0.5))
   return T.Compose(transforms)

if __name__ == '__main__':
    dfg_dataset = DfgDataset(root="training_data/object detection", transforms = get_transform(train=True))
    # dataset_test = DfgDataset(root="pdfs/page_images", transforms = get_transform(train=False), labels=dfg_dataset.labels)
    # split the dataset in train and test set

    torch.save(dfg_dataset.labels, 'models/rcnn_labels.model')

    torch.manual_seed(0)

    indices = torch.randperm(len(dfg_dataset)).tolist()
    train_dataset, test_dataset = torch.utils.data.random_split(dfg_dataset, [0.8, 0.2])


    data_loader = torch.utils.data.DataLoader(
                train_dataset, batch_size=2, shuffle=True, num_workers=2,
                collate_fn=collate_fn)
    data_loader_test = torch.utils.data.DataLoader(
                test_dataset, batch_size=2, shuffle=False, num_workers=2,
                collate_fn=collate_fn)
    print("We have: {} examples, {} are training and {} testing".format(len(indices), len(train_dataset), len(test_dataset)))

    if torch.cuda.is_available():
        device = torch.device('cuda')
    else:
        device = torch.device('cpu')

    # our dataset has two classes only - raccoon and not racoon
    num_classes = len(dfg_dataset.labels.keys())
    # get the model using our helper function
    model = get_model(num_classes, device)
    # move model to the right device
    model.to(device)
    # construct an optimizer
    params = [p for p in model.parameters() if p.requires_grad]
    optimizer = torch.optim.SGD(
        params, lr=0.002, momentum=0.9, weight_decay=0.0005
    )
    # optimizer = torch.optim.Adam(params, lr=1e-4)

    num_epochs = 50
    for epoch in range(num_epochs):
        start = time.time()
        model.train()

        prog_bar = tqdm(data_loader, total=len(data_loader))

        epoch_loss = 0
        for images, targets in prog_bar:
            images = list(image.to(device) for image in images)
            targets = [{k: v.to(device) for k, v in t.items()} for t in targets]

            loss_dict = model(images, targets)
            losses = sum(loss for loss in loss_dict.values())

            optimizer.zero_grad()
            losses.backward()
            optimizer.step()

            prog_bar.set_description(desc=f"Loss: {losses:.4f}")

            epoch_loss += losses

        # model.eval()
        with torch.no_grad():
            for images, targets in data_loader_test:
                images = list(image.to(device) for image in images)
                targets = [{k: v.to(device) for k, v in t.items()} for t in targets]

                loss_dict = model(images, targets)
                losses = sum(loss for loss in loss_dict.values())

                print(f'validation loss: {losses}')

        print(f'epoch_loss: {epoch_loss}', f'time: {time.time() - start}')

        torch.save(model.state_dict(), 'models/rcnn_grain_wise.model')
        # 100 epochs so far
