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
    % From PE_3
    m = size(X_test, 1); % Number of training examples

    % You need to return the following variables correctly
    labels = zeros(m, 1);

    h = sigmoid(X_test * model);
    labels = round(h);
elseif strcmp(classification_model, 'NN')
    labels = model(X_test');
    for i=1:length(labels)
        if labels(i) < 0.5
            labels(i) = 0;
        else
            labels(i) = 1;
        end
    end
    labels = labels';    
elseif strcmp(classification_model, 'knn')
    labels = predict(model,X_test);
else
    disp('INVALID MODEL ENTERED! (predict.m)');
end

end
