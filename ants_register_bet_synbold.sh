#!/bin/bash

subj=$1 # "18" e.g.
subj=$(printf "%02d" $subj)

cp /Volumes/data1/T1_and_Complex_seq/0${subj}/func_mean.nii.gz /Users/lab/Downloads/ants_registrations/${subj}/func_mean.nii.gz
C=($(find /Volumes/data1/T1_and_Complex_seq/0${subj} -type f -exec basename {} \; | grep -E '^s[0-9]+toms.*$'))
t1=/Volumes/data1/T1_and_Complex_seq/0${subj}/${C[0]} # first is non-"NORM" one # Be careful not to grab a localizer, three localizers in first run
cp $t1 /Users/lab/Downloads/ants_registrations/${subj}/T1_orig.nii # These files are not yet gzipped?
gzip /Users/lab/Downloads/ants_registrations/${subj}/T1_orig.nii
fslreorient2std /Users/lab/Downloads/ants_registrations/${subj}/T1_orig.nii.gz /Users/lab/Downloads/ants_registrations/${subj}/T1.nii.gz
t1_reor=/Users/lab/Downloads/ants_registrations/${subj}/T1.nii.gz

antsBrainExtraction.sh -d 3 -a $t1_reor -e /Volumes/data1/atlases/OASIS-30_Atropos_template/T_template0.nii.gz \
  -m /Volumes/data1/atlases/OASIS-30_Atropos_template/T_template0_BrainCerebellumProbabilityMask.nii.gz -o /Users/lab/Downloads/ants_registrations/${subj}/sub-${subj}_T1_ \
  -f /Volumes/data1/atlases/OASIS-30_Atropos_template/T_template0_BrainCerebellumRegistrationMask.nii.gz -k 1

#Rscript /Users/lab/vs_code/register_synbold.R $subj
Rscript /Users/lab/Downloads/ants_registrations/register_synbold.R $subj

#MNI_TEMPLATE=/Users/lab/Downloads/templateflow/tpl-MNI152NLin2009cAsym/tpl-MNI152NLin2009cAsym_res-01_T1w.nii.gz
MNI_TEMPLATE=/Users/lab/Downloads/templateflow/tpl-MNI152NLin2009cAsym/tpl-MNI152NLin2009cAsym_res-01_desc-brain_T1w.nii.gz

antsRegistrationSyN.sh -d 3 -f $MNI_TEMPLATE \
  -m /Users/lab/Downloads/ants_registrations/${subj}/sub-${subj}_T1_BrainExtractionBrain.nii.gz -o /Users/lab/Downloads/ants_registrations/${subj}/sub-${subj}_T1w_to_MNI_

#antsApplyTransforms -d 3 -i ${t1} -r ${mni_template} -o ${out_file} -t ${t1} -t ${t0} --interpolation Linear




# then apply transform like:
# for sub in 01 02 03 04 05 06 07 08 09 10 13 14 15 16 17 18 19 20 21 22 23 24; do
# antsApplyTransforms -d 3 -i /Users/lab/Downloads/aal116/aal116MNI.nii.gz \
#  -r /Users/lab/Downloads/ants_registrations/${sub}/func_mean.nii.gz \
#  -o /Users/lab/Downloads/ants_registrations/${sub}/aal116_in_epi_6to2009c.nii.gz \
#  -t /Users/lab/Downloads/ants_registrations/${sub}/synbold_invwarp_t1_to_epi_0GenericAffine.mat \
#  -t "[/Users/lab/Downloads/ants_registrations/${sub}/sub-${sub}_T1w_to_MNI_0GenericAffine.mat,1]" \
#  -t /Users/lab/Downloads/ants_registrations/${sub}/sub-${sub}_T1w_to_MNI_1InverseWarp.nii.gz \
#  -t /Users/lab/Downloads/ants_registrations/MNI152NLin6Asym_to_MNI152NLin2009c/MNI6_to_MNI2009c_1Warp.nii.gz 
#  -t /Users/lab/Downloads/ants_registrations/MNI152NLin6Asym_to_MNI152NLin2009c/MNI6_to_MNI2009c_0GenericAffine.mat \
#  -n NearestNeighbor; done