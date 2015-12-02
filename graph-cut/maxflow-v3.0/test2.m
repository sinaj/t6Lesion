% TEST2 Demonstrates gradient-based image
%   min-cut partitioning.
%
%   (c) 2008 Michael Rubinstein, WDI R&D and IDC
%   $Revision: 140 $
%   $Date: 2008-09-15 15:35:01 -0700 (Mon, 15 Sep 2008) $
%

im = imread('waterfall.bmp');


sigma = 1;

m = double(rgb2gray(im));
[height,width] = size(m);
%height = 2; width = 2;

disp('building graph');
N = height*width;
X = reshape(m,N,1);

% construct graph
E = edges4connected(height,width);
%V = abs(m(E(:,1))-m(E(:,2)))+eps
V = nLinkWeight(X,E,sigma);

A = sparse(E(:,1),E(:,2),V,N,N,4*N);



% terminal weights
% connect source to leftmost column.
% connect rightmost column to target.
[ linkWeights,clusters ] = GMMClassifier( X );
%T = sparse([1:height;N-height+1:N]',[ones(height,1);ones(height,1)*2],ones(2*height,1)*9e9);
X_train = [1:height];
for i=1:width-1
    X_train = [X_train;i*height+1:i*height+height];
end
X_train = X_train';
size(X_train);
X_train(1:10,1:10);
clusters(1:10);
linkWeights(1:10);
T = sparse(X_train,clusters,linkWeights);


disp('calculating maximum flow');

[flow,labels] = maxflow(A,T);
labels = reshape(labels,[height width]);

imagesc(labels); title('labels');

