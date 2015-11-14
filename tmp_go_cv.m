clear;
clc;
addpath classification
addpath evaluation

load X40k.mat;
data = X;
data = data(randperm(size(data, 1)), :);

used_model = 'RF';

pos_data = data(data(:, end) == 1, :);
neg_data = data(data(:, end) == 0, :);

folds = 5;

acc_vec = [];
dsc_vec = [];
sen_vec = [];
spc_vec = [];
det_vec = [];

for k = 1:folds
    [X_train, Y_train, X_test, Y_test] = generateFold(pos_data, neg_data, k, folds);
    fprintf('Training (fold = %d)... ', k);
    train_start_time = cputime;
    model = train(used_model, X_train, Y_train);
    fprintf('time elapsed: %f\n', cputime - train_start_time);
    labels = test(used_model, model, X_test);
    acc_vec = [acc_vec; evaluate(Y_test, labels, 'accuracy')];
    dsc_vec = [dsc_vec; evaluate(Y_test, labels, 'dsc')];
    sen_vec = [sen_vec; evaluate(Y_test, labels, 'sensitivity')];
    spc_vec = [spc_vec; evaluate(Y_test, labels, 'specificity')];
    det_vec = [det_vec; evaluate(Y_test, labels, 'detections')];
end

hist(dsc_vec);
fprintf('Dice Score values:\n');
disp(dsc_vec);
fprintf('Mean dice score: %f\n', mean(dsc_vec));