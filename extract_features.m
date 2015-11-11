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

function [X,Y,Patch] = extract_features (T1, T2, Flair,Lesion,filt)

    n = size(Flair,3);
    p = size(filt,3);
    X=[];
    Y = Lesion;
    Y = round(Y);
    prg_setup;
    
    [patches , labels] = extract_patches( Y );
    Patch =[patches,labels];
    Patch = sortrows(Patch,3);
    %patches = sortrows(patches,3);

    prev = zeros(size(T1,1), size(T1,2));

    for iter = 1:size(Patch,1);
        I_Flair = Flair(:,:,Patch(iter,3));
        I_T1 = T1(:,:,Patch(iter,3));
        I_T2 = T2(:,:,Patch(iter,3));

        I_T1 = I_T1./mean(I_T1(I_T1(:)>0));
        I_T2 = I_T2./mean(I_T2(I_T2(:)>0));
        I_Flair = I_Flair./mean(I_Flair(I_Flair(:)>0));       

        I_patient=zeros([size(I_T1) p*3]);
        I_haar=zeros([(size(I_T1)-7) 9]);               
        
        if prev ~= I_T1
            % Compute Haar-like Features
            [Hx,Hy,mag]=prg_haar_features(I_T1);
            I_haar(:,:,1) = Hx;
            I_haar(:,:,2) = Hy;
            I_haar(:,:,3) = mag;
            [Hx,Hy,mag]=prg_haar_features(I_T2);
            I_haar(:,:,4) = Hx;
            I_haar(:,:,5) = Hy;
            I_haar(:,:,6) = mag;
            [Hx,Hy,mag]=prg_haar_features(I_Flair);
            I_haar(:,:,7) = Hx;
            I_haar(:,:,8) = Hy;
            I_haar(:,:,9) = mag;
            I_haar = padarray(I_haar,[11,11],'replicate','post');
            
            % Compute LM Filter bank features
            for jter = 1:p
                f = filt(:,:,jter);
    %             f = f./mean(f(f(:)>0));
                cf = conv2(I_Flair,f,'same');
                c1 = conv2(I_T1,f,'same');
                c2 = conv2(I_T2,f,'same');
                I_patient(:,:,jter) = cf;
                I_patient(:,:,jter + p) = c1;
                I_patient(:,:,jter + (2*p)) = c2;

            end
        else
            I_haar = padarray(I_haar,[7,7],'replicate','post');
        end
        prev = I_T1;
        
        B = I_haar(Patch(iter,1),Patch(iter,2),:);
        B = reshape(B,[1,9]);
        
        feat = I_patient(Patch(iter,1),Patch(iter,2),:);
        feat = reshape(feat,[1,144]);
        
        xx = I_T1(Patch(iter,1), Patch(iter,2));
        yy = I_T2(Patch(iter,1), Patch(iter,2));
        zz = I_Flair(Patch(iter,1), Patch(iter,2));
        features = [xx,yy,zz,B,feat,Patch(iter,4)];
       
        X=[X;features];
    end
end
