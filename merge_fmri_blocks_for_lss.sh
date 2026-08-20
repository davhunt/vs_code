#!/bin/bash


#subs=(01 02 03 04 05 06 07 08 09 10 13 14 15 16 17 18 19 20 21 22 23 24)
subs=(1 2 3 4 5 6 7 8 9 10 13 14 15 16 17 18 19 20 21 22 23 24)


block1_arr=(5 6 5 6 5 6 5 6 5 6 5 6 5 6 5 8 5 6 5 6 5 6)
block2_arr=(6 7 6 7 6 7 6 8 6 7 6 7 6 7 6 9 6 7 6 7 6 7)
block3_arr=(7 8 7 8 7 8 7 9 7 8 7 8 7 8 7 10 7 8 7 8 7 8)
block4_arr=(8 9 8 9 8 9 8 10 8 9 8 9 8 9 8 11 8 9 8 9 8 9)

sr_dir=/Volumes/data1/Implicit_Learning/Sentence_reading

for subnum in $(seq 8 21)
  do
  if [[ $subnum -eq 2 ]] || [[ $subnum -eq 12 ]]; then continue; fi # already did sub-03, 15 not ready yet
  sub=$(printf "%02d" ${subs[$subnum]})
  cd $sr_dir/0${sub}
  file_re="^raf[0-9]{4}tomsImplicitLearning-00$(printf "%02d\n" ${block1_arr[$subnum]})-.*.nii$"
  fslmerge -t $sr_dir/0${sub}/block1_merged.nii.gz $(ls | grep -E $file_re)
  file_re="^raf[0-9]{4}tomsImplicitLearning-00$(printf "%02d\n" ${block2_arr[$subnum]})-.*.nii$"
  fslmerge -t $sr_dir/0${sub}/block2_merged.nii.gz $(ls | grep -E $file_re)
  file_re="^raf[0-9]{4}tomsImplicitLearning-00$(printf "%02d\n" ${block3_arr[$subnum]})-.*.nii$"
  fslmerge -t $sr_dir/0${sub}/block3_merged.nii.gz $(ls | grep -E $file_re)
  file_re="^raf[0-9]{4}tomsImplicitLearning-00$(printf "%02d\n" ${block4_arr[$subnum]})-.*.nii$"
  fslmerge -t $sr_dir/0${sub}/block4_merged.nii.gz $(ls | grep -E $file_re)
done

for block in 1 2 3 4; do gunzip $sr_dir/0${sub}/block${block}_merged.nii.gz; done # SPM hates .gz files