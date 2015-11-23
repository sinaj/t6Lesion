function [ model ] = learnLogisticReg( X, Y )

%catArray = categorical(Y + 1);

X_norm = normc(X);

% This can spit out a warning about the matrix being singular. I think this
% is to do with our class sizes. We don't have very many positives.
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/171400
model = mnrfit(X_norm, Y + 1);

end
