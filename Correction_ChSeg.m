
% cib=CIB3D_Fill3;
% cob=COB3D_Fill3;
% uinp='100-200,500-550,590,800-900,1000,1004';
[cibnew,cobnew,rang,rangc] = Ch_seg_correctionRange(CIB3D_Fill3,COB3D_Fill3,uinp);
rang1=[];
for i=1:size(rang,1)
    rang1 = [rang1 rang(i,1):rang(i,2)];
end
nvar='sm2';
tic
plt_wf_cibcob(cropImgs,cibnew,cobnew,filePath,nvar,rang1);
plt_ws_sm = toc;

% 4*[repmat(CIB3D_Fill2(:,4),1,200) CIB3D_Fill2(:,201:1024)],4*[repmat(COB3D_Fill2(:,4),1,200) COB3D_Fill2(:,201:1024)]

