#!/bin/bash

subj=$1 # "18" e.g.
dir=$2 # "onsets_only_unsmoothed" e.g.
if [[ -n $3 ]]; then
    second_dir=$3
fi

fslmaths /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${dir}/TDT_results/pvals_map_post_permutation.nii -uthr 0.05 /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${dir}/TDT_results/pvals_map_post_permutation_thr0.05.nii
fslmaths /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${dir}/TDT_results/pvals_map_post_permutation_thr0.05.nii -bin /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${dir}/TDT_results/pvals_map_post_permutation_thr0.05_bin.nii

if [[ -n $second_dir ]]; then
    fslmaths /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${second_dir}/TDT_results/pvals_map_post_permutation.nii -uthr 0.05 /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${second_dir}/TDT_results/pvals_map_post_permutation_thr0.05.nii
    fslmaths /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${second_dir}/TDT_results/pvals_map_post_permutation_thr0.05.nii -bin /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${second_dir}/TDT_results/pvals_map_post_permutation_thr0.05_bin.nii
    fslmaths /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${second_dir}/TDT_results/pvals_map_post_permutation_thr0.05_bin.nii -mul 2 /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${second_dir}/TDT_results/pvals_map_post_permutation_thr0.05_bin2_tmp.nii
    fslmaths /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${dir}/TDT_results/pvals_map_post_permutation_thr0.05_bin.nii -add /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${second_dir}/TDT_results/pvals_map_post_permutation_thr0.05_bin2_tmp.nii /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${dir}/TDT_results/pvals_map_post_permutation_combined.nii
    rm /Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/${second_dir}/TDT_results/pvals_map_post_permutation_thr0.05_bin2_tmp.nii
fi



#fslmaths /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation.nii -uthr 0.05 /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_thr0.05.nii
#fslmaths /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_thr0.05.nii -bin /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_onsets_thr0.05_bin.nii
#fslmaths /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation.nii -uthr 0.05 /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_onsets_thr0.05.nii
#fslmaths /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_onsets_thr0.05.nii -bin /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_onsets_thr0.05_bin.nii
#fslmaths /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_onsets_thr0.05_bin.nii -mul 2 /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_onsets_thr0.05_two.nii
#something like:
#fslmaths /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_onsets_thr0.05_two.nii -add /Volumes/data1/Complex_seq_analysis/018/MVPA/durations_unsmoothed/TDT_results/pvals_map_post_permutation_durs_thr0.05_bin.nii /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_combined_1fordurations_2foronsets_3forboth.nii

#freeview -v /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_combined_1fordurations_2foronsets_3forboth.nii:colormap=heat /Users/lab/Downloads/aal116/aal116MNI.nii.gz:opacity=0.4:colormap=lut:lut=/Users/lab/Downloads/aal116/outLUT.txt /Users/lab/Downloads/leaddbs/templates/space/MNI152NLin2009bAsym/t1.nii:opacity=0.4




#fslmaths /Volumes/data1/Complex_seq_analysis/018/MVPA/durations_unsmoothed/TDT_results/pvals_map_post_permutation.nii -uthr 0.05 /Volumes/data1/Complex_seq_analysis/018/MVPA/durations_unsmoothed/TDT_results/pvals_map_post_permutation_thr0.05.nii
#fslmaths /Volumes/data1/Complex_seq_analysis/018/MVPA/durations_unsmoothed/TDT_results/pvals_map_post_permutation_thr0.05.nii -bin /Volumes/data1/Complex_seq_analysis/018/MVPA/durations_unsmoothed/TDT_results/pvals_map_post_permutation_thr0.05_bin.nii
#fslmaths /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation.nii -uthr 0.05 /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_onsets_thr0.05.nii
#fslmaths /Volumes/data1/Complex_seq_analysis/018/MVPA/durations_unsmoothed/TDT_results/pvals_map_post_permutation_thr0.05.nii -bin /Volumes/data1/Complex_seq_analysis/018/MVPA/durations_unsmoothed/TDT_results/pvals_map_post_permutation_onsets_thr0.05_bin.nii
#fslmaths /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_onsets_thr0.05_bin.nii -mul 2 /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_onsets_thr0.05_two.nii
#something like:
#fslmaths /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_onsets_thr0.05_two.nii -add /Volumes/data1/Complex_seq_analysis/018/MVPA/durations_unsmoothed/TDT_results/pvals_map_post_permutation_durs_thr0.05_bin.nii /Volumes/data1/Complex_seq_analysis/018/MVPA/onsets_only_unsmoothed/TDT_results/pvals_map_post_permutation_combined_1fordurations_2foronsets_3forboth.nii