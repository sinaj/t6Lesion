clear;
clc;

addpath('../..');
addpath('../../classification');
addpath('../../code_haar_features');
addpath('../../code_haar_features/mex');
addpath('../../code_haar_features/images');
addpath('../../evaluation');
addpath('../../NRRD Reader');

%% ================= Load Sample Data for RF Model =======================

    clear ALL;
    disp('Loading sample data sets for training...');
    load brain_web_entropy.mat;
    [X_ind, Y] = extract_patches(data);
    X = data(X_ind(:, 1), 1:6);
    
    
%     load X40kv2.mat;
%     Y = data(:, end);
%     X = X(:, 1:156);
    disp('done.'); 
    
%% ===================== RF Training =====================================
    
    pos_ind = Y == 1;
    neg_ind = Y == 0;

    train_size = 24000;

    pos_ind_train = [ones(train_size, 1); zeros(length(Y)-train_size, 1)] .* pos_ind;
    pos_ind_test = [zeros(train_size, 1); ones(length(Y)-train_size, 1)] .* pos_ind;

    neg_ind_train = [ones(train_size, 1); zeros(length(Y)-train_size, 1)] .* neg_ind;
    neg_ind_test = [zeros(train_size, 1); ones(length(Y)-train_size, 1)] .* neg_ind;

    ind_train = logical(pos_ind_train) | logical(neg_ind_train);
    ind_test = logical(pos_ind_test) | logical(neg_ind_test);

    X_train = X(ind_train, :);
    Y_train = Y(ind_train);

    X_test_sina = X(ind_test, :);
    Y_test_sina = Y(ind_test);

    disp('RF Training...');
    train_start_time = cputime;

    model = train('RF', X, Y);
    
    fprintf('Time Elapsed Training RF: %f\n', cputime - train_start_time);
    disp('done.');
    
%% ==================== Load numOfSlices Slices for Testing ==============
    
    numOfSlices = 3;
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
    
%     [X_test,Y_test]=extract_slice_features (T1, T2, PD,Lesion,offsetOfSlices,f);
    re = reshape(data, 217, 181, 181, 7);
    test = re(:, :, offsetOfSlices:offsetOfSlices+numOfSlices, :);
    X_test = test(:, :, :, 1:6);
    Y_test = test(:, :, :, end);
    if 1 > 2
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
    end
    
%% ===================== MRF Starts Here ==================================
sigma = 1;

% X_test = permute(X_test,[1 2 4 3]);
%size(X_test) = 217 181 numOfSlices 156


[height,width,depth,featureNum] = size(X_test);
disp('building graph ...');
N = height*width*depth;
X_test = reshape(X_test,N,featureNum);

% construct graph
E = edges4connected3Dimage(height,width,depth);
%V = abs(m(E(:,1))-m(E(:,2)))+eps
V = nLinkWeight(X_test,E,sigma);
V = V - min(V);
V = V / max(V);
A = sparse(E(:,1),E(:,2),V,N,N);

% terminal weights
% connect source to leftmost column.
% connect rightmost column to target.
labelsSina = ddd('RF', model, X_test);

[labelsCell,Scores] = predict(model,X_test);

labelsRF = zeros(size(labelsCell, 1), 1);
for i = 1:length(labelsRF)
    labelsRF(i) = (labelsCell{i} == '1');
end

linkWeights = zeros(size(Scores,1),1);
clusters = zeros(size(Scores,1),1);

for i=1:size(Scores,1)
    [x,y,z] = ind2sub([height,width,depth], i);
    if Scores(i, 1) > 0.5
        linkWeights(i) = Scores(i, 1);
        clusters(i) = 1;
    else
        linkWeights(i) = Scores(i, 2);
        clusters(i) = 2;
    end
end

pixels = [1:height*width*depth]';
% linkWeights = max(Scores, [], 2);

T = sparse(pixels,clusters,linkWeights);


disp('calculating maximum flow ...');

[flow,labels] = maxflow(A,T);

labels = reshape(labels,[height width depth]);

%% ================= Evaluation Part =======================
disp('Evaluating Results ...');
Y = round(Y_test);
Y(isnan(Y)) = 0;
%Y = reshape(Y,height*width*depth,1);
RFDcs = evaluate(double(Y), double(reshape(labelsRF, size(Y))), 'dsc');
[dcs] = evaluate(double(Y), double(labels), 'dsc');
[sensitivity] = evaluate(double(Y), double(labels), 'sensitivity');
[specificity] = evaluate(double(Y), double(labels), 'specificity');
[accuracy] = evaluate(double(Y), double(labels), 'accuracy');
[detections] = evaluate(double(Y), double(labels), 'detections');
fprintf('Dice Similariity Coefficient is %f (RF)\n', RFDcs);
fprintf('Dice Similarity Coefficient is %f \n',dcs);
fprintf('Sensitivity is %f \n',sensitivity);
fprintf('Specificity is %f \n',specificity);
fprintf('Accuracy is %f \n',accuracy);
fprintf('Detections is %f \n',detections);


slice_labels = double(labels(:,:,1));
slice_ys = double(Y(:,:,1));
slice_ys = cat(3, slice_ys, zeros(size(slice_labels)));

imshow(cat(3, slice_ys, slice_labels));


