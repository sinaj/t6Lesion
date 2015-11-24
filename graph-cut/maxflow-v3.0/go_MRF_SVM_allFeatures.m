clear;
clc;


%% ================= Load Sample Data for SVM Model =======================

    clear ALL;
    disp('Loading sample data sets for training...');
    load X40k.mat;
    Y_train = X(:, 157);
    X_train = X(:, 1:156);
    disp('done.'); 
    
%% ===================== SVM Training =====================================

    disp('SVM Training...');
    train_start_time = cputime;
    model = train('svm', X_train, Y_train);
    CompactSVMModel = compact(model);
    CompactSVMModel = fitPosterior(CompactSVMModel,...
        X_train,Y_train);
    fprintf('Time Elapsed Training SVM: %f\n', cputime - train_start_time);
    disp('done.');
    
%% ==================== Load numOfSlices Slices for Testing ==============
    numOfSlices = 20;
    offsetOfSlices = 80;
    numOfFeatures = 156;
    
    fprintf('Loading %d slices for testing...\n',numOfSlices);
    load_test_start_time = cputime;
    [PD,scaninfo] = loadminc('pd_ai_msles2_1mm_pn3_rf20.mnc');
    [T2,scaninfo] = loadminc('t2_ai_msles2_1mm_pn3_rf20.mnc');
    [T1,scaninfo] = loadminc('t1_ai_msles2_1mm_pn3_rf20.mnc');
    [Lesion,scaninfo] = loadminc('phantom_1.0mm_msles2_wml.mnc');
    
    [X_test,Y_test]=extract_slice_features (T1, T2, PD,Lesion,offsetOfSlices);
    
    for i=2:numOfSlices
        [X_testSlice,Y_testSlice]=extract_slice_features (T1, T2, PD,Lesion,i+offsetOfSlices-1);
        X_test(:,:,:,i)=X_testSlice(:,:,:);
        Y_test(:,:,i)=Y_testSlice(:,:);
    
    end
    fprintf('Time Elapsed Loading Slices: %f\n', cputime - load_test_start_time);
    disp('done.');
    
%% ===================== MRF Starts Here ==================================
sigma = 1;

X_test = permute(X_test,[1 2 4 3]);
%size(X_test) = 217 181 numOfSlices 156

%height = 2; width = 2;
[height,width,depth,featureNum] = size(X_test);
disp('building graph ...');
N = height*width*depth;
X_test = reshape(X_test,N,featureNum);

% construct graph
E = edges4connected3Dimage(height,width,depth);
%V = abs(m(E(:,1))-m(E(:,2)))+eps
V = nLinkWeight(X_test,E,sigma);
size(E);
size(V);
A = sparse(E(:,1),E(:,2),V,N,N,4*N);


% terminal weights
% connect source to leftmost column.
% connect rightmost column to target.

[labelsSVM,PostProbs] = predict(CompactSVMModel,X_test);
labelsSVM_no_compact = predict(model,X_test);



linkWeights = zeros(size(PostProbs,1),1);
clusters = zeros(size(PostProbs,1),1);
for i=1:size(PostProbs,1)   
    if(PostProbs(i,1) > PostProbs(i,2))
        linkWeights(i,1)=PostProbs(i,1);
        clusters(i,1)=1;
    else
        linkWeights(i,1)=PostProbs(i,2);
        clusters(i,1)=2;
    end
end

pixels = [1:height*width*depth]';

T = sparse(pixels,clusters,linkWeights);

disp('calculating maximum flow ...');

[flow,labels] = maxflow(A,T);

labels = reshape(labels,[height width depth]);

%% ================= Evaluation Part =======================
disp('Evaluating Results ...');
Y = round(Y_test);
Y(isnan(Y)) = 0;
%Y = reshape(Y,height*width*depth,1);
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


