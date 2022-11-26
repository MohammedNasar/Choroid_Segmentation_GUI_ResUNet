


function enf_img=enfImg(cib,cob,cimgs)
cib=CIB3D_Fill3;
cob=COB3D_Fill3;
cimgs=cropImgs1;
% str1=strsplit(filePath,'\');
% str2{4}='SPCAAngioSegmentations_Pt2_CSCR';
n=round(min(min(cib)))-1
img=zeros([n size(cob)]);

for i=1:size(cib,2)%-24-60
    enf_img_iteration=i
%     mimg=crop_scans{i};
    mimg=squeeze(cimgs(:,:,i));
    for j=1:size(cib,1) %indx5(i,2):indx5(i,3)
        img(:,j,i)=mimg(round(cib(j,i))-n+1:round(cib(j,i)),j);
    end
end
n
% div=1;
% enf_img=uint8(squeeze(mean(img(end-round(120/div):end-round(80/div),:,:),1)));
enf_img=uint8(squeeze(mean(img(end-20:end-10,:,:),1)));
figure;imshow(enf_img);
% str1{6}
% imwrite(enf_img,strcat('Enface_',str1{6},'_',date,'.jpg'));
test_point=11


