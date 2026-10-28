function [] = plot_histogram_of_contrast_pmap(subject,contrast,num_bins,outfile)



real_data = load_untouch_nii(sprintf('/N/project/brainevo/Sentence_reading/%02d/windowType1/%s_real/res_accuracy_minus_chance.nii.gz',subject,contrast)).img;
mask_data = load_untouch_nii(sprintf('/N/slate/brainevo/Implicit_Learning/ants_registrations/sentence_reading/%02d/mask_epi.nii.gz',subject)).img;
pixdim = size(mask_data);
total_voxels = sum(mask_data(:,:,:),'all');

perm_folder = sprintf('/N/project/brainevo/Sentence_reading/%02d/windowType1/%s_perm',subject,contrast);
perm_dirs = dir(fullfile(perm_folder, 'perm*'));
num_perms = numel(perm_dirs);

perm_data = zeros(num_perms,pixdim(1),pixdim(2),pixdim(3));

for i = 1:num_perms
  perm_img = load_untouch_nii(['/N/project/brainevo/Sentence_reading/02/windowType1/AP_perm/' perm_dirs(i).name '/res_accuracy_minus_chance.nii.gz']).img;
  perm_data(i,:,:,:) = perm_img(:,:,:);
end

p_map = zeros(pixdim(1),pixdim(2),pixdim(3));
n = 1;
for i = 1:pixdim(1)
  for j = 1:pixdim(2)
    for k = 1:pixdim(3)
      if mask_data(i,j,k) == 1
        p_vec(n) = (sum(perm_data(:,i,j,k) >= real_data(i,j,k))+1) / (num_perms+1); % build vector for histogram visualization
        n = n+1;
        p_map(i,j,k) = (sum(perm_data(:,i,j,k) >= real_data(i,j,k))+1) / (num_perms+1); % also optionally save map
      end
    end
  end
end

if outfile ~= 'none'
  save_untouch_nii(p_map, outfile);
end

% plot histogram of data, plus baseline of even distribution
histogram(p_vec, num_bins)
hold on
yline(total_voxels / num_bins, 'r--', 'LineWidth', 1);

end
