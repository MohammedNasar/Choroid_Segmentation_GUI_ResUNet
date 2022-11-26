% indx,cropImgs1,CIB3D_Fill3,COB3D_Fill3,filePath,'sm',sx:sx+3
% indx,cropImgs,CIB3D_Fill2,COB3D_Fill2,filePath,'sm'
function cib_cob_path=plt_wf_cibcob1(cropImgs,CIB,COB,filePath,str,mn1_sz)
% function plt_wf_cibcob(ind,cropImgs,CIB,COB,filePath,str,mn1_sz)
% str='sm'
% mn1_sz=[];
% ind=indx;
% CIB=4*CIB3D_Fill2;
% COB=4*COB3D_Fill2;
% str='Segmentations_cib_cob_sm_';
cib_cob_path=strcat(filePath,date,'\Segmentations_',str,'_',date);%,'-',num2str(hr),'-',num2str(mints));
mkdir(cib_cob_path);
if isempty((mn1_sz))
    mn1_sz=1:size(cropImgs,3);
end
for mn1 = mn1_sz   %  mn1 = x1:x2
    printing_cib_cob=mn1
    clear Ih4;
%     Ih4(:,:,1)=crop_scans{mn1};
%     Ih4(:,:,2)=crop_scans{mn1};
%     Ih4(:,:,3)=crop_scans{mn1};
%     Ih4(:,ind(mn1,2):ind(mn1,3),1) = cropImgs(:,ind(mn1,2):ind(mn1,3),mn1);%,[sz(1:2)]);
%     Ih4(:,ind(mn1,2):ind(mn1,3),2) = cropImgs(:,ind(mn1,2):ind(mn1,3),mn1);%,[sz(1:2)]);
%     Ih4(:,ind(mn1,2):ind(mn1,3),3) = cropImgs(:,ind(mn1,2):ind(mn1,3),mn1);%,[sz(1:2)]);
    Ih4(:,:,1) = cropImgs(:,:,mn1);%,[sz(1:2)]);
    Ih4(:,:,2) = cropImgs(:,:,mn1);%,[sz(1:2)]);
    Ih4(:,:,3) = cropImgs(:,:,mn1);%,[sz(1:2)]);
    
    try
        for i=1:size(Ih4,2)-1

%             if round(CIB0(i,mn1)) < 3
%                 CIB0(i,mn1) = 3;
%             end
            if round(CIB(i,mn1)) < 3
                CIB(i,mn1) = 3;
            end
            if round(COB(i,mn1)) < 3
                COB(i,mn1) = 3;
            end
            X_coord = round(CIB(i,mn1))-2:round(CIB(i,mn1))+2;
            X_coord2 = round(CIB(i,mn1)+COB(i,mn1))-2:round(CIB(i,mn1)+COB(i,mn1))+2;

            Ih4(X_coord,i,1)=255;
            Ih4(X_coord,i,2)=255;
            Ih4(X_coord,i,3)=0;

            Ih4(X_coord2,i,1)=255;
            Ih4(X_coord2,i,2)=255;
            Ih4(X_coord2,i,3)=0;
        end
%         fname=fileNames{mn1};
%         fn=strcat('final_',fname(1:end-4));
        filname_COB_full = strcat(cib_cob_path,'\img',sprintf('%04d',mn1-1),'.jpg');
%         imshow(Ih4);
        imwrite(Ih4,filname_COB_full);
    catch ME
        fprintf('Failed to process scan numner %d: %s\n',mn1, ME.message);
        continue;
    end
end

