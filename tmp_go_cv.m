clear;
clc;
[T1,T2,Flair,Lesion] = load_data('brainWeb');
addpath classification
addpath evaluation
load X40kv2.mat;
data = X;
X_train = X(:,1:156);
Y_train = X(:,157);
filt = makeLMfilters;
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
    %[X_train, Y_train, X_test, Y_test] = generateFold(pos_data, neg_data, k, folds);
    [Xt,Yt] = extract_slice_features (T1, T2, Flair,Lesion,90,filt);
    Xt=cat(3,Xt,Yt);
    Xt = reshape(Xt,[size(T1,1)*size(T1,2),size(Xt,3)]);
    X_test = Xt(:,1:156);
    Y_test = Xt(:,157);
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