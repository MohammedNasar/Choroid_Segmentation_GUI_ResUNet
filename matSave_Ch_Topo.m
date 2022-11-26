

% strr = strcat(str1{4},'_',str1{4});
if exist('l1','var') && exist('l2','var')
    strr = strcat(str1{4},'_repaired_sno_',int2str(l1),'_',int2str(l2))
    if exist('enf_img')
        test_point_11 = 111
        save(strcat(strr,'_cib_cob_',num2str(len0),'_',num2str(size(CIB3D_Fill2,2)),'_',date,'-',num2str(hr),'-',num2str(mints)),...
            'CIB3D_Fill','COB3D_Fill','cib2','cob2','enf_img','filePath','c2');%,'img');
    else
        test_point_12 = 111
        save(strcat(strr,'_cib_cob_',num2str(len0),'_',num2str(size(CIB3D_Fill2,2)),'_',date,'-',num2str(hr),'-',num2str(mints)),...
            'CIB3D_Fill','COB3D_Fill','cib2','cob2','filePath','c2');
    end
else
    strr = strcat(str1{4})
    if exist('enf_img')
        test_point_21 = 111
        save(strcat(strr,'_cib_cob_',num2str(len0),'_',num2str(size(CIB3D_Fill2,2)),'_',date,'-',num2str(hr),'-',num2str(mints)),...
            'CIB3D_Fill','COB3D_Fill','CIB3D_Fill3','COB3D_Fill3','enf_img','filePath','c2');%,'img');
    else
        test_point_22 = 111
        save(strcat(strr,'_cib_cob_',num2str(len0),'_',num2str(size(CIB3D_Fill2,2)),'_',date,'-',num2str(hr),'-',num2str(mints)),...
            'CIB3D_Fill','COB3D_Fill','CIB3D_Fill3','COB3D_Fill3','filePath','c2');
    end
end
