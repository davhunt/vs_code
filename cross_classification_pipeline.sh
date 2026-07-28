#!/bin/bash

# For all subjects,
#1) Register / align all sentence reading fMRI raf* images to complex seq fMRI raf* images
#2) Update (create new?) batch scripts to 1)create SPM.mat, and 2)create new beta maps (in the same space as complex seq)
#3) Copy over mask.nii from complex seq folder
#4) Run decoding, using all complex seq betas as training set and all sentence reading betas as testing set
#5) Get some idea of significance of decoding accuracy values, possibly at some point
#       running a permutation analysis

# Other ideas: Run cross-classification decoding using BA44, BA45, and BA44+45 as ROIs



fslmerge -t all_raf.nii.gz raf*.nii
fslmaths all_raf.nii.gz -Tmean mean_raf.nii.gz

antsRegistration --dimensionality 3 \
    --output "[SR2complx_,SR2complx_Warped.nii.gz]" \
    --interpolation Linear \
    --winsorize-image-intensities "[0.005,0.995]" \
    --use-histogram-matching 0 \
    --initial-moving-transform "[/Volumes/data1/T1_and_Complex_seq/002/mean_raf.nii.gz,/Volumes/data1/Implicit_Learning/Sentence_reading/002/mean_raf.nii.gz,1]" \
    --transform "Rigid[0.1]" \
    --metric "MI[/Volumes/data1/T1_and_Complex_seq/002/mean_raf.nii.gz,/Volumes/data1/Implicit_Learning/Sentence_reading/002/mean_raf.nii.gz,1,32,Regular,0.25]" \
    --convergence "[1000x500x250x0,1e-6,10]" \
    --shrink-factors 8x4x2x1 \
    --smoothing-sigmas 3x2x1x0vox

for f in beta_*.nii
    do
    base=$(basename "$f" .nii)
    antsApplyTransforms \
        -d 3 \
        -i "$f" \
        -r /Volumes/data1/Complex_seq_analysis/002/MVPA/breakpoint_rts_unsmoothed_native_antsmask/beta_0001.nii \
        -o "/Volumes/data1/Implicit_Learning/sentence_reading_analysis/002_native_space/complex_seq_space/${base}.nii" \
        -n Linear \
        -t /Volumes/data1/Implicit_Learning/sentence_reading_analysis/002_native_space/test_cross_classification/SR2complx_0GenericAffine.mat
done

#for i in $(seq -w 1 68); do cp beta_00${i}.nii old_beta_00${i}.nii; done
#for i in $(seq -w 1 68); do fslcpgeom old_beta_00${i}.nii beta_00${i}.nii; done
######## Fix beta headers within SPM, ("spm_fix_headers.m" or something)
# >> files = dir('/Volumes/data1/Implicit_Learning/sentence_reading_analysis/002_native_space/complex_seq_space/old_beta_*.nii');
# >> for i = 1:numel(files)
# fname = fullfile(files(i).folder, files(i).name);
# V = spm_vol(fname);
# Y = spm_read_vols(V);
# V.mat = ref.mat;
# V.private.mat = ref.mat;
# V.private.mat0 = ref.mat;
# V.fname = fullfile(files(i).folder, ['spmfix_' files(i).name]);
# V = spm_create_vol(V);
# spm_write_vol(V,Y);
# end
# >> 
## for num in $(seq -w 1 68); do mv "spmfix_old_beta_00${num}.nii" "beta_00${num}.nii"; done