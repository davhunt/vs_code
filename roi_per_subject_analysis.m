function [] = roi_per_subject_analysis()


if exist('/N/slate/brainevo/Implicit_Learning/CoSMoMVPA/mvpa') == 7 % slate
    base_folder = '/N/slate/brainevo/Implicit_Learning';
    addpath(genpath('/N/slate/brainevo/Implicit_Learning/CoSMoMVPA/mvpa'));
    addpath(genpath('/N/slate/brainevo/Implicit_Learning/matlab_nifti_tools'));
else
    base_folder = '/Volumes/data1';
    addpath(genpath('/Users/lab/Downloads/CoSMoMVPA/mvpa')); % habilis
    addpath(genpath('/Users/lab/Downloads/matlab_nifti_tools'));
end

nNulls_per_subject = 500;

subj_list = [1 2 3 4 5 6 7 8 9 10 13 14 15 16 17 18 19 20 21 22 23 24];
%subj_list = [1 2];
rois = ["BA44", "BA45", "BA47", "BA44+45", "BA44+45+47"];
for sub = subj_list
    sub = num2str(sub, '%.2d');
    for roi = rois
        if ~isfile(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/breakpoint_rts_unsmoothed_native_antsmask/' char(roi) '/p_value.mat'])
            result = load(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/breakpoint_rts_unsmoothed_native_antsmask/' char(roi) '/TDT_results/TDT_results_avg_allreps/res_accuracy_minus_chance.mat']);
            real_acc = result.avg_all_reps;
            null_accuracies = zeros(nNulls_per_subject,1);
            for i = 1:nNulls_per_subject
                perm = num2str(i, '%.3d');
                result = load(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/breakpoint_rts_unsmoothed_native_antsmask/' char(roi) '/perm/perm' perm '/results_avg_allreps/res_accuracy_minus_chance.mat']);
                null_accuracies(i,1) = result.avg_all_reps;
            end
            p_val = (sum(null_accuracies >= real_acc) + 1) / (nNulls_per_subject + 1);
            save(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/breakpoint_rts_unsmoothed_native_antsmask/' char(roi) '/p_value.mat'],'p_val');
        else
            % If p-value already calculated just load .mat file
            load(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/breakpoint_rts_unsmoothed_native_antsmask/' char(roi) '/p_value.mat']);
        end
        %fprintf("subject %s ROI %s has p-value of: %s\n", sub, sprintf('%10s', roi), sprintf(p_val,'%.4f'));
        fprintf("subject %s ROI %s has p-value of: %s\n", sub, pad(roi, 10, 'right', ' '), sprintf('%.4f',p_val));
    end
end

end