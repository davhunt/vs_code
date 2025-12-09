#!/bin/bash

# Creates Broca's masks (BA44, BA45, BA47, BA44+45, BA44+45+47) for a subject in native space

subj=$1 # "18" e.g.
subj=$(printf "%02d" $subj)

#roi_files=$2
#out_file=$3

#atlas_epi_space=/Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/durations_unsmoothed_native/aal116_epi_space.nii.gz
atlas_epi_space=/Users/lab/Downloads/ants_registrations/${subj}/aal116_in_epi_6to2009c.nii.gz

#brocas_dir=/Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/durations_unsmoothed_native/brocas_rois
brocas_dir=/Volumes/data1/Complex_seq_analysis/0${subj}/MVPA/breakpoint_rts_unsmoothed_native_antsmask/brocas_rois
if [[ ! -d $brocas_dir ]]; then
  mkdir $brocas_dir
fi

# 44
fslmaths $atlas_epi_space -thr 2301 -uthr 2301 $brocas_dir/BA44_L.nii.gz
fslmaths $brocas_dir/BA44_L.nii.gz -bin $brocas_dir/BA44_L.nii.gz
fslmaths $atlas_epi_space -thr 2302 -uthr 2302 $brocas_dir/BA44_R.nii.gz
fslmaths $brocas_dir/BA44_R.nii.gz -bin $brocas_dir/BA44_R.nii.gz
# 45
fslmaths $atlas_epi_space -thr 2311 -uthr 2311 $brocas_dir/BA45_L.nii.gz
fslmaths $brocas_dir/BA45_L.nii.gz -bin $brocas_dir/BA45_L.nii.gz
fslmaths $atlas_epi_space -thr 2312 -uthr 2312 $brocas_dir/BA45_R.nii.gz
fslmaths $brocas_dir/BA45_R.nii.gz -bin $brocas_dir/BA45_R.nii.gz
# 47
fslmaths $atlas_epi_space -thr 2321 -uthr 2321 $brocas_dir/BA47_L.nii.gz
fslmaths $brocas_dir/BA47_L.nii.gz -bin $brocas_dir/BA47_L.nii.gz
fslmaths $atlas_epi_space -thr 2322 -uthr 2322 $brocas_dir/BA47_R.nii.gz
fslmaths $brocas_dir/BA47_R.nii.gz -bin $brocas_dir/BA47_R.nii.gz
# 44+45
fslmaths $brocas_dir/BA44_L.nii.gz -add $brocas_dir/BA44_R.nii.gz $brocas_dir/BA44_mask.nii.gz
fslmaths $brocas_dir/BA45_L.nii.gz -add $brocas_dir/BA45_R.nii.gz $brocas_dir/BA45_mask.nii.gz
fslmaths $brocas_dir/BA47_L.nii.gz -add $brocas_dir/BA47_R.nii.gz $brocas_dir/BA47_mask.nii.gz
fslmaths $brocas_dir/BA44_L.nii.gz -add $brocas_dir/BA44_R.nii.gz -add $brocas_dir/BA45_L.nii.gz -add $brocas_dir/BA45_R.nii.gz $brocas_dir/BA44+45_mask.nii.gz
fslmaths $brocas_dir/BA44_L.nii.gz -add $brocas_dir/BA44_R.nii.gz -add $brocas_dir/BA45_L.nii.gz -add $brocas_dir/BA45_R.nii.gz -add $brocas_dir/BA47_L.nii.gz -add $brocas_dir/BA47_R.nii.gz $brocas_dir/BA44+45+47_mask.nii.gz
# clean up L and R masks
rm $brocas_dir/BA44_L.nii.gz $brocas_dir/BA44_R.nii.gz $brocas_dir/BA45_L.nii.gz $brocas_dir/BA45_R.nii.gz $brocas_dir/BA47_L.nii.gz $brocas_dir/BA47_R.nii.gz