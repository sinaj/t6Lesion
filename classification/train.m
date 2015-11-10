function [ model ] = train( classification_model, X, Y )

if strcmp(classification_model, 'svm')
    model = learnSVM(X, Y);
elseif strcmp(classification_model, 'RF')
    model = learnRandomForest(X, Y);
else
    disp('INVALID MODEL ENTERED! (train.m)');
    model = [];
end

end
