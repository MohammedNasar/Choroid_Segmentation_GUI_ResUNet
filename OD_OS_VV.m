
movefile Data.mat Data_old.mat
clearvars;clc;
load('Data_old.mat')
CIB3D_Fill3 = flipud(CIB3D_Fill3);
COB3D_Fill3 = flipud(COB3D_Fill3);
enf_img = flipud(enf_img);
save('Data.mat');
figure;imshow(enf_img')


