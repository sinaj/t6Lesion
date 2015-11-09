function [ linkWeights,clusters ] = GMMClassifier( X )

%gaussianProbabilities is a vector of size: num_of_sampels by 2
% because we are clustering with k=2 (lession or not lession)
%X = imread('waterfall.bmp');
%m = double(rgb2gray(X));
%X = m(:);

obj = gmdistribution.fit(X,2,'Regularize',1e-5);

gaussianProbabilities = posterior(obj,X);

clusters = cluster(obj,X);
linkWeights = zeros(size(gaussianProbabilities,1),1);
for i=1:size(gaussianProbabilities,1)
    linkWeights(i,1)=max(gaussianProbabilities(i,:));
end

end

