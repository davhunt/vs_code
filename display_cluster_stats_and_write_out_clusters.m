function [] = display_cluster_stats_and_write_out_clusters(sigclusters_img, outdir, cluster_threshold, group_acc)

% Report extent, centroid, peak voxel coordinates (MNI), peak decoding % for each cluster in significant voxels mask (i.e. p<0.001 mask)

addpath(genpath('/Users/lab/Downloads/matlab_nifti_tools'));
addpath(genpath('/Users/lab/Downloads/spm12'));

V = spm_vol(sigclusters_img);
Y = spm_read_vols(V);
temp_nii = load_untouch_nii(sigclusters_img);
temp_nii.img = zeros(size(Y));

if ~isdir(outdir)
    mkdir(outdir);
else
end

group_accuracy_vol = spm_vol(group_acc);
group_accuracy_img = spm_read_vols(group_accuracy_vol);

%AAL_atlas = spm_vol('/Users/lab/Downloads/aal116/aal116MNI.nii.gz'); % old atlas version
%AAL_atlas_img = spm_read_vols(AAL_atlas);
%AAL_indices = load('/Users/lab/Downloads/aal116/aal116NodeIndex.1D');
%AAL_names = readlines('/Users/lab/Downloads/aal116/aal116NodeNames.txt');
AAL_atlas = spm_vol('/Users/lab/Downloads/AAL3/AAL3v1.nii.gz');
AAL_atlas_img = spm_read_vols(AAL_atlas);
AAL_labels = readlines('/Users/lab/Downloads/AAL3/AAL3v1.nii.txt');
AAL_indices = []; AAL_names = []; % AAL_indices: 170x1 double, AAL_names: 170x1 string array
for i = 1:size(AAL_labels,1)
    line = split(AAL_labels(i),' ');
    if size(line,1) >= 2
        AAL_indices = [AAL_indices; double(line(1))];
        AAL_names = [AAL_names; line(2)];
    end
end

% get coords
XYZ = find(Y > 0);
[x,y,z] = ind2sub(size(Y),XYZ);
XYZ = [x y z]';
% get clusters, cluster labels
A = spm_clusters(XYZ);
cluster_ids = unique(A);

n = 1; % index clusters that exceed voxel extent threshold
for i = 1:length(cluster_ids)
    idx = find(A==cluster_ids(i));
    cluster_size = numel(idx);
    if cluster_size >= cluster_threshold
        voxels = XYZ(:,idx); % 3 x n matrix of voxel coords
        centroid = mean(voxels,2);
        values = group_accuracy_img(sub2ind(size(group_accuracy_img),voxels(1,:),voxels(2,:),voxels(3,:)));
        [max_acc,max_idx] = max(values);
        peak_voxel = voxels(:,max_idx); % peak decoding accuracy voxel within the cluster
        mni = V.mat * [peak_voxel;1]; % MNI coordinates of peak voxel
        AAL_idx = AAL_atlas_img(peak_voxel(1),peak_voxel(2),peak_voxel(3));
        %AAL_idx = AAL_atlas_img(centroid(1),centroid(2),centroid(3)); % centroid?
        ROI_idx = find(AAL_indices == AAL_idx);
        if ~isempty(ROI_idx)
            ROI_name = AAL_names(ROI_idx);
        else
            ROI_name = 'none';
        end
        %mni = mni(1:3);
        fprintf('Cluster %d: %d voxels, ROI: %s, centroid: %.2f %.2f %.2f, peak accuracy: %.3f, MNI coords: %.2f %.2f %.2f\n',cluster_ids(i),cluster_size, ROI_name, centroid(1), centroid(2), centroid(3),max_acc,mni(1),mni(2),mni(3));
        % Then write out cluster (binary mask) to .nii file
        img = zeros(size(temp_nii.img));
        for j = 1:size(voxels,2)
            img(voxels(1,j),voxels(2,j),voxels(3,j)) = 1;
        end
        temp_nii.img = img;
        %save_untouch_nii(temp_nii,fullfile(outdir,['cluster' num2str(n) '.nii.gz']));
        n = n+1;
        %save_untouch_nii(temp_nii,fullfile(outdir,['cluster_' num2str(i) '_' char(ROI_name) '.nii.gz']));
        save_untouch_nii(temp_nii,fullfile(outdir,['cluster_' char(ROI_name) '_' num2str(size(voxels,2)) 'vox.nii.gz']));
    end
end

end