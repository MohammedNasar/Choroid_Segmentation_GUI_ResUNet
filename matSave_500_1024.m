
strr=strcat(str1{6});%,'_',str1{6});
% strr=strcat(str1{4},'_',str1{6});
if exist('enf_img')
    save(strcat(strr,'_cib_cob_1_',num2str(len0),'_',num2str(size(CIB3D_Fill2,2)),'_',date,'-',num2str(hr),'-',num2str(mints)),...
        'CIB3D_Fill','COB3D_Fill','CIB3D_Fill3','COB3D_Fill3','enf_img');%,'img');
else
    save(strcat(strr,'_cib_cob_1_',num2str(len0),'_',num2str(size(CIB3D_Fill2,2)),'_',date,'-',num2str(hr),'-',num2str(mints)),...
        'CIB3D_Fill','COB3D_Fill','CIB3D_Fill3','COB3D_Fill3');
end
save(strcat(strr,'_cs_hmap_1_',num2str(len0),'_',num2str(size(CIB3D_Fill2,2)),'_',date,'-',num2str(hr),'-',num2str(mints)),...
    'I_org_Bw_vol_SC','mask_img0','filePath','fcvolFilt','vol','nd','m_pt','var','dim');  %

test_point=111

% save(strcat(str1{4},'_',str1{6},'_',str1{5},'_cs_hmap_',num2str(size(CIB3D_Fill,2)),'_',date),...
%  'I_org_Bw_vol_SC','mask_img0','c2','Vol','fcvolFilt','nd','m_pt','var','dim','filePath');
 

