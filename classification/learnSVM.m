function [ model ] = learnSVM( X, Y )
%LEARNSVM Summary of this function goes here
%   Detailed explanation goes here
model = fitcsvm(X, Y, 'KernelFunction', 'rbf');
%model = compact(SVMModel);

end

