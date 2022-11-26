
img=[];
ofset=600;
cropImgs1=cropImgs;
for mn1=x1:x2
    cropImgs1(:,indx5(mn1,4):indx5(mn1,5),mn1)= NaN;
    cropImgs1(:,indx5(mn1,4):indx5(mn1,5),mn1)= NaN;
end

str1=strsplit(filePath,'\');

n=round(min(min(CIB3D_Fill3)))-1+ofset;
for i=1:size(CIB3D_Fill3,2)
%      i
%     mimg=crop_scans{i};
% %     mimg=squeeze(cropImgs(:,:,i));
%     for j=1:size(mimg,2)
%         img(:,j,i)=mimg(round(CIB3D_Fill3(j,i))-n+1:round(CIB3D_Fill3(j,i)),j);
%     end
    i
%     mimg=crop_scans{i};
%     mimg=squeeze(imgs(:,:,i));

    mimg=squeeze(cropImgs1(:,:,i));
    mimg_temp=zeros(size(mimg,1)+ofset,size(mimg,2));
    mimg_temp(ofset+1:end,:)=mimg;
    for j=1:size(mimg_temp,2)
        img(:,j,i)=mimg_temp(round(CIB3D_Fill4(j,i))+1:round(CIB3D_Fill4(j,i))+ofset,j);
    end
end
n
div=1;

enf_img=uint8(squeeze(mean(img(end-round(140/div):end-round(100/div),:,:),1)));
% enf_img=uint8(squeeze(mean(img(end-120:end-40,:,:),1)));
figure;imshow(enf_img);
