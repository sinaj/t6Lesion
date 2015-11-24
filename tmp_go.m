clear;
clc;
addpath classification
addpath evaluation

load X40kv2.mat;
Y = X(:, 157);
X = X(:, 1:156);
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

X_test = X(ind_test, :);
Y_test = Y(ind_test);

disp('Training...');
train_start_time = cputime;
model = train('RF', X_train, Y_train);
fprintf('Time Elapsed Training: %f\n', cputime - train_start_time);
disp('done.');

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
