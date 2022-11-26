
import sys
import time
import os
import cv2
import numpy as np
import math
import tensorflow as tf
#physical_devices = tf.config.list_physical_devices('GPU') 
#tf.config.experimental.set_memory_growth(physical_devices[0], True)
from keras.models import Model
from keras.models import load_model
from keras.layers import Input, concatenate, Conv2D, MaxPooling2D, Activation, UpSampling2D, BatchNormalization
from tensorflow.keras.optimizers import RMSprop
from keras.callbacks import ModelCheckpoint, LearningRateScheduler

from keras.losses import binary_crossentropy
import keras.backend as K


import glob
from skimage import data
from skimage.transform import resize

import scipy.io as sio
import matplotlib.pyplot as plt

smooth = 1

def dice_coeff(y_true, y_pred):
    smooth = 1.
    y_true_f = K.flatten(y_true)
    y_pred_f = K.flatten(y_pred)
    intersection = K.sum(y_true_f * y_pred_f)
    score = (2. * intersection + smooth) / (K.sum(y_true_f) + K.sum(y_pred_f) + smooth)
    return score

def dice_loss(y_true, y_pred):
    loss = 1 - dice_coeff(y_true, y_pred)
    return loss

def Load_ImagesC(Loc):
    Images = []
    for root, dirs, files in os.walk(Loc):
        for file in files:
            Image = cv2.imread(os.path.join(root, file),1)
            Image = cv2.resize(Image, (256,256))
            Images.append(Image)
    Images = np.asarray(Images)
    return Images

def Load_Images(Loc):
    Images = []
    for root, dirs, files in os.walk(Loc):
        for file in files:
            Image = cv2.imread(os.path.join(root, file),0)
            Image = cv2.resize(Image, (256,256))
            Images.append(Image/255.0)
    Images = np.asarray(Images)
    return Images
#C:\Users\Kiran\Downloads\KiranUPMCAMD\AMD_12x12_500_IMG_ANG_PTEly_OD
# AMD_IMG_12x12_PTDcn_OD   AMD_12x12_500_IMG_ANG_PTEly_OD

inpDir=sys.argv[1];
h5f=sys.argv[2];
print(inpDir);
print(h5f);
x_test =  Load_Images(inpDir)
x_testC = Load_ImagesC(inpDir)
model = load_model(h5f, custom_objects={'dice_loss':dice_loss,'dice_coeff': dice_coeff})


print('111111')
start_time = time.time()
print("--- %s seconds ---" % start_time)


outDir=sys.argv[3];
#X_Test = np.load("imgs_mask_test.npy")
for i in range(len(x_test)):
    xtest_temp=x_test[i,:,:]
    x_test2 = xtest_temp.reshape(1,256,256,1)
    y = model.predict(x_test2, verbose=1)
    print('success!!!')
    #plt.hist(y(:))
    #sio.savemat(outDir+'/mask_'+str(i)+'.mat', y)
    y = y*255
    y = y.reshape(256,256)
    img1 = x_testC[i,:,:,:]
    mask = y>100
    img = np.uint8(img1)
    img[mask] = 255
    #y[mask] = 255
    #cv2.imwrite('DATA_Processed/New/Jay/PCZMI1121544606_Cube/PRE_1269_Y_100/outDeep256_'+str(i)+'.jpg',img)
    print(outDir+'/outDeep256_'+str(i)+'.jpg')    
    cv2.imwrite(outDir+'/mask_'+str(i)+'.jpg', y)
    cv2.imwrite(outDir+'/maskOverlayedImg_'+str(i)+'.jpg',img)
    print("--- %s seconds ---" % (time.time() - start_time))
    #sio.savemat('C:\Users\Kiran\Downloads\9_R_PCZMI803735871\08-Sep-2021\mask_08-Sep-2021-7-5\testmat.mat', y)
