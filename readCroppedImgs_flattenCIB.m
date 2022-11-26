
clearvars;clc;
% load cropped Images
% load C:\Users\ee12p\Downloads\Data_Angio_Pt81_20210709_OS.mat
% load C:\Users\ee12p\Downloads\Data_Angio_Pt81_20210709_OD.mat

load D:\Choroid\Code\GUI\WF\Ch_Topo_gui\Choroid_Topography_MatFiles\Angio_Pt82_20210709_OD\Data.mat

[fns,fPath,~] = uigetfile('MultiSelect','on','D:\Choroid\Data\WideField_Datasets\Amrish_New\img*.jpg');

len = length(fns);

fPath0   = strfind(fPath,'\');
ch_vol_fd = strcat(fPath(1:fPath0(end-1)),'Choroid_Vol');
flt_vol_fd = strcat(fPath(1:fPath0(end-1)),'Choroid_Vol_Fl_CIB');
flt_bvol_fd = strcat(fPath(1:fPath0(end-1)),'Choroid_bVol_Fl_CIB');
mkdir(ch_vol_fd);
mkdir(flt_vol_fd);
mkdir(flt_bvol_fd);
img_sz = imread(strcat(fPath,fns{1}));
sz = size(img_sz,1);
sy = size(img_sz,2);
img = zeros(sz,sy,len);
for i = 1:len
    img(:,:,i) = imread(strcat(fPath,fns{i}));
end

cropImgs = imresize3(img,[size(img,1) size(CIB3D_Fill3)]);
bVol = zeros([round(sz/4) size(img,[2 3])]);
max_sz = round(max(max(COB3D_Fill3)));

% binarization

for i = 1:size(bVol,3)
    binarization_count = i
%     img(:,:,i) = imread(strcat(fPath,fns{i}));
    bVol(:,:,i) = imcomplement(img_enhance_EXP_org((adapthisteq(imadjust(medfilt2 ...
        (ShadowremovalAndEnhancement2(imresize(img(:,:,i),[round(sz/4) sy]),2),[8 8])))),6));
    
%     imcomplement(phansalkar(adapthisteq(medfilt2(imresize(img(:,:,i)...
%         ,[round(sz/4) sy]),[2 2])),[20 20])); % binarize B-scans
end
bVol1 = imresize3(bVol,size(cropImgs));
% Flattening choroid based on CIB

cib = round(CIB3D_Fill3);
cob = round(COB3D_Fill3);
ch = zeros(size(cropImgs));
flt_ch = zeros([max_sz-10 size(cib)]);
bVol2 = zeros([max_sz-10 size(cib)]);
for i = 1:size(cropImgs,3)
    printing_img = i
    for j = 1:size(cropImgs,2)
        ch(cib(j,i):cib(j,i)+cob(j,i),j,i) = cropImgs(cib(j,i):cib(j,i)+cob(j,i),j,i);
        flt_ch(1:cob(j,i)-9,j,i) = cropImgs(cib(j,i)+10:cib(j,i)+cob(j,i),j,i);
        bVol2(1:cob(j,i)-9,j,i) = bVol1(cib(j,i)+10:cib(j,i)+cob(j,i),j,i);
    end
    imwrite(uint8(squeeze(ch(:,:,i))),strcat(ch_vol_fd,'\img',sprintf('%04d',i),'.jpg'))
    imwrite(uint8(squeeze(flt_ch(:,:,i))),strcat(flt_vol_fd,'\img',sprintf('%04d',i),'.jpg'))
    imwrite(imbinarize(squeeze(bVol2(:,:,i))),strcat(flt_bvol_fd,'\img',sprintf('%04d',i),'.jpg'))
end

