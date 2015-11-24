clear;
clc;

addpath('../..');
addpath('../../evaluation');

%% ================= Extract featrues from the data =======================

    clear ALL;
    disp('Loading data sets...');
    [X, Y] = get_trainData();
    disp('done.'); 
    size(X)
    size(Y)

%% ===================== MRF Starts Here ==================================
sigma = 1;


X_train = reshape(X,217,181,181,4);
%height = 2; width = 2;
[height,width,depth,featureNum] = size(X_train);
disp('building graph ...');
N = height*width*depth;
X_train = reshape(X_train,N,featureNum);

% construct graph
E = edges4connected3Dimage(height,width,depth);
%V = abs(m(E(:,1))-m(E(:,2)))+eps
V = nLinkWeight(X_train,E,sigma);
size(E);
size(V);
A = sparse(E(:,1),E(:,2),V,N,N,4*N);


% terminal weights
% connect source to leftmost column.
% connect rightmost column to target.
y = round(Y);
y(isnan(y)) = 0;
y = reshape(y,N,1);
y=categorical(y);
y=double(y);
minY = min(y)
maxY = max(y)
disp('Starting Logistic Regression ...');
theta = mnrfit(X_train,y);
prob = mnrval(theta,X_train);
myClusters = max(prob);
myClusters
disp('Logistic Regression Ends ...');

linkWeights = zeros(size(prob,1),1);
clusters = zeros(size(prob,1),1);
for i=1:size(prob,1)   
    if(prob(i,1) > prob(i,2))
        linkWeights(i,1)=prob(i,1);
        clusters(i,1)=1;
    else
        linkWeights(i,1)=prob(i,2);
        clusters(i,1)=2;
    end
end

pixels = [1:height*width*depth]';

sizePixels = size(pixels)
sizeCluster = size(clusters)
sizeLinkWeights = size(linkWeights)
minCluster = min(clusters)
maxCluster = max(clusters)
T = sparse(pixels,clusters,linkWeights);
sizeT = size(T)


disp('calculating maximum flow ...');

[flow,labels] = maxflow(A,T);

labels = reshape(labels,[height width depth]);

%% ================= Evaluation Part =======================
disp('Evaluating Results ...');
Y = round(Y);
Y(isnan(Y)) = 0;
[dcs] = evaluate(double(Y), double(labels), 'dsc');
[sensitivity] = evaluate(double(Y), double(labels), 'sensitivity');
[specificity] = evaluate(double(Y), double(labels), 'specificity');
[accuracy] = evaluate(double(Y), double(labels), 'accuracy');
[detections] = evaluate(double(Y), double(labels), 'detections');
fprintf('Dice Similarity Coefficient is %f \n',dcs);
fprintf('Sensitivity is %f \n',sensitivity);
fprintf('Specificity is %f \n',specificity);
fprintf('Accuracy is %f \n',accuracy);
fprintf('Detections is %f \n',detections);


