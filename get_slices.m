function [Z] = get_slices(Y)
%This function takes the Y value, and gets the Z of each slices which has
%lesions.

% only for brain web data, coment for macci data

 Y(isnan(Y))=0;
 Y=round(Y);
 
 % general for all data
 prob=find(Y==1);
 n=size(prob,1);
 Z=[];
 for i=1:n
     [x,y,z]=ind2sub(size(Y),prob(i));
     Z=[Z;z];
 end
 
Z=unique(Z);
end

