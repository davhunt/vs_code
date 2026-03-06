function [] = roi_group_analysis(stat_map)


if exist('/N/slate/brainevo/Implicit_Learning/CoSMoMVPA/mvpa') == 7 % slate
    base_folder = '/N/slate/brainevo/Implicit_Learning';
    addpath(genpath('/N/slate/brainevo/Implicit_Learning/CoSMoMVPA/mvpa'));
    addpath(genpath('/N/slate/brainevo/Implicit_Learning/matlab_nifti_tools'));
else
    base_folder = '/Volumes/data1';
    addpath(genpath('/Users/lab/Downloads/CoSMoMVPA/mvpa')); % habilis
    addpath(genpath('/Users/lab/Downloads/matlab_nifti_tools'));
end

if ~strcmp(stat_map, 'tstat') && ~strcmp(stat_map, 'accuracy')
    error(sprintf('stat_map value %s must be either "tstat" or "accuracy," exiting.', stat_map));
end

subj_list = [1 2 3 4 5 6 7 8 9 10 13 14 15 16 17 18 19 20 21 22 23 24];
rois = ["BA44", "BA45", "BA47", "BA44+45", "BA44+45+47"];
nNulls_per_subject = 500;
nIter = 1000000; % number of iterations of creating a null group decoding accuracy, to generate a group null distribution of accuracies
nSubjects = numel(subj_list);
for roi = rois
    if ~isfile(['/Volumes/data1/Complex_seq_analysis/ROIs_group_results/' char(roi) '/' char(roi) '_group_accuracy.mat'])
        true_accuracies = zeros(nSubjects,1);
        for sub_num = 1:nSubjects
            sub = subj_list(sub_num);
            res = load(['/Volumes/data1/Complex_seq_analysis/' num2str(sub, '%.3d') '/MVPA/breakpoint_rts_unsmoothed_native_antsmask/' char(roi) '/TDT_results/TDT_results_avg_allreps/res_accuracy_minus_chance.mat']);
            true_accuracies(sub_num,1) = res.avg_all_reps;
        end
        group_mean_accuracy = mean(true_accuracies);
        save(['/Volumes/data1/Complex_seq_analysis/ROIs_group_results/' char(roi) '/' char(roi) '_group_accuracy.mat'], 'group_mean_accuracy');
    else
        gma = load(['/Volumes/data1/Complex_seq_analysis/ROIs_group_results/' char(roi) '/' char(roi) '_group_accuracy.mat']);
        group_mean_accuracy = gma.group_mean_accuracy;
    end

    if ~isfile(['/Volumes/data1/Complex_seq_analysis/ROIs_group_results/' char(roi) '/' char(roi) '_null_accuracies.mat'])
        null_accuracies = zeros(nSubjects,nNulls_per_subject);
        for sub_num = 1:nSubjects
            sub = num2str(subj_list(sub_num),'%.2d');
            for perm = 1:nNulls_per_subject
                res = load(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/breakpoint_rts_unsmoothed_native_antsmask/' char(roi) '/perm/perm' num2str(perm,'%.3d') '/results_avg_allreps/res_accuracy_minus_chance.mat']);
                null_accuracies(sub_num, perm) = res.avg_all_reps;
            end
        end
        save(['/Volumes/data1/Complex_seq_analysis/ROIs_group_results/' char(roi) '/' char(roi) '_null_accuracies.mat'], 'null_accuracies');
    else
        load(['/Volumes/data1/Complex_seq_analysis/ROIs_group_results/' char(roi) '/' char(roi) '_null_accuracies.mat'])
    end

    % Now we should have a group_mean_accuracy variable (double) and a null_accuracies matrix (nSubjects x nNulls_per_subject double)
    % Now create a null group accuracy by randomly sampling a permutation acc. from each subject, then compare true accuracy to null distribution -> p-value
    
    null_dist = zeros(nIter,1);
    for i = 1:nIter
        
        null_sample = zeros(nSubjects, 1);
        for s = 1:nSubjects
            idx = randi(nNulls_per_subject); % random null index
            null_sample(s) = null_accuracies(s,idx);
        end
        if strcmp(stat_map, 'tstat')
            null_dist(i) = onesample_t(null_sample);
        elseif strcmp(stat_map, 'accuracy')
            null_dist(i) = mean(null_sample);
        else
            fprintf('Error? unknown value of "stat_map"?');
        end
    end

    p_val = (sum(null_dist >= group_mean_accuracy) + 1) / (nIter + 1);

    fprintf(['Group p-value for ROI %s is: %s\n'], pad(roi, 10, 'right', ' '), sprintf('%.12f',p_val));
    save(['/Volumes/data1/Complex_seq_analysis/ROIs_group_results/' char(roi) '/' char(roi) '_' char(stat_map) '_p-value_group.mat'], 'p_val');

end

end


function tvec = onesample_t(X)
    % Compute t-map on X
    % X: [nSubjects x nVoxels]
    % tvec: [1 x nVoxels]
    n  = size(X,1);
    mu = mean(X,1);
    sd = std(X,0,1);           % sample std (dof = n-1)
    se = sd ./ sqrt(n);
    tvec = zeros(1,size(X,2));
    nz = se>0 & isfinite(se);
    tvec(nz) = mu(nz) ./ se(nz);
    % if se==0 leave t=0
end
