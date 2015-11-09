function [ nLinkWeight ] = nLinkWeight( X,edges,sigma )
% X is n*m (n:nmber of samples, m:number of features)
% edges is something*2 (it is all the edges that should be between
% neighbours)
for i=1:size(edges,1)
    nLinkWeight(i,1) = sum(exp(-((X(edges(i,1),:) - X(edges(i,2),:))'.^2)/(2*sigma^2)));
end
    %nLinkWeight = (exp(-((X(edges(:,1),:) - X(edges(:,2),:))'.^2)/(2*sigma^2)));
end

