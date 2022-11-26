
function bnd = rpt_ref_bnd(ref_sno,rpt_rng,bnd0)
    rng = split(rpt_rng,'-')'; 
    s0 = str2double(ref_sno);
    s1 = str2double(rng{1});
    s2 = str2double(rng{2});
    sd = size(bnd0,2);

    % if s1 == 1
    %     cib = [repmat(cib_old(:,s0),1,s2) cib_old(:,s2+1:sd)];
    %     cob = [repmat(cob_old(:,s0),1,s2) cob_old(:,s2+1:sd)];
    % else
    bnd = [bnd0(:,1:s1-1) repmat(bnd0(:,s0),1,s2-s1+1) bnd0(:,s2+1:sd)];
end