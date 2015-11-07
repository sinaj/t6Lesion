function [ model ] = train( classification_model, X, Y )

if strcmp(classification_model, 'svm')
    model = learnSVM(X, Y);
else
    disp('INVALID MODEL ENTERED! (train.m)');
    model = [];
end

end

