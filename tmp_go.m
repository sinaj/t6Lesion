clear;
clc;
addpath classification
addpath evaluation
addpath code_haar_features

!synclient HorizEdgeScroll=0 HorizTwoFingerScroll=0
warning off;

load X40kv2.mat;
Y = X(:, 157);
X = X(:, 1:156);
dataset = 'brainWeb';
test_slice_num = 1;

% pos_ind = Y == 1;
% neg_ind = Y == 0;
% 
% train_size = 24000;
% 
% pos_ind_train = [ones(train_size, 1); zeros(length(Y)-train_size, 1)] .* pos_ind;
% pos_ind_test = [zeros(train_size, 1); ones(length(Y)-train_size, 1)] .* pos_ind;
% 
% neg_ind_train = [ones(train_size, 1); zeros(length(Y)-train_size, 1)] .* neg_ind;
% neg_ind_test = [zeros(train_size, 1); ones(length(Y)-train_size, 1)] .* neg_ind;
% 
% ind_train = logical(pos_ind_train) | logical(neg_ind_train);
% ind_test = logical(pos_ind_test) | logical(neg_ind_test);
% 
% X_train = X(ind_train, :);
% Y_train = Y(ind_train);
% 
% X_test = X(ind_test, :);
% Y_test = Y(ind_test);

X_train = X;
Y_train = Y;

disp('Training...');
train_start_time = cputime;
model = train('RF', X_train, Y_train);
fprintf('Time Elapsed Training: %f\n', cputime - train_start_time);
disp('done.');

[X_test, Y_test] = loadData(dataset, 91:(91+test_slice_num-1));

disp('Testing...');
test_start_time = cputime;
labels = test('RF', model, X_test);
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

imshow(cat(3, slice_labels, slice_ys));



