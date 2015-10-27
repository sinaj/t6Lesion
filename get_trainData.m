% This function returns the feature vectors for the data downloaded from
% Brain Web. It is a 1mm resolution MRI simulation.
% Input images are of 3 modalities - T1,T2, PD - Size 217 x 181 x 181
% Each slice would be taken as the train/test image - 217 x 181 x 1
% Output X - (217*181) x 181 x 4
%           - X is the feature vector which has considers the normalized
%           intensities and gradient as features for every pixel in the
%           image
%           For every training image, the feature vector would be
%           X(1:217,:,:), i.e., 217 x 181 x 4
% Output Y is just slices of MRI scan with Lesion data - 217 x 181 x 181

function [X,Y] = get_trainData
[PD,scaninfo] = loadminc('pd_ai_msles2_1mm_pn3_rf20.mnc');
[T2,scaninfo] = loadminc('t2_ai_msles2_1mm_pn3_rf20.mnc');
[T1,scaninfo] = loadminc('t1_ai_msles2_1mm_pn3_rf20.mnc');

n = size(PD,3);
X=[];
[Y,scaninfo] = loadminc('phantom_1.0mm_msles2_wml.mnc');

for iter = 1:n
    I_PD = PD(:,:,iter);
    I_T1 = T1(:,:,iter);
    I_T2 = T2(:,:,iter);
    I_patient=zeros([size(I_PD) 4]);
    I_patient(:,:,1)=I_PD./mean(I_PD(I_PD(:)>0));
    I_patient(:,:,2)=I_T1./mean(I_T1(I_T1(:)>0));
    I_patient(:,:,3)=I_T2./mean(I_T2(I_T2(:)>0));
    % also add a gradient image
    [fy,fx]=gradient(I_PD);
    I_patient(:,:,4)=fx.^2+fy.^2;
    X = [X;I_patient];

end
