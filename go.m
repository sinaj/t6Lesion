
clc;
addpath classification
addpath evaluation

force_refresh_data = false;
training_model = 'svm';

%% ================= Extract featrues from the data =======================

if force_refresh_data || ~exist('X', 'var')
    clear ALL;
    disp('Loading data sets...');
    [X, Y] = get_trainData();
    disp('done.');
end

%% ============= Do the classification and train the model ================
% Coverting format for Classification
X_train = reshape(X, size(X, 1) * size(X, 2), size(X, 3));
Y_train = round(Y(:));
Y_train(isnan(Y_train)) = 0;

% Get some two exclusive samples from the data as train and test
[X_train_sample, Y_train_sample, X_test_sample, Y_test_sample] = sample_data(X_train, Y_train);

% Plot the data
plot_data(X_train_sample, Y_train_sample);

% Train the model using the sample data
disp('Training...');
train_start_time = cputime;
model = train(training_model, X_train_sample, Y_train_sample);
fprintf('Time Elapsed Training: %f\n', cputime - train_start_time);
disp('done.');

%% ============= Test the model on the test set and evaluate ==============
% Test the model using sample tests
disp('Testing...');
test_start_time = cputime;
labels = test(training_model, model, X_test_sample);
fprintf('Time Elapsed Testing: %f\n', cputime - test_start_time);
disp('done.');

% Evaluate the result
disp('Evaluating...');
fprintf('Acc: %.4f\n', evaluate(Y_test_sample, labels, 'accuracy'));


