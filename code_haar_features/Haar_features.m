% Code to extract Context (Haar-like features)
% Input T1, T2, Flair are preloaded images, i.e., they're matlab variables
% loaded using loadminc or readnrrd
% Input image dimensions = 512 x 512 x 512 (m x n x p)
% The filter size is 10 x 10. 
% The output image is usually given as (m-11) x (n-11) x (p-11)
% In this case (501 x 512) x 501 x 9

function X = Haar_features(T1,T2,Flair)
    prg_setup;
    n = size(T1,3);
    X = [];
    for iter = 1:n
        I_Flair = Flair(:,:,iter);
        I_T1 = T1(:,:,iter);
        I_T2 = T2(:,:,iter);
        I_patient=zeros([(size(I_T1)-11) 9]);
        [Hx,Hy,mag]=prg_haar_features(I_T1);
        I_patient(:,:,1) = Hx;
        I_patient(:,:,2) = Hy;
        I_patient(:,:,3) = mag;
        [Hx,Hy,mag]=prg_haar_features(I_T2);
        I_patient(:,:,4) = Hx;
        I_patient(:,:,5) = Hy;
        I_patient(:,:,6) = mag;
        [Hx,Hy,mag]=prg_haar_features(I_Flair);
        I_patient(:,:,7) = Hx;
        I_patient(:,:,8) = Hy;
        I_patient(:,:,9) = mag;
        X=[X;I_patient];
    end
end
        
        