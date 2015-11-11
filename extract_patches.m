function [ patches , labels] = extract_patches( X, Y )

% Initial Settings
patch_size_half = 3;
train_data_size = min(1000, sum(Y == 1));
neg_pos_ratio = 2;
max_negative_patch_intersection_with_lesion = 0.1;

% Determine number of positive and negative data
patches = [];
labels = [];
positive_samples_size = floor(train_data_size / (neg_pos_ratio + 1));
negative_samples_size = floor(train_data_size * neg_pos_ratio / (neg_pos_ratio + 1));

% Find the position of positive data and store it in a matrix
[p1, p2, p3] = ind2sub(size(Y), find(Y == 1));
pos_subs = [p1'; p2'; p3']';

i = 1;
while true
    if i >= positive_samples_size
        break;
    end
    % Select a random positive sample
    sample_index = ceil(rand() * size(pos_subs, 1));
    patch_center = pos_subs(sample_index, :); 
    % Force the patch to be inside of matrix
    patch_center = max(patch_size_half + 1, patch_center);
    patch_center(:, 1) = min(size(Y, 1) - patch_size_half - 1, patch_center(:, 1));
    patch_center(:, 2) = min(size(Y, 2) - patch_size_half - 1, patch_center(:, 2));
    patch_center(:, 3) = min(size(Y, 3) - patch_size_half - 1, patch_center(:, 3));
    % Determine the cube position
    patch_subs_min = patch_center - patch_size_half; 
    patch_subs_max = patch_center + patch_size_half;
    
    % Select the patch and add it to patches
    patch = X(patch_subs_min(1):patch_subs_max(1),...
        patch_subs_min(2):patch_subs_max(2), patch_subs_min(3):patch_subs_max(3), :);
    patches = cat(5, patches, patch);
    labels = cat(1, labels, 1);
    % Remove the sample from positives
    pos_subs(sample_index, :) = [];
    
    i = i + 1;
end

i = 1;
while true
    if i >= negative_samples_size
        break;
    end
    while true
        % Select a random sample
        patch_center = [ceil(rand() * size(Y, 1)), ceil(rand() * size(Y, 2)), ceil(rand() * size(Y, 3))]; 
        % Force the patch to be inside of matrix
        patch_center = max(patch_size_half + 1, patch_center);
        patch_center(:, 1) = min(size(Y, 1) - patch_size_half - 1, patch_center(:, 1));
        patch_center(:, 2) = min(size(Y, 2) - patch_size_half - 1, patch_center(:, 2));
        patch_center(:, 3) = min(size(Y, 3) - patch_size_half - 1, patch_center(:, 3));
        % Determine the cube position
        patch_subs_min = patch_center - patch_size_half; 
        patch_subs_max = patch_center + patch_size_half;

        % Select the patch
        patch = X(patch_subs_min(1):patch_subs_max(1),...
            patch_subs_min(2):patch_subs_max(2), patch_subs_min(3):patch_subs_max(3), :);
        
        % Check if the patch doesn't overlap with a lesion
        labels_in_patch = Y(patch_subs_min(1):patch_subs_max(1),...
            patch_subs_min(2):patch_subs_max(2), patch_subs_min(3):patch_subs_max(3));
        if sum(sum(sum(labels_in_patch))) / (2*patch_size_half+1)^3 <= max_negative_patch_intersection_with_lesion
            patches = cat(5, patches, patch);
            labels = cat(1, labels, 0);
            break;
        end
    end
    
    i = i + 1;
end

end