function [] = run_t_test_for_cluster(cluster_name)

% This function runs a paired t-test for a given cluster, to compare high associative chunk strength trials with low associative chunk strength trials,
% providing a check on if grammatical and ungrammatical sequences were truly balanced in terms of chunk strength (subsequence familiarity).

addpath(genpath('/Users/lab/Downloads/matlab_nifti_tools')); % On Habilis

subj_list = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"];

% Get all 22 cluster decoding accuracy values for high chunk-strength betas, and all 22 decoding accuracy values for low chunk-strength betas,
% Run paired t-test, get p value
L_vals = []; % 1 x 22
H_vals = []; % 1 x 22
for sub=1:numel(subj_list)
    H_nii = load_untouch_nii(char(fullfile("/Volumes/data1/Complex_seq_analysis/chunk_strength_analysis_by_cluster",subj_list(sub),"H",cluster_name,"TDT_results_avg_allreps/res_accuracy_minus_chance.nii.gz")));
    H_max = max(H_nii.img(:,:,:),[],'all');
    H_min = min(H_nii.img(:,:,:),[],'all');
    if H_max == 0 && H_min == 0
        H_val = 0;
    elseif H_max ~= 0 && H_min == 0
        H_val = H_max;
    elseif H_max == 0 && H_min ~= 0
        H_val = H_min;
    else
        error(sprintf('Seeing incompatible max %f, min %f values, exiting.',H_max,H_min));
    end
    H_vals = [H_vals, H_val];

    L_nii = load_untouch_nii(char(fullfile("/Volumes/data1/Complex_seq_analysis/chunk_strength_analysis_by_cluster",subj_list(sub),"L",cluster_name,"TDT_results_avg_allreps/res_accuracy_minus_chance.nii.gz")));
    L_max = max(L_nii.img(:,:,:),[],'all');
    L_min = min(L_nii.img(:,:,:),[],'all');
    if L_max == 0 && L_min == 0
        L_val = 0;
    elseif L_max ~= 0 && L_min == 0
        L_val = L_max;
    elseif L_max == 0 && L_min ~= 0
        L_val = L_min;
    else
        error(sprintf('Seeing incompatible max %f, min %f values, exiting.',L_max,L_min));
    end
    L_vals = [L_vals, L_val];

end

[h,p] = ttest(H_vals,L_vals);

%%%%
disp(H_vals)
disp(L_vals)
%%%%

% Technically should consider multiple comparisons, but ok
if h == 1
    fprintf('Cluster %s, we reject the null hypothesis, p-value is: %f\n', cluster_name, p);
elseif h == 0
    fprintf('Cluster %s, we fail to reject the null hypothesis, p-value is: %f\n', cluster_name, p);
end

end
