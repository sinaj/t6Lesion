n=size(Patch(:,1));
Data_test=[];

for i=1:n
    data=X(Patch(i,1),Patch(i,2),Patch(i,3),:);
    Data_test=[Data_test;data];
end