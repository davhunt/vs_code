#!/bin/bash

for sub in 3 4 5 6 7 8 9 10 13 14 15 16 17 18 19 20 21 22 23 24; do
#for sub in 2; do
  sub=$(printf "%02d" $sub)
  for roi in BA44 BA45 BA47 BA44+45; do
    matlab -nodisplay -nosplash -nodesktop -r "addpath('/Users/lab/Downloads/tdt_3.999I/decoding_toolbox/templates'); \
      decoding_template_gng_brocas_rois_initial(${sub},10,'/Volumes/data1/Complex_seq_analysis/0${sub}/MVPA/durations_unsmoothed_native/brocas_rois/${roi}_mask.nii.gz','${roi}'); exit();"
  done
done
