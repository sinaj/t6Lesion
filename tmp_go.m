% clear;
% clc;
addpath classification
addpath evaluation
addpath code_haar_features

!synclient HorizEdgeScroll=0 HorizTwoFingerScroll=0
warning off;

load X40kv2;
% load brain_web_entropy.mat;
% load Patch40k.mat;
% X = data(:, 1:size(data, 2)-1);
% Y = data(:, end);
Y = X(:, 157);
X = X(:, 1:156);
dataset = 'brainWeb';
model_name = 'RF';
test_slice_num = 1;

% train_ind = sub2ind([217, 181, 181], subs(:, 1), subs(:, 2), subs(:, 3));
% 
% X_train = X(train_ind, :);
% Y_train = Y(train_ind);
X_train = X;
Y_train = Y;

Y_train(isnan(Y_train)) = 0;

disp('Training...');
train_start_time = cputime;
model = train(model_name, X_train, Y_train);
fprintf('Time Elapsed Training: %f\n', cputime - train_start_time);
disp('done.');

[X_test, Y_test] = loadData(dataset, 91:(91+test_slice_num-1));
% X_test = X(217*181*91+1:217*181*92, :);
% Y_test = Y(217*181*91+1:217*181*92);


disp('Testing...');
test_start_time = cputime;
labels = test(model_name, model, X_test);
fprintf('Time Elapsed Testing: %f\n', cputime - test_start_time);
disp('done.');

% Evaluate the result
disp('Evaluating...');
fprintf('ACC: %f\n', evaluate(Y_test, labels, 'accuracy'));
fprintf('DSC: %f\n', evaluate(Y_test, labels, 'dsc'));
fprintf('Sen: %f\n', evaluate(Y_test, labels, 'sensitivity'));
fprintf('Spe: %f\n', evaluate(Y_test, labels, 'specificity'));
fprintf('det: %f\n', evaluate(Y_test, labels, 'detections'));

slice_labels = reshape(labels, 217, 181, test_slice_num);
slice_labels = slice_labels(:, :, 1);
slice_ys = reshape(Y_test, 217, 181, test_slice_num);
slice_ys = cat(3, slice_ys(:, :, 1), zeros(size(slice_labels)));

disp('Preparing visual result...');
imshow(cat(3, slice_labels, slice_ys));
disp('done.');



