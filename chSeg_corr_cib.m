
function [cib1,rang,rangc] = chSeg_corr_cib(cib,uinp)
% 
% uinp='100-400,550';
% uinp='100-200,500-550,590,800-900,1000,1004';
% clear cib cib1 cob cob2;
% cib=CIB3D_Fill3;
% cob=COB3D_Fill3;
% uinp='100-200,500-550,590,800-900,1000,1004';
sx = size(cib,2);
sy = size(cib,1);
% o1=-27;o2=11;
o1=0;o2=90;
figure(1);mesh(cib);
% title(strcat('cob and cob surfaces before correction....',str1{6}), 'Interpreter', 'none');
title('CIB before correction');
% view(o1,o2);

% str1=split(uinp,',')';
% nrang=length(str1);
% rang=[];
% for i=1:nrang
%     str2 = split(str1{i},'-')';
%     if length(str2)==2
%         rang = [rang;str2double(str2{1}) str2double(str2{2})];
%     else
%         rang = [rang;str2double(str2{1}) str2double(str2{1})];
%     end
%     clear str2;
% end
% rangc=[];
% rangc=1:rang(1,1)-1;
% for i=1:nrang-1
%     rangc = [rangc rang(i,2)+1:rang(i+1,1)-1];
% end
% rangc=[rangc rang(i+1,2)+1:sx];

uinp_range

for i = 1:size(rang,1)
    rang1 = rang(i,1):rang(i,2);
    cib(:,rang1)= NaN;
end

figure(2);mesh(cib);view(o1,o2);
title('CIB surface at correction step');
% title(strcat('cob surface while correction....',str1{6}), 'Interpreter', 'none');
for mn2=1:sy
    mn2

    cib1(mn2,:) = interp1(rangc,cib(mn2,rangc),1:sx,'linear','extrap');
%     cib1(mn2,:)=smooth(interp1([1:l1-1 l2+1:sx],cib(mn2,[1:l1-1 l2+1:sx]),1:sx,'linear','extrap'),0.2,'rloess');
%     cob1(mn2,:)=smooth(interp1([1:l1-1 l2+1:sx],cob(mn2,[1:l1-1 l2+1:sx]),1:sx,'linear','extrap'),0.2,'rloess');
end
% cib2=cib1;
% cib2(:,l1:l2)=smoothdata(cib1(:,l1:l2),1,'rloess');
% cob2=cob1;
% cob2(:,l1:l2)=smoothdata(cob1(:,l1:l2),1,'rloess');

figure(3);mesh(cib1);
% title(strcat('cib and cob surfaces before correction....',str1{6}), 'Interpreter', 'none');
title('CIB surface after correction');
% view(o1,o2);

