#!/bin/bash

# Create significant clusters mask from observed p-value map and various thresholded cluster corrected masks
# Resulting clusters will be FWE significant at that p level

wd=$1
prefix="tstat_tfce_"

for thr in 05 01 005 001 0005
  do
  fslmaths ${wd}/${prefix}group_clstr_corrected_pFWE.nii.gz -mas ${wd}/${prefix}group_clstr_corrected_pFWE${thr}_clusters.nii.gz ${wd}/${prefix}group_clstr_corrected_pFWE${thr}_observed.nii.gz
  val=$(echo .${thr:0:4}) # 05 -> .05, 001 -> .001 etc
  fslmaths ${wd}/${prefix}group_clstr_corrected_pFWE${thr}_observed.nii.gz -uthr ${val} ${wd}/${prefix}group_clstr_corrected_pFWE${thr}_observed_uthr.nii.gz
  fslmaths ${wd}/${prefix}group_clstr_corrected_pFWE${thr}_observed_uthr.nii.gz -bin ${wd}/${prefix}group_clstr_corrected_pFWE${thr}_mask_sigclusters.nii.gz
done