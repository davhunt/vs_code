function [] = plot_histogram(nifti_durations, nifti_onsets, nperms)

% nbins should be number of permutations plus 1
addpath(genpath('/Users/lab/Downloads/matlab_nifti_tools'));

onsets_nii = load_untouch_nii(nifti_onsets);
durations_nii = load_untouch_nii(nifti_durations);

onsets = onsets_nii.img(:);
durations = durations_nii.img(:);

histogram(durations, nperms+1,'DisplayStyle','stairs')
hold on
histogram(onsets, nperms+1, 'DisplayStyle','stairs')
ylim([0, 7000])

end