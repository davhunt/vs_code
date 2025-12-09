function [] = num_sig_voxels(sub, space, threshold)

% nbins should be number of permutations plus 1
addpath(genpath('/Users/lab/Downloads/matlab_nifti_tools'));

sub = num2str(sub, '%02d');

if strcmp(space, 'mni')
    space_str = '';
elseif strcmp(space, 'native')
    space_str = '_native';
else
    disp('invalid space parameter');
    exit();
end

%onsets_nii = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/onsets_only_unsmoothed' space_str '/TDT_results/TDT_results_avg_allreps/res_accuracy_minus_chance.nii']);
%durations_nii = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/durations_unsmoothed' space_str '/TDT_results/TDT_results_avg_allreps/res_accuracy_minus_chance.nii']);
%onsets_nii = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/onsets_only_unsmoothed' space_str '/TDT_results_rad3/TDT_results_avg_allreps/res_accuracy_minus_chance.nii']);
%durations_nii = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/durations_unsmoothed' space_str '/TDT_results_rad3/TDT_results_avg_allreps/res_accuracy_minus_chance.nii']);
onsets_nii = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/onsets_only_unsmoothed' space_str '/TDT_results_rad4/TDT_results_avg_allreps/res_accuracy_minus_chance.nii']);
durations_nii = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/durations_unsmoothed' space_str '/TDT_results_rad4/TDT_results_avg_allreps/res_accuracy_minus_chance.nii']);

ons = onsets_nii.img(:);
durs = durations_nii.img(:);

mask = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/onsets_only_unsmoothed' space_str '/mask.nii']);
mask_total_voxels = sum(mask.img(:),'all');

%ons_total_significant = sum(ons >= threshold);
%durs_total_significant = sum(durs >= threshold);

ons_perc = sum(ons >= threshold) / mask_total_voxels * 100;
durs_perc = sum(durs >= threshold) / mask_total_voxels * 100;

fprintf(['Percentage of significant voxels for subj %s is onsets: %f%%, durations: %f%%\n'], sub, ons_perc, durs_perc)

%histogram(ons, 101, 'DisplayStyle', 'stair')
%hold on
%histogram(durs, 101, 'DisplayStyle', 'stair')
%ylim([0,8000])

end