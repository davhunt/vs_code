function [design] = run_glmsingle(subj)

    addpath(genpath('/Users/lab/Downloads/GLMsingle/matlab'));
    addpath(genpath('/Users/lab/Downloads/matlab_nifti_tools'));

    bold_nii = load_untouch_nii(['/Volumes/data1/T1_and_Complex_seq/0' num2str(subj, '%02d') '/func_cat.nii.gz']);
    data{1} = single(bold_nii.img);  % just one run, wants single-precision
    num_trs = size(data{1},4); % number of time points in time series
    num_conds = 56; % number of conditions, 56

    tr = 1;
    stimdur = 2; % 2 seconds stimdur?
    %outputdir = '';
    

    % Build design matrix
    spm_struct = load(['/Volumes/data1/Complex_seq_analysis/0' num2str(subj, '%02d') '/MVPA/durations_unsmoothed_native/SPM.mat']);
    design_from_spm = spm_struct.SPM.Sess.U;
    design = zeros(num_trs, num_conds);
    for i = 1:num_conds
        onset_time = round(design_from_spm(i).ons);
        if onset_time >= num_trs
            onset_time = num_trs - 1; % should never happen, that a condition is right up to the very end of the run
        end
        design(onset_time+1, i) = 1; % using onsets only
        %design(onset_time+1:onset_time+3, i) = 1; % using durations instead of onset times
    end
    design = {design};

    % set opt fields
    %opt.wantmemoryoutputs = [1 1 1 1];
    opt.wantmemoryoutputs = [0 0 0 1];
    opt.pcstop = -5;
    opt.fracs = 0.5;

    %[results_gng] = GLMestimatesingletrial(design,data,stimdur,tr,[outputdir '/ourResults_pcstop_fracs'],opt);

end