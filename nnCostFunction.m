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

% fprintf('\nJoe test nn nn_p ... %d \n', size(nn_params));
% fprintf('\nJoe test nn in ... %d \n', input_layer_size);
% fprintf('\nJoe test nn hi ... %d \n', hidden_layer_size);
% fprintf('\nJoe test nn num ... %d \n', num_labels);
% fprintf('\nJoe test nn X... %f \n', size(X));
% fprintf('\nJoe test nn y... %f \n', size(y));
% fprintf('\nJoe test nn lam... %f \n', lambda);

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));


% fprintf('\nJoe test nn Theta1... %f \n', size(Theta1));
% fprintf('\nJoe test nn reshape... %d %d %d\n', 
 %  1 + hidden_layer_size*(input_layer_size+1),
  % num_labels,
  % hidden_layer_size +1);
Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));
% fprintf('\nJoe test nn Theta2... %f \n', size(Theta2));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
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
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Part 1
a1 = [ones(m,1) X];
z2 = (a1*Theta1');
a2 = [ones(size(z2,1),1) sigmoid(z2)];
a3 = sigmoid(a2*Theta2');
h = a3;

M_y = eye(num_labels)(y,:);
# J = (-sum(sum(M_y.*log(h))) - sum(sum(1-M_y).*log(1-h)))/m;
J = (-sum(sum(M_y.*log(h))) - sum(sum((1-M_y).*(log(1-h)))))/m;

reg = lambda*((sum(sum(Theta1(:,2:end).^2))) + ... 
              sum(sum(Theta2(:,2:end).^2)))/(2*m);
J += reg;

% Part 2:
d3 = a3 - M_y;
g2 = sigmoidGradient(z2);
d2 = (d3*Theta2).*[ones(size(z2,1),1) g2];

del1 = d2(:,2:end)'*a1;
del2 = d3'*a2;
Theta1_grad += del1/m;
Theta2_grad += del2/m;

% Part 3
greg1 = Theta1(:,2:end)*(lambda/m);
greg2 = Theta2(:,2:end)*(lambda/m);
Theta1_grad(:,2:end) += greg1;
Theta2_grad(:,2:end) += greg2;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
