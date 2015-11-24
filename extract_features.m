% This function returns the feature vectors for the data downloaded from
% Brain Web. It is a 1mm resolution MRI simulation.
% Input images are of 3 modalities - T1,T2, Flair - Size 512 x 512 x 512
% Each slice would be taken as the train/test image - 512 x 512 x 1
% The image with lesions Labeled Y is given as input to extract_patches.
% This provides an output of roughly 40k points, i.e., the coordinates of
% pixels to consider as training data.
% The output X would be ~40k x 157
%           - X is the feature vector which has the final result of the 
%           For every training image, the feature vector would be
%		3 intensities, 144 LM filters and 9 Haar-like features.
%		The label for each of those points is added as the last 
%		column in the feature vector. Hence, X(:,157) = Labels	
% Output Patch is the coordinates of the pixels considered as training data

function [X,Patch] = extract_features (T1, T2, Flair,Lesion,filt)

    X=[];
    Y=round(Lesion);
    [patches , labels] = extract_patches(Y);
    Patch =[patches,labels];
    Patch = sortrows(Patch,3);
    
    prev = Patch(10000,3);
    for iter = 1:size(Patch,1)
        if prev~=Patch(iter,3)
            [Xt,Yt] = extract_slice_features (T1, T2, Flair,Lesion,Patch(iter,3),filt);
        end
        prev = Patch(iter,3);
        
        feat = Xt(Patch(iter,1),Patch(iter,2),:);
        feat = reshape(feat,[1,size(Xt,3)]);
        features = [feat,Patch(iter,4)];       
        X=[X;features];
    end
    
end
