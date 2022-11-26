
function enf_img = enfImg1(cib,cropImgs)
img=[];
ofset=600;
n=round(min(min(cib)))-1+ofset;
for i=1:size(cib,2)
%      i
%     mimg=crop_scans{i};
% %     mimg=squeeze(cropImgs(:,:,i));
%     for j=1:size(mimg,2)
%         img(:,j,i)=mimg(round(cib(j,i))-n+1:round(cib(j,i)),j);
%     end
    i
%     mimg=crop_scans{i};
%     mimg=squeeze(imgs(:,:,i));

    mimg=squeeze(cropImgs(:,:,i));
    mimg_temp=zeros(size(mimg,1)+ofset,size(mimg,2));
    mimg_temp(ofset+1:end,:)=mimg;
    for j=1:size(mimg_temp,2)
        if cib(j,i) <=0
            cib(j,i) =1;
        end
        img(:,j,i)=mimg_temp(round(cib(j,i))+1:round(cib(j,i))+ofset,j);
    end
end
n
div=1;

enf_img = uint8(squeeze(mean(img(end-round(40/div):end-round(20/div),:,:),1)));
% enf_img=uint8(squeeze(mean(img(end-120:end-40,:,:),1)));

% figure; imshow(enf_img);


