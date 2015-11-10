function [ model ] = learnLogisticReg( X, Y )

% In the assignment, we did  cross-val to find the best lambda. I'll leave
% that out for now.
lambda = 0.3;

% I'm guessing there is a better way to find the best value of this:

% Initialize fitting parameters
initial_theta = zeros(size(X, 2), 1);
% Set Options
options = optimset('GradObj', 'on', 'MaxIter', 400);

% Optimize
[theta, ~, ~] = ...
fminunc(@(t)(costFunction(t, X, Y, lambda)), initial_theta, options);

model = theta;
end

function [J, grad] = costFunction(theta, X, y, lambda)

m = length(y); % number of training examples

% Return these
J = 0;
grad = zeros(size(theta));

h = sigmoid(X * theta);
newTheta = theta;
newTheta(1) = 0;

J = (1/m) * sum(-y .* log(h) - (1 - y) .* log(1 - h)) + ...
    (lambda / (2*m) * sum(newTheta .^ 2));

grad = (1/m) * ((X' * (h - y)) + lambda * newTheta);
end

