% 
% function im=imfil(data)
% im=zeros(size(data));
% for i = 1:1:size(data,3)
%     img=imfill(data(:,:,i),'holes');
% %     img1=imclose(img,ones(8,8));
%     img1=img;
%     img2=imfill(img1,'holes');
%     im(:,:,i)=img2;
% end


function im=imfil(data)
im=zeros(size(data));
for i = 1:1:size(data,3)
%     img=imfill(squeeze(data(:,:,i)),'holes');
%     img=imfill(data(:,:,i),'holes');
%     img1=imclose(img,ones(8,8));
%     img2=imfill(img,'holes');
%     img2=imfill(img1,'holes');
% figure;subplot(211);imshow(squeeze(data(:,:,i)));subplot(212);imshow(imbinarize(squeeze(data(:,:,i))));
%     im(:,:,i)=imfill((squeeze(data(:,:,i))),'holes');
    im(:,:,i)=imfill(imbinarize(squeeze(data(:,:,i))),'holes');
end