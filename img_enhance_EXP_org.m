function Ig33 = img_enhance_EXP(Ig11,n)
% n=10;
% I=(imread('C:\Users\LENOVO\Desktop\Prjct\79scans_000.jpg'));
%J=flipud(I);
% Ig=rgb2gray(I);
% [a b]=size(Ig);
% Ig11=Ig(100:450,[510:b-20]);
[r c]=size(Ig11);
%figure,imshow(Ig11);
p=size(Ig11,1);
q=size(Ig11,2);

Ig2=(zeros(size(Ig11)));
Ig3=(zeros(size(Ig11)));
Ig4=(zeros(size(Ig11)));

Ig_raw=(double(Ig11)/255).^4;
Ig1=Ig_raw;
Ig12=Ig1.^n;

for i=1:p
    for j=1:q
        temp=2*sum(double(Ig12(i:p,j)));
        Ig2(i,j)= (Ig1(i,j).^n/temp);        
    end
    Ig3(i,:)=i^2*Ig2(i,:);
end
% figure;imshow((Ig2));
% figure;imshow((Ig3));
Ig33 = im2bw(Ig3,graythresh(Ig3));
% % Ig33 = im2bw(Ig3,graythresh(Ig3));

% % imwrite(Ig1,'I_raw.jpg');
% % imwrite(Ig2,'I_expo_enhanced.jpg');
% % imwrite(Ig3,'I_expo_nonlinear_enhanced.jpg');
% % imwrite(Ig33,'I_binirized.jpg');

% % fun = @(block_struct) im2bw(block_struct.data,graythresh(block_struct.data));
% %     Ig333 = blockproc(Ig3,[100 100],fun);
% %     figure;imshow(Ig333);
% figure;imshow();
% figure;imshow(adapthisteq(Ig3));
minIg2=min(min(Ig3));
maxIg2=max(max(Ig3));
Ig5= Ig3;
% [x4 y4] = find(Ig3>.5*maxIg2);
% for i= length(x4)
%     Ig5(x4(i),y4(i))=maxIg2;
% end
maxIg5=max(max(Ig5));
minIg5=min(min(Ig5));


% for i=1:p
%     for j=1:q
%         Ig4(i,j)= 255*(Ig3(i,j)-minIg2)/(maxIg2-minIg2);        
%     end
% end 
for i=1:p
    for j=1:q
        Ig4(i,j)= 255*(Ig5(i,j)-minIg5)/(maxIg5-minIg5);        
    end
end 


end

% figure;imshow(uint8(Ig3));
% figure;imshow(uint8(Ig5));
% figure;imshow(uint8(Ig4));


% Imag=edge(Ig5,'canny',0.0035);
% figure,imshow(Imag);
