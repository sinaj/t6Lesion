function [ model ] = learnLogisticReg( X, Y )

% In the assignment, we did  cross-val to find the best lambda. I'll leave
% that out for now.

% Initialize fitting parameters
initial_theta = zeros(size(X, 2), 1);

% Set Options
options = optimset('GradObj', 'on', 'MaxIter', 400);

% Optimize
[theta, ~, ~] = ...
fminunc(@(t)(costFunction(t, X, y, lambda)), initial_theta, options);

model = theta;
end

function [x] = costFunction(theta, X, y, lambda)
h = sigmoid(X * theta);
newTheta = theta;
newTheta(1) = 0;

J = (1/m) * sum(-y .* log(h) - (1 - y) .* log(1 - h)) + ...
    (lambda / (2*m) * sum(newTheta .^ 2));

grad = (1/m) * ((X' * (h - y)) + lambda * newTheta);
end