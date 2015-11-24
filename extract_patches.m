function [ patches , labels] = extract_patches( Y )
% Inputs: -Y: This should be a 3D matrix holding zeros and ones to
% represent the labels.
% Outputs: - patches: A 2D matrix in each row coordinates of a selected
%          sample are available
%          - labels: A vector in each item a label (0 or 1) of the selected
%          sample is available

% Initial Settings
neg_pos_ratio = 2;
max_samples_num = 40000;

train_data_size = min(max_samples_num, (neg_pos_ratio + 1) * sum(sum(sum(Y == 1))));

% Determine number of positive and negative data
patches = [];
labels = [];
positive_samples_size = floor(train_data_size / (neg_pos_ratio + 1));
negative_samples_size = floor(train_data_size * neg_pos_ratio / (neg_pos_ratio + 1));

% Find the position of positive data and store it in a matrix
positives_ind = find(Y == 1);
[p1, p2, p3] = ind2sub(size(Y), positives_ind);
pos_subs = [p1'; p2'; p3']';

i = 1;
while true
    if i >= negative_samples_size
        break;
    end
    while true
        % Select a random sample
        patch_ind = ceil(rand() * size(Y, 1) * size(Y, 2) * size(Y, 3)); 
        
        % Check if the patch is not a lesion add to samples
        if isempty(find(positives_ind == patch_ind, 1))
            [p1, p2, p3] = ind2sub(size(Y), patch_ind);
            patch = [p1 p2 p3];
            patches = cat(1, patches, patch);
            labels = cat(1, labels, 0);
            break;
        end
    end
    
    i = i + 1;
end

i = 1;
while true
    if i >= positive_samples_size
        break;
    end
    % Select a random positive sample
    sample_index = ceil(rand() * size(pos_subs, 1));
    patch_ind = pos_subs(sample_index, :); 
    % Add to samples
    patches = cat(1, patches, patch_ind);
    labels = cat(1, labels, 1);
    % Remove the sample from positives
    pos_subs(sample_index, :) = [];
    
    i = i + 1;
end


end