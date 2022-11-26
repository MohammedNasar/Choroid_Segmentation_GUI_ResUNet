function [Ig12 K L K_hat L_hat] = ShadowremovalAndEnhancement2(Ig11,n)
% n=10;
% I=(imread('C:\Users\LENOVO\Desktop\Prjct\79scans_000.jpg'));
%J=flipud(I);
% Ig=rgb2gray(I);
% [a b]=size(Ig);
% Ig11=Ig(100:450,[510:b-20]);
% % % [fileNames,filePath,fileIndex] = uigetfile('MultiSelect','on','*.*');
% % % 
% % %       comp_filename_rawimage1 = strcat(filePath,fileNames);%{1}
% % %     aa22=imread(comp_filename_rawimage1);        
% % %         if size(aa22,3)==3
% % %             a11 = rgb2gray(aa22);
% % %         else
% % %             a11 = rgb2gray(aa22(:,:,1:3));
% % %         end
% % %     Remove_Enface =  selectROI(a11,[]);
% % %     a2=Remove_Enface{1};
% % %     b21=a2(3:end);
% % %     c21=str2num(b21);
% % %     c2 = c21;
% % %    I = a11(c2(2):c2(2)+c2(4),c2(1)+10:c2(1)+c2(3)-10);
% % %    
% % % 
% % % n=2
% % % 
% % % 
% % % 
% % % %%
% % % Ig11 = I;%adapthisteq(I,'NumTiles',[8 8];
% Ig1=double(Ig11);
Ig1=(double(Ig11)/255).^4;
Ig12=uint8(255*(Ig1).^(1/4));
K = (Ig1./(flipud(cumtrapz(flipud(Ig1))))).^n;
L=(Ig1.^n)./ (flipud(cumtrapz(flipud(Ig1.^n))));

K_hat = uint8(255*(K).^(1/4));
L_hat = uint8(255*(L).^(1/4));

