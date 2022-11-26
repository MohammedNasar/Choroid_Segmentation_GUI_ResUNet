


[cib_new,rang,rangc] = Ch_seg_correctionRange_cib(cib_old,ssno_cib);

rang1=[];
for i=1:size(rang,1)
    rang1=[rang1 rang(i,1):rang(i,2)];
end
nvar='cib_sm_afterCorrection';
% tic
newSegPath = plt_wf_cibcob(cropImgs1,cib_new,cob_old,filePath,nvar,rang1)