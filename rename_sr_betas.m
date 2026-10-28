function [] = rename_sr_betas()

% Rename sentence reading beta filenames after names of trials

subj_list = ["1","3","4","5","6","7","8","9","10","13","14","15","16","17","18","19","20","21","22","23","24"];
%subj_list = ["2"];

non_trial_betas = ["R1_1", "R2_1", "R3_1", "R4_1", "R5_1", "R6_1", "R1_2", "R2_2", "R3_2", "R4_2", "R5_2", "R6_2", "R1_3", "R2_3", "R3_3", "R4_3", "R5_3", "R6_3", "R1_4", ...
 "R2_4", "R3_4", "R4_4", "R5_4", "R6_4", "constant_1",  "constant_2",  "constant_3",  "constant_4"];
non_trial_betas_indices = [50:55, 105:110, 160:165, 215:224];

for subjID = subj_list
    %cd(sprintf('/Volumes/data1/Implicit_Learning/sentence_reading_betas/%02d', double(subjID)));
    load(sprintf('/Volumes/data1/Implicit_Learning/sentence_reading_betas/%02d/SPM.mat', double(subjID)));
    for beta=[1:49,56:104,111:159,166:214]
        beta_filename = sprintf('/Volumes/data1/Implicit_Learning/sentence_reading_betas/%02d/beta_%04d.nii', double(subjID), beta);
        trial_name = regexp(char(SPM.xX.name(beta)), '^Sn.*([0-9]{2}[ACGOPRU]+).*$','tokens');
        beta_new_filename = sprintf('/Volumes/data1/Implicit_Learning/sentence_reading_betas/%02d/beta_%s.nii', double(subjID), char(trial_name{1}));
        movefile(beta_filename, beta_new_filename);
    end
    for beta=1:numel(non_trial_betas)
        beta_filename = sprintf('/Volumes/data1/Implicit_Learning/sentence_reading_betas/%02d/beta_%04d.nii', double(subjID), non_trial_betas_indices(beta));
        beta_new_filename = sprintf('/Volumes/data1/Implicit_Learning/sentence_reading_betas/%02d/beta_%s.nii', double(subjID), non_trial_betas(beta));
        movefile(beta_filename, beta_new_filename);
    end
end

end