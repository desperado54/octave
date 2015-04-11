function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost and gradient of regularized linear 
%               regression for a particular choice of theta.
%
%               You should set J to the cost and grad to the gradient.
%


h = X * theta;

theta(1) = 0;

J = (h - y)' * (h - y) ./(2*m) + (theta' * theta) .* lambda /(2 * m);

%grad = X' * (h - y) + (theta * lambda) / m);

j = length(theta);
X0 = X(:,1);
grad0 = (X0' * (h - y))/m;
X1 = X * (vertcat(zeros(1,j-1),eye(j-1)));
grad1 = (X1' * (h - y))/m + (theta([2:j],:) * lambda / m);

grad = vertcat(grad0,grad1);

% =========================================================================

grad = grad(:);

end
