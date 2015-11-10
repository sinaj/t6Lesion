function [ labels ] = test( classification_model, model, X_test )

if strcmp(classification_model, 'svm')
    labels = predict(model, X_test);
elseif strcmp(classification_model, 'logreg')
    labels = predict(model, X_test);
else
    disp('INVALID MODEL ENTERED! (predict.m)');
end

end

