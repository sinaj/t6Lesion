    function [ X, Y ] = loadData( dataset, sliceNums )

[T1, T2, Flair, lesion] = load_data(dataset);

[X, Y] = extract_slice_features(T1, T2, Flair, lesion, sliceNums);
% X = reshape(X, size(X, 1)*size(X, 2), size(X, 3));
Y = round(Y(:));
X = normalize(X);



end

