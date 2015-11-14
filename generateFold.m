function [ x_train, y_train, x_test, y_test ] = generateFold( pos, neg, k, folds )

pos_num = length(pos);
neg_num = length(neg);

pos_fold_size = floor(pos_num / folds);
neg_fold_size = floor(neg_num / folds);


pos_test = pos((k-1) * pos_fold_size + 1 : k * pos_fold_size, :);
neg_test = neg((k-1) * neg_fold_size + 1: k * neg_fold_size, :);

test = cat(1, pos_test, neg_test);
y_test = test(:, end);
x_test = test(:, 1:size(test, 2)-1);

pos((k-1) * pos_fold_size + 1 : k * pos_fold_size, :) = [];
neg((k-1) * neg_fold_size + 1: k * neg_fold_size, :) = [];

train = cat(1, pos, neg);
y_train = train(:, end);
x_train = train(:, 1:size(train, 2)-1);

end

