function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

j = length(theta);
% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta

h = sigmoid(X * theta);
% eliminate theta0
theta1 = (horzcat(zeros(j-1,1), eye(j-1))) * theta;
J = (log(h)' * (-y) - (log(1 .- h))' * (1 .- y) )/m  + ((theta1' * theta1) * lambda / (2 * m));

X0 = X(:,1);
grad0 = (X0' * (h - y))/m;
X1 = X * (vertcat(zeros(1,j-1),eye(j-1)));
grad1 = (X1' * (h - y))/m + (theta1 * lambda / m);

grad = vertcat(grad0,grad1);
% =============================================================

end
