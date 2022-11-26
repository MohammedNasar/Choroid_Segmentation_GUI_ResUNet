

% clearvars;clc;
function [segPath2,CIB3D_Fill3,COB3D_Fill3,filePath,imgs1] = Ch_Topography_Seg_500_250_6x6_1()
% clearvars;clc;
% close all;
% [FileName PathName] = uigetfile('D:\Applications\Matlab6p5\work\*.m;*.mdl;*.mat','MATLAB Files');
[fileNames,filePath0,~] = uigetfile('MultiSelect','on','E:\Data_UPitt_LPTP\Amrish_12Oct12\img*.jpg');
% [fileNames,filePath0,~] = uigetfile('MultiSelect','on','E:\Data_UPitt_LPTP\Amrish_12Oct12\img*.jpg');
filePath = strcat(filePath0,'Ch_Seg\');
mkdir(filePath);

% comp_filename_rawimage1 = strcat(filePath0,fileNames{ceil(length(fileNames)/2)});%
% mimg = imread(comp_filename_rawimage1);
% 
% if size(mimg,3)==3
%     a1 = rgb2gray(mimg);
% elseif size(mimg,3)>3
%     a1 = rgb2gray(mimg(:,:,1:3));
% else
%     a1 = mimg;
% end
% foi = selectROI(a1,[]);
% a2=foi{1};
% b2=a2(3:end);
% c2=str2num(b2);
len0=length(fileNames);
dt = datetime('now','Format','d-MMM-y-HH-mm');
hr=hour(dt);
mints = minute(dt);
f = waitbar(0,'Please wait...');
cropImg_folder=strcat(filePath,date,'\cropImgs_',date,'-',num2str(hr),'-',num2str(mints));
mkdir(cropImg_folder);
waitbar(.1,f,'Loading your data');
clear cropImgs0;
for mn1=1:len0  
%% Read Original wide-field images
%     h=waitbar(mn1/(length(fileNames)),sprintf('Processing Step-1/Step-4 at scan number: %d/%d',mn1,length(fileNames)));

    crop_img=mn1
    try
    raw_img = strcat(filePath0,fileNames{mn1});%
    aa11 = imread(raw_img);
    if size(aa11,3)==3
        a1 = rgb2gray(aa11);
    elseif size(aa11,3)>3
        a1 = rgb2gray(aa11(:,:,1:3));
    else
        a1 = aa11;
    end
%     cropImgs0(:,:,mn1) = a1(:,c2(1)+10:c2(1)+c2(3)-10);
    imgs(:,:,mn1) = a1;%(c2(2):c2(2)+c2(4),c2(1)+10:c2(1)+c2(3)-10);
%     imwrite(cropImgs(:,:,mn1),strcat(cropImg_folder,'\img',sprintf('%04d',mn1-1),'.jpg'));
    catch ME
        fprintf('Corrupted scan# %d: %s\n',mn1, ME.message);
        continue;
    end
end
waitbar(.2,f,'Resizing and writing the cropped B-scans');

sx=size(imgs,3);
sz=size(imgs,1);
sy=size(imgs,2);

for mn1 = 0:2:sx-1
%% Read Original wide-field images
%     h=waitbar(mn1/sx,sprintf('Processing Step-2/Step-4 at scan number: %d/%d',mn1,sx));
    inter_crop_img = mn1+1
    mn11 = round(mn1/2)
    imwrite(imgs(:,:,mn1+1),strcat(cropImg_folder,'\img',sprintf('%04d',mn11),'.jpg'));
%     close(h);
end



% sx=size(crop_scans{1},1);
% sy=size(crop_scans{1},2);
str1=split(cropImg_folder,'\');
inpFPath = join(str1(1:end),"/");
outPath = join(str1(1:end-1),"/");
outFPath=strcat(outPath{1},'/mask_',date,'-',num2str(hr),'-',num2str(mints));
mkdir(outFPath);  

% VKKResUnet_kerasGPUKK_Raw_20Val_80Train_RS42_8_80_256_26Sep21
% VKKResUnet_kerasGPUKK_Raw_20Val_80Train_RS42_8_80_256_10Oct21
% VKKResUnet_CS_3594_Raw_10Val_90Train_RS42_8_80_256
% D:/Choroid/Code/GUI/WF/Ch_Topo_gui
% D:/Chrd_Segmentation/EnfaceCVI97_AMD/Ch_Topo_gui
h5file='D:/Choroid/Code/GUI/WF/Ch_Topo_gui/VKKResUnet_CS_3594_Raw_10Val_90Train_RS42_8_80_256.h5';
% save(strcat(str1{end-2},'_cropScans_filePath_filenames_',num2str(len0),'_',date,'-',num2str(hr),'-',num2str(mints)),'crop_scans','fileNames','filePath');
waitbar(.33,f,'Generating choroid mask......');
tic
cmd=strcat('python D:/Choroid/Code/GUI/WF/Ch_Topo_gui/maskGen.py',{' '},inpFPath{1},{' '},h5file,{' '},outFPath);
system(cmd{1})
mask_gen_toc=toc

tic   
se1=strel('disk',3);
waitbar(.55,f,'Cleaning outliers in the choroid mask');
mask_img0 = zeros([round(sz/4) sy round(sx/2)]);
for mn1 = 0:2:sx-1
    Mask_img = mn1 
    mn11 = round(mn1/2);
    mask_img0(:,:,mn11+1) = imbinarize(imfil(imclose(imresize(imread(strcat(outFPath,'/mask_',int2str(mn11),...
        '.jpg')),[round(sz/4) sy]),se1))); 
end

% mask_img1 = imresize3(mask_img0,size(mask_img0).*[1 1 2]);
CC1 = bwconncomp(mask_img0); % Y is the 3D array
mask_img2 = zeros(size(mask_img0));
numPixels = cellfun(@numel,CC1.PixelIdxList);
[biggest,maxid] = max(numPixels);
mask_img2(CC1.PixelIdxList{maxid}) = 1;
se2 = strel('sphere',5);
mask_img = imbinarize(imfil(imclose((mask_img2),se2)));
mask_Proc_toc=toc

% save(strcat(str1{end-2},'_ChoroidVesselVol_mask_enh_img_',num2str(len0),'_',date,'-',num2str(hr),'-',num2str(mints)),'ChoroidVesselVol','mask_img0','I_org_Bw_vol_SC');
COB3D_temp=zeros(size(mask_img,2),size(mask_img,3));
CIB3D_temp=zeros(size(mask_img,2),size(mask_img,3));
COB3D_Fill0=zeros(size(mask_img,2),size(mask_img,3));
CIB3D_Fill0=zeros(size(mask_img,2),size(mask_img,3));
y_intrm=1:size(mask_img,2);
% xz_intrm=1:1:size(mask_img,3);

waitbar(.7,f,'CIB and COB detections in CL mask');
tic
for mn1 = 1:round(sx/2)
%     h=waitbar(j/sx,sprintf('Processing Step-4/Step-4 at scan number: %d/%d',j,sx));
    try
    cib_cob = mn1
    y_temp_indx =[];
    for mn2 = 1:sy
        aa_ILM = [];
        aa_ILM = find(mask_img(:,mn2,mn1)==1);
        if numel(aa_ILM)>4
            CIB3D_temp(mn2,mn1) = round(aa_ILM(1)-3);
            COB3D_temp(mn2,mn1) = round(aa_ILM(end)+3-aa_ILM(1));
            y_temp_indx = [y_temp_indx mn2];
        end
    end  
    CIB3D_intrm = interp1(y_temp_indx,CIB3D_temp(y_temp_indx,mn1),y_intrm,'linear','extrap');
    CIB3D_Fill0(:,mn1) = smooth(y_intrm,CIB3D_intrm,0.1,'rloess');
    COB3D_intrm = interp1(y_temp_indx,COB3D_temp(y_temp_indx,mn1),y_intrm,'linear','extrap');
    COB3D_Fill0(:,mn1) = smooth(y_intrm,COB3D_intrm,0.1,'rloess'); 
    catch ME
      fprintf('Failed to process scan numner %d: %s\n',mn1, ME.message);
      continue;
    end
%     close(h);
end
Icib_cob_toc=toc     %  432.9090/1024=  0.4228

tic
CIB3D_Fill = imresize(CIB3D_Fill0,[round((size(CIB3D_Fill0,1)*512)/sx) 512]);
COB3D_Fill = imresize(COB3D_Fill0,[round((size(CIB3D_Fill0,1)*512)/sx) 512]);

figure;mesh(4*CIB3D_Fill);hold on;mesh(4*(CIB3D_Fill+COB3D_Fill));
title(strcat('Initial cibs and cobs....',str1{4}), 'Interpreter', 'none');
% title('Initial choroid inner and outer boundaries');
% sm_cib_cob

CIB3D_Fill2 = smoothdata(smoothdata(CIB3D_Fill,2,'rloess'),1,'rloess');
COB3D_Fill2 = smoothdata(smoothdata(COB3D_Fill,2,'rloess'),1,'rloess');
CIB3D_Fill3 = 4*CIB3D_Fill2;
COB3D_Fill3 = 4*COB3D_Fill2;
sm_time = toc

figure; mesh(CIB3D_Fill3);hold on;mesh(CIB3D_Fill3+COB3D_Fill3);
title(strcat('Final cibs and cobs....',str1{4}), 'Interpreter', 'none');
% title('Final choroid inner and outer boundaries');
waitbar(.85,f,'final step.....recording choroid segmentation');
tic
% 
imgs1 = imresize3(imgs,[size(imgs,1) size(CIB3D_Fill3)]);
% segPath1 = 
% plt_wf_cibcob(cropImgs1,4*CIB3D_Fill,4*COB3D_Fill,filePath,'ws',[]);
segPath2 = plt_wf_cibcob(imgs1,CIB3D_Fill3,COB3D_Fill3,filePath,'sm',[]);
plt_ws_sm = toc;

overall_time = (plt_ws_sm+Icib_cob_toc+mask_Proc_toc+mask_gen_toc+sm_time)/60

strr = strcat(str1{4})
close(f)
% matSave_Ch_Topo


% For only CIB

% ssno_cib = '460-600';
% cib_old = CIB3D_Fill3;
% cob_old = COB3D_Fill3;
% only_cib
% CIB3D_Fill3 = cib_new;


% For only COB

% ssno_cob = '220-420,430-750';
% cib_old = CIB3D_Fill3;
% cob_old = COB3D_Fill3;
% only_cob
% COB3D_Fill3 = cob_new;



% % % 
% str1 = split(filePath,'\')
% str2 = split(str1{4},'_');        
% kywd = join(str2(1:end-1),'_')
% fpath = strcat('D:\Choroid\Code\GUI\WF\Ch_Topo_gui\Choroid_Topography_MatFiles\',date,'\',kywd{1});



% % % fpath = strcat('D:\Choroid\Code\GUI\WF\Ch_Topo_gui\Choroid_Topography_MatFiles\',date,'\',kywd{1},'\cib_crtn_',ssno_cib);
% % fpath = strcat('D:\Choroid\Code\GUI\WF\Ch_Topo_gui\Choroid_Topography_MatFiles\',date,'\',kywd{1},'\cob_crtn_',ssno_cob);
% % % % % % fpath = strcat('D:\Choroid\Code\GUI\WF\Ch_Topo_gui\Choroid_Topography_MatFiles\',date,'\',kywd{1},'\cib_cob_crtn_',ssno_cib,'_',ssno_cob);
% mkdir(fpath);
% enf_img = enfImg1(CIB3D_Fill3,cropImgs1);
% save(strcat(fpath,'\Data.mat'),'CIB3D_Fill3','COB3D_Fill3','enf_img','c2');


% 
% 
% rpt_scan_no = '1003';
% rpt_range = '1003-1024';

% % cib
% bnd = rpt_ref_bnd(rpt_scan_no,rpt_range,CIB3D_Fill2);
% plt_wf_cibcob1(cropImgs1,4*bnd,4*COB3D_Fill2,filePath,'ref_corr_cib',715:1024);
% CIB3D_Fill2 = bnd;

% % cob
% bnd = rpt_ref_bnd(rpt_scan_no,rpt_range,COB3D_Fill2);
% plt_wf_cibcob1(cropImgs1,4*CIB3D_Fill2,4*bnd,filePath,'ref_corr_cob',1003:1024);
% COB3D_Fill2 = bnd;
% 
% str1 = split(filePath,'\')
% str2 = split(str1{4},'_');        
% kywd = join(str2(1:end-1),'_')
% % fpath = strcat('D:\Choroid\Code\GUI\WF\Ch_Topo_gui\Choroid_Topography_MatFiles\',date,'\',kywd{1},'\cob_rpt_',rpt_scan_no,'_',rpt_range);
% % fpath = strcat('D:\Choroid\Code\GUI\WF\Ch_Topo_gui\Choroid_Topography_MatFiles\',date,'\',kywd{1},'\cib_',ssno_cib,'_rpt_',rpt_scan_no,'_',rpt_range);
% % 
% fpath = strcat('D:\Choroid\Code\GUI\WF\Ch_Topo_gui\Choroid_Topography_MatFiles\',date,'\',kywd{1},'\cob_',ssno_cob,'_rpt_',rpt_scan_no,'_',rpt_range);
% % 
% % fpath = strcat('D:\Choroid\Code\GUI\WF\Ch_Topo_gui\Choroid_Topography_MatFiles\',date,'\',kywd{1},'\cib_',ssno_cib,'_cob_',ssno_cob,'_rpt_',rpt_scan_no,'_',rpt_range);

% mkdir(fpath);
% enf_img = enfImg1(CIB3D_Fill3,cropImgs1);
% save(strcat(fpath,'\Data.mat'),'CIB3D_Fill3','COB3D_Fill3','enf_img','c2');


