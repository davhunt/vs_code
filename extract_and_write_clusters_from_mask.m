function [] = extract_and_write_clusters_from_mask(sigclusters_img, outdir)

addpath(genpath('/Users/lab/Downloads/matlab_nifti_tools'));
addpath(genpath('/Users/lab/Downloads/spm12'))

vol = spm_vol(sigclusters_img);
dat = spm_read_vols(vol);
conn = bwconncomp(dat,6);

blank_nii = load_untouch_nii(sigclusters_img);
blank_nii.img = zeros(size(dat));

n = 1;
for i = 1:length(conn.PixelIdxList)
    idx = conn.PixelIdxList{i};
    cluster_size = length(conn.PixelIdxList{i});
    if cluster_size >= 25
        img = zeros(size(dat));
        for j = 1:length(conn.PixelIdxList{i})
            [x,y,z] = ind2sub(size(dat), conn.PixelIdxList{i}(j)); % indices of non-zero voxels
            img(x,y,z) = 1;
        end
        blank_nii.img = img;
        save_untouch_nii(blank_nii,fullfile(outdir,['cluster' num2str(n) '.nii.gz']));
        n = n+1;
    end
end