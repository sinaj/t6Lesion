n=size(Patch(:,1));
Data_test=[];

for i=1:n
    data=X(Patch(i,1),Patch(i,2),Patch(i,3),:);
    Data_test=[Data_test;data];
end

%code to extract for slices;
 n=size(Z,1);
 data_slices=[];
 for i=1:n
     data_slices=cat(3,data_slices,X(:,:,i,:));
 end