# Copyright (c) 2019 ETH Zurich, Lukas Cavigelli, Georg Rutishauser, Luca Benini
# This file, licensed under Apache 2.0 was taken from
# https://github.com/lukasc-ch/ExtendedBitPlaneCompression,
# commit 0b175d0d35937b3f2724fe59b0c6cc82802556f6

import torch
import torchvision as tv
import numpy as np
import random
import math


import os
import glob
import csv

import sys
sys.path.append('./quantLab')

def getModel(modelName, epoch=None):
#    import torchvision as tv
#    import quantlab.ImageNet.topology as topo

#    loss_func =  torch.nn.CrossEntropyLoss()
    model = None

    if modelName == 'alexnet':
        model = tv.models.alexnet(pretrained=True)
    elif modelName == 'squeezenet':
        model = tv.models.squeezenet1_1(pretrained=True)
    elif modelName == 'resnet34':
        model = tv.models.resnet34(pretrained=True)
    elif modelName == 'vgg16':
        model = tv.models.vgg16_bn(pretrained=True)
    elif modelName == 'mobilenet2':
        model = tv.models.mobilenet_v2(pretrained=True)

    device = torch.cuda.current_device() if torch.cuda.is_available() else torch.device('cpu')
    model = model.to(device)
    assert(model != None)
    return model, device


def getFMs(model, device, datasetPath, numBatches=1, batchSize=10, safetyFactor=0.75, frac=0.01):

    # CREATE DATASET LOADERS
    #import quantLab.quantlab.ImageNet.preprocess as pp
    #datasetTrain, datasetVal, _ =
    #pp.load_datasets('/scratch/datasets/ilsvrc12/', augment=False)
    transform = tv.transforms.Compose([
        tv.transforms.Resize(256),
        tv.transforms.RandomCrop(224),
        tv.transforms.ToTensor()
    ])
    dataset = tv.datasets.ImageFolder(datasetPath, transform=transform)
#    dataset = datasetVal
    model.eval()

    dataLoader = torch.utils.data.DataLoader(dataset, batch_size=batchSize, shuffle=False)

    # SELECT MODULES
    msReLU = list(filter(lambda m: type(m) == torch.nn.modules.ReLU or type(m) == torch.nn.modules.ReLU6, model.modules()))

    def filter_fmaps(tens4, frac):
        # select filt proportion of random channels of 4dim tensor
        if (tens4.dim()==4):
            num_chans = list(tens4.size())[1]
            indices = random.sample(range(num_chans), math.ceil(frac * num_chans))
            return tens4[:, indices, :, :]
        return tens4

    #register hooks to get intermediate outputs:
    def setupFwdHooks(modules):
      outputs = []
      def hook(module, input, output):
          outputs.append(filter_fmaps(output.detach().contiguous().clone(), frac))
      for i, m in enumerate(modules):
        m.register_forward_hook(hook)
      return outputs

    outputsReLU = setupFwdHooks(msReLU)

    # PASS IMAGES THROUGH NETWORK
    dataIterator = iter(dataLoader)



    for _ in range(numBatches):
      (image, target) = next(dataIterator)
      image, target = image.to(device), target.to(device)
      model.eval()
      outp = model(image)

    

    return outputsReLU
