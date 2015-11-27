clear;
clc;

addpath('../..');
addpath('../../classification');
addpath('../../code_haar_features');
addpath('../../code_haar_features/mex');
addpath('../../code_haar_features/images');
addpath('../../evaluation');
addpath('../../NRRD Reader');

%% ==================== Load numOfSlices Slices for Testing ==============
    numOfSlices = 10;
    offsetOfSlices = 80;
    numOfFeatures = 156;
    SliceWidth = 217;
    sliceHeight = 181;
    
    fprintf('Loading %d slices for testing...\n',numOfSlices);
    load_test_start_time = cputime;
    [PD,scaninfo] = loadminc('pd_ai_msles2_1mm_pn3_rf20.mnc');
    [T2,scaninfo] = loadminc('t2_ai_msles2_1mm_pn3_rf20.mnc');
    [T1,scaninfo] = loadminc('t1_ai_msles2_1mm_pn3_rf20.mnc');
    [Lesion,scaninfo] = loadminc('phantom_1.0mm_msles2_wml.mnc');
    
    f = makeLMfilters;
    
    [X_test,Y_test]=extract_slice_features (T1, T2, PD,Lesion,offsetOfSlices,f);
    
    X_test = reshape(X_test,SliceWidth,sliceHeight,numOfFeatures);
    Y_test = reshape(Y_test,SliceWidth,sliceHeight,1);
    
    for i=2:numOfSlices
        [X_testSlice,Y_testSlice]=extract_slice_features (T1, T2, PD,Lesion,i+offsetOfSlices-1,f);
        
        X_testSlice = reshape(X_testSlice,SliceWidth,sliceHeight,numOfFeatures);
        Y_testSlice = reshape(Y_testSlice,SliceWidth,sliceHeight,1);
        
        X_test(:,:,:,i)=X_testSlice(:,:,:);
        Y_test(:,:,i)=Y_testSlice(:,:);
    
    end
    fprintf('Time Elapsed Loading Slices: %f\n', cputime - load_test_start_time);
    
    disp('done.');
    
%% ================= MRF Starts Here =======================
sigma = 1;

X_test = permute(X_test,[1 2 4 3]);
%size(X_test) = 217 181 numOfSlices 156

[height,width,depth,featureNum] = size(X_test);
disp('building graph');
N = height*width*depth;
X_test = reshape(X_test,N,featureNum);

% construct graph
E = edges4connected3Dimage(height,width,depth);
%V = abs(m(E(:,1))-m(E(:,2)))+eps
V = nLinkWeight(X_test,E,sigma);
size(E);
size(V);
A = sparse(E(:,1),E(:,2),V,N,N);


% terminal weights
% connect source to leftmost column.
% connect rightmost column to target.
[ linkWeights,clusters ] = GMMClassifier( X_test );
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
Y = round(Y_test);
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

slice_labels = double(labels(:,:,1));
slice_ys = double(Y(:,:,1));
slice_ys = cat(3, slice_ys, zeros(size(slice_labels)));

imshow(cat(3, slice_ys, slice_labels));


