function [] = num_sig_voxels_in_roi_compare(sub, space, threshold, roi)

% sub: subject number
% space: "native" or "mni"
% threshold: percentage above chance decoding accuracy threshold
% roi should be ROI # (or array of ROI #s) from AAL116NodeIndex.1D and aal116NodeNames.txt
% example: 
% num_sig_voxels_in_roi_compare(sub,'native',7,[2301 2302 2311 2312])
% sub 08: onsets radius 4 13.871%, onsets radius 3 15.914%, durations radius 4 17.903%, durations radius 3 19.946%.

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

aal_atlas_epi = load_untouch_nii(['/Volumes/data1/T1_and_Complex_seq/0' sub '/aal116_epi_space.nii.gz']);
aal_atlas_img = aal_atlas_epi.img(:); % 1-D array
roi_indices = ismember(aal_atlas_img, roi); % should get all indices of atlas that are one of the ROIs in the ROI array
rois_total_voxels = sum(roi_indices,'all');

%if

%onsets_nii = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/onsets_only_unsmoothed' space_str '/TDT_results/TDT_results_avg_allreps/res_accuracy_minus_chance.nii']);
%durations_nii = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/durations_unsmoothed' space_str '/TDT_results/TDT_results_avg_allreps/res_accuracy_minus_chance.nii']);
onsets_nii3 = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/onsets_only_unsmoothed' space_str '/TDT_results_rad3/TDT_results_avg_allreps/res_accuracy_minus_chance.nii']);
durations_nii3 = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/durations_unsmoothed' space_str '/TDT_results_rad3/TDT_results_avg_allreps/res_accuracy_minus_chance.nii']);
onsets_nii4 = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/onsets_only_unsmoothed' space_str '/TDT_results_rad4/TDT_results_avg_allreps/res_accuracy_minus_chance.nii']);
durations_nii4 = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/durations_unsmoothed' space_str '/TDT_results_rad4/TDT_results_avg_allreps/res_accuracy_minus_chance.nii']);

ons3 = onsets_nii3.img(:);
durs3 = durations_nii3.img(:);
ons4 = onsets_nii4.img(:);
durs4 = durations_nii4.img(:);

%mask = load_untouch_nii(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/onsets_only_unsmoothed' space_str '/mask.nii']);
%mask_total_voxels = sum(mask.img(:),'all');

%ons_total_significant = sum(ons >= threshold);
%durs_total_significant = sum(durs >= threshold);

ons_significant3 = (ons3 >= threshold);
durs_significant3 = (durs3 >= threshold);
ons_significant4 = (ons4 >= threshold);
durs_significant4 = (durs4 >= threshold);


%ons_perc = sum(ons >= threshold) / mask_total_voxels * 100;
%durs_perc = sum(durs >= threshold) / mask_total_voxels * 100;
ons_perc3 = sum(ons_significant3 & roi_indices) / rois_total_voxels * 100;
durs_perc3 = sum(durs_significant3 & roi_indices) / rois_total_voxels * 100;
ons_perc4 = sum(ons_significant4 & roi_indices) / rois_total_voxels * 100;
durs_perc4 = sum(durs_significant4 & roi_indices) / rois_total_voxels * 100;

fprintf(['sub %s: onsets radius 4 %06.3f%%, onsets radius 3 %06.3f%%, durations radius 4 %06.3f%%, durations radius 3 %06.3f%%.\n'], sub, ons_perc4, ons_perc3, durs_perc4, durs_perc3);

%fprintf(['%% of sig voxels at threshold of %.1f%% for subj %s is onsets: %f%%, durations: %f%%\n'], threshold+50, sub, ons_perc, durs_perc)

%histogram(ons, 101, 'DisplayStyle', 'stair')
%hold on
%histogram(durs, 101, 'DisplayStyle', 'stair')
%ylim([0,8000])

end