function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m

labels = [1 : num_labels];
X = [ones(m,1) X];

J = 0;
for i = 1:m
  a1 = X(i,:);
  a2 = sigmoid(a1 * Theta1');
  m2 = size(a2, 1);
  a2 = [ones(m2, 1) a2];
  a3 = sigmoid(a2 * Theta2');
  yy = y(i) == labels;
  J += (log(a3) * (-yy)' - (log(1 .- a3)) * (1 .- yy)');

endfor

n = size(Theta1, 2);
t1 = Theta1(:, [2 : n]); 	 % remmove index 1
d1 = ones(1, size(t1,1)) * (t1 .* t1) * ones(size(t1,2), 1);

n = size(Theta2, 2);
t2 = Theta2(:, [2 : n]);
d2 = ones(1, size(t2,1)) * (t2 .* t2) * ones(size(t2,2), 1);


J = (J / m + lambda * (d1 + d2) / (2 * m) );

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.

Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));
for i = 1:m
  a1 = X(i, :)';
  z2 = Theta1 * a1;
  a2 = sigmoid(z2);    % 25 x 1
  a2 = [1;a2];                  % 26 x 1
  z3 = Theta2 * a2;
  a3 = sigmoid(z3);    % 10 x 1

  yy = y(i) == labels;
  d3 = a3 - yy';

  d2 = (Theta2(:,[2:end])' * d3) .* sigmoidGradient(z2);   % 25 x 1

  Theta2_grad += d3 * a2';
  Theta1_grad += d2 * a1';

endfor

Theta2_grad = Theta2_grad / m;
Theta1_grad = Theta1_grad / m;

% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

coef2 = eye(size(Theta2,2));
coef2(1,1) = 0;
Theta2_grad += lambda .* Theta2 * coef2 / m;

coef1 = eye(size(Theta1,2));
coef1(1,1) = 0;
Theta1_grad += lambda .* Theta1 * coef1 / m;



















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
