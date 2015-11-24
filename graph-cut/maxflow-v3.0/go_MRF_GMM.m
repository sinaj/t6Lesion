clear;
clc;
% X should be n*m*f which f is the feature space
addpath('../..');
addpath('../../evaluation');

%% ================= Extract featrues from the data =======================

    clear ALL;
    disp('Loading data sets...');
    [X, Y] = get_trainData();
    disp('done.');
%% ================= MRF Starts Here =======================
sigma = 1;


X = reshape(X,217,181,181,4);
X_train=X;
%height = 2; width = 2;
[height,width,depth,featureNum] = size(X_train);
disp('building graph');
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
[ linkWeights,clusters ] = GMMClassifier( X_train );
pixels = [1:height*width*depth]';

size(pixels);
size(clusters);
size(linkWeights);
T = sparse(pixels,clusters,linkWeights);



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


