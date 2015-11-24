% This function returns the feature vectors for the data downloaded from
% Brain Web. It is a 1mm resolution MRI simulation.
% Input images are of 3 modalities - T1,T2, Flair - Size 512 x 512 x 512
% Each slice would be taken as the train/test image - 512 x 512 x 1
% Output X - (512*512) x 512 x (48*3)
%           - X is the feature vector which has the final result of the 
%           For every training image, the feature vector would be
%           X(1:217,:,:), i.e., 217 x 181 x 4
% Output Y is just slices of MRI scan with Lesion data - 217 x 181 x 181

function [X,Yt] = extract_slice_features (T1, T2, Flair,Lesion,sliceNumbers,filt)
    if nargin < 6
        filt = makeLMfilters;
    end
    n = size(Flair,3);
    p = size(filt,3);
    Xt=[];
    X=[];
    for index = 1:size(sliceNumbers,2)
        sliceNumber = sliceNumbers(index);
        Yt = Lesion(:,:,sliceNumber);
        f = filt(:,:,1);
        disp('This is the Feature Extraction for a particular slice');

        iter = sliceNumber;
            I_Flair = Flair(:,:,iter);
            I_T1 = T1(:,:,iter);
            I_T2 = T2(:,:,iter);

            I_T1 = normalize(I_T1);
            I_T2 = normalize(I_T2);
            I_Flair = normalize(I_Flair);       

            I_patient=zeros([(size(f)+size(I_T1)-1) p*3]);
            I_haar=zeros([(size(I_T1)-7) 9]);               

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
                I_haar = padarray(I_haar,[7,7],'replicate','post');

                % Compute LM Filter bank features
                for jter = 1:p
                    f = filt(:,:,jter);

                    cf = conv2(I_Flair,f);
                    c1 = conv2(I_T1,f);
                    c2 = conv2(I_T2,f);
                    I_patient(:,:,jter) = cf;
                    I_patient(:,:,jter + p) = c1;
                    I_patient(:,:,jter + (2*p)) = c2;

                end
            I_patient = I_patient(25:end-24,25:end-24,:);
            Xt = cat(3,I_T1,I_T2,I_Flair,I_haar,I_patient);
            
            Xt = reshape(Xt,[size(I_T1,1)*size(I_T1,2),size(Xt,3)]);
            Yt = reshape(Yt,[size(I_T1,1)*size(I_T1,2),size(Yt,3)]);
      
            X = cat(1,X,Xt);
    end
end
