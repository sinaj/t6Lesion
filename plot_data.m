function plot_data( X, Y )
%PLOT_DATA Summary of this function goes here
%   Detailed explanation goes here

ind = find(Y == 1);
X_1 = X(ind, :);
ind2 = find(Y == 0);
X_0 = X(ind2, :);

plot(X_0(:, 1), X_0(:, 2), 'r.');
%scatter3(X_0(:, 1), X_0(:, 2), X_0(:, 4), 'r.');
hold;
plot(X_1(:, 1), X_1(:, 2), 'b+');
%scatter3(X_1(:, 1), X_1(:, 2), X_1(:, 4), 'Bx');
axis auto;

end

