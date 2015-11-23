function [ labels ] = test( classification_model, model, X_test )

if strcmp(classification_model, 'svm')
    labels = predict(model, X_test);
elseif strcmp(classification_model, 'RF')
    labels_cell = predict(model, X_test);
    labels = zeros(size(X_test, 1), 1);
    for i = 1:length(labels)
        labels(i) = double(labels_cell{i} == '1');
    end
elseif strcmp(classification_model, 'logreg')
    temp = mnrval(model, X_test);
    labels = round(temp(:, 1));
    
else
    disp('INVALID MODEL ENTERED! (predict.m)');
end

end