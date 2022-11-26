


[cob_new,rang,rangc] = Ch_seg_correctionRange_cob(cob_old,ssno_cob);
% save('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat','cib_new','cob_new','-append');
rang1=[];
for i=1:size(rang,1)
    rang1=[rang1 rang(i,1):rang(i,2)];
end
nvar='cob_sm_afterCorrection';
% tic
newSegPath = plt_wf_cibcob(cropImgs1,cib_old,cob_new,filePath,nvar,rang1)