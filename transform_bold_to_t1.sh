#!/bin/bash

#subs=(02 03 04 05 06 07 08 09 10 13 14 15 16 17 18 19 20 21 22 23 24)
subs=(01)
for sub in ${subs[@]}; do
    bold=/Volumes/data1/T1_and_Complex_seq/0${sub}/func_mean.nii.gz
    C=($(find /Volumes/data1/T1_and_Complex_seq/0${sub} -type f -exec basename {} \; | grep -E '^s[0-9]+toms.*$'))
    t1=/Volumes/data1/T1_and_Complex_seq/0${sub}/${C[0]}
    out_file=/Users/lab/Downloads/ants_bold2t1_and_t12mni/${sub}/bold_in_T1.nii.gz
    aff_file=/Users/lab/Downloads/ants_registrations/${sub}/epi_to_t1_0GenericAffine.mat
    antsApplyTransforms -d 3 -i ${bold} -r ${t1} -o ${out_file} -t ${aff_file} --interpolation Linear

    mni_template=$FSLDIR/data/standard/MNI152_T1_2mm.nii.gz
    out_file=/Users/lab/Downloads/ants_bold2t1_and_t12mni/${sub}/T1_in_MNI.nii.gz
    w1=/Users/lab/Downloads/ants_registrations/${sub}/t1_to_mni_1Warp.nii.gz
    w0=/Users/lab/Downloads/ants_registrations/${sub}/t1_to_mni_0GenericAffine.mat
    antsApplyTransforms -d 3 -i ${t1} -r ${mni_template} -o ${out_file} -t ${w1} -t ${w0} --interpolation Linear

    out_file=/Users/lab/Downloads/ants_bold2t1_and_t12mni/${sub}/bold_in_MNI.nii.gz
    antsApplyTransforms -d 3 -i ${bold} -r ${mni_template} -o ${out_file} -t ${w1} -t ${w0} -t ${aff_file} --interpolation Linear

    cp $bold /Users/lab/Downloads/ants_bold2t1_and_t12mni/${sub}/mean_bold.nii.gz
    t1_base=$(basename $t1)
    cp $t1 /Users/lab/Downloads/ants_bold2t1_and_t12mni/${sub}/${t1_base}
done
