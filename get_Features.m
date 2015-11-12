function [ X,Y ] = get_Features(t1,t2,pd,Y,pix,sigma)
%This functions gives gaissian and entropy features of every point, pass
%the corresponding t1 t2 and pd with y, pix saus how much surrounding for
%each pixel it should take, and sigma is the sigma for gausian fit, the out
%put is 217 181 181 6.

iter=size(pd,3);
X=[];
for iteration = 1:iter
    %normailsation
    t1_img=t1(:,:,iteration)/max(max(t1(:,:,iteration)));
    t2_img=t2(:,:,iteration)/max(max(t2(:,:,iteration)));
    pd_img=pd(:,:,iteration)/max(max(pd(:,:,iteration)));
    
    X(:,:,iteration,1)=entropyfilt(t1_img,ones(pix,pix));
    X(:,:,iteration,2)=entropyfilt(t2_img,ones(pix,pix));
    X(:,:,iteration,3)=entropyfilt(pd_img,ones(pix,pix));
    
    
    X(:,:,iteration,4)=imgaussfilt(t1(:,:,iteration),sigma);
    X(:,:,iteration,5)=imgaussfilt(t2(:,:,iteration),sigma);
    X(:,:,iteration,6)=imgaussfilt(pd(:,:,iteration),sigma);
    
   
    
end

end

