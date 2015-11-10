function [ labels ] = test( classification_model, model, X_test )

if strcmp(classification_model, 'svm')
    labels = predict(model, X_test);
elseif strcmp(classification_model, 'logreg')
    % From PE_3
    m = size(X_test, 1); % Number of training examples

    % You need to return the following variables correctly
    labels = zeros(m, 1);

    h = sigmoid(X_test * model);
    labels = round(h);
else
    disp('INVALID MODEL ENTERED! (predict.m)');
end

end