function [] = perms_on_roi()

if exist('/N/slate/brainevo/Implicit_Learning/CoSMoMVPA/mvpa') == 7 % slate
    base_folder = '/N/slate/brainevo/Implicit_Learning';
    addpath(genpath('/N/slate/brainevo/Implicit_Learning/CoSMoMVPA/mvpa'));
    addpath(genpath('/N/slate/brainevo/Implicit_Learning/matlab_nifti_tools'));
else
    base_folder = '/Volumes/data1';
    addpath(genpath('/Users/lab/Downloads/CoSMoMVPA/mvpa')); % habilis
    addpath(genpath('/Users/lab/Downloads/matlab_nifti_tools'));
end

% something like this to generate perms for specific ROIs
% BA44, BA45, BA47, BA44+45, BA44+45+47
base_folder = '/Volumes/data1';
%base_folder = '/N/slate/brainevo/Implicit_Learning' %if on slate
for roi = ["BA44", "BA45", "BA47", "BA44+45", "BA44+45+47"]
    for sub = [1,2,3,4,5,6,7,8,9,10,13,14,15,16,17,18,19,20,21,22,23,24]
        gng_decoding_roi(sub,10,'breakpoint_rts_unsmoothed_native_antsmask',[base_folder '/Complex_seq_analysis/0' num2str(sub, '%.2d') '/MVPA/breakpoint_rts_unsmoothed_native_antsmask/brocas_rois/' char(roi) '_mask.nii.gz'],[char(roi) '/TDT_results']);
        gng_decoding_roi_permutations(sub,500,10,'breakpoint_rts_unsmoothed_native_antsmask',[base_folder '/Complex_seq_analysis/0' num2str(sub, '%.2d') '/MVPA/breakpoint_rts_unsmoothed_native_antsmask/brocas_rois/' char(roi) '_mask.nii.gz'],char(roi));
        stats_average_repetitions_roi([base_folder '/Complex_seq_analysis/0' num2str(sub, '%.2d') '/MVPA/breakpoint_rts_unsmoothed_native_antsmask/' char(roi) '/TDT_results'],'real');
        stats_average_repetitions_roi([base_folder '/Complex_seq_analysis/0' num2str(sub, '%.2d') '/MVPA/breakpoint_rts_unsmoothed_native_antsmask/' char(roi) '/perm'],'perm');
    end
end
end