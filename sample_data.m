function [ X_train_sample, Y_train_sample, X_test_sample, Y_test_sample ] = sample_data( X_train, Y_train )
%SAMPLE_DATA Summary of this function goes here
%   Detailed explanation goes here


starting_slice = 100;
ending_slice = 100;

X_train_sample = double(X_train(217*181*starting_slice+181*100+1 : 217*181*ending_slice+181*130, :));
Y_train_sample = double(Y_train(217*181*starting_slice+181*100+1 : 217*181*ending_slice+181*130, :));
X_test_sample = double(X_train(217*181*starting_slice+181*131+1 : 217*181*ending_slice+181*200, :));
Y_test_sample = double(Y_train(217*181*starting_slice+181*131+1 : 217*181*ending_slice+181*200, :));

end

