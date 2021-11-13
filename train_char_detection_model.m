
clear ; close all; clc

input_layer_size  = 1600;  % 34x70 Input Images of Digits
hidden_layer_size_1 = 200;   % 500 hidden units
hidden_layer_size_2 = 500;   % 500 hidden units
num_labels = 2;

fprintf('Loading Data ...\n')

load('plates_positive_features_labels.mat');
load('plates_negative_features_labels_parti.mat');
load('plates_negative_features_labels_part2.mat');

full_data = [X_positive y_positive; X_negative_1 y_negative_1; X_negative_2 y_negative_2];

sel = randperm(size(full_data, 1));
train_data = full_data(sel(1:10000), :);
test_data = full_data(sel(10001:20000), :);

X_train = train_data(:, 1:1600);
y_train = train_data(:, 1601);
X_test = test_data(:, 1:1600);
y_test = test_data(:, 1601);

save('plates_tiny_features_labels.mat', 'X_train', 'y_train', 'X_test', 'y_test');

%load('plates_tiny_features_labels.mat');

epsilon = 0.12;
theta1 = rand(hidden_layer_size_1, 1+input_layer_size) * 2 * epsilon - epsilon;
theta2 = rand(hidden_layer_size_2, 1+hidden_layer_size_1) * 2 * epsilon - epsilon;
theta3 = rand(num_labels, 1+hidden_layer_size_2) * 2 * epsilon - epsilon;

initial_nn_params = [theta1(:) ; theta2(:) ; theta3(:)];

%%%%%% -------------------------------------------------------- %%%%%%

fprintf('\nTraining Neural Network... \n')

options = optimset('MaxIter', 50);

lambda = 1;

costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size_1, ...
                                   hidden_layer_size_2, ...
                                   num_labels, X_train, y_train, lambda);

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params

Theta1_size = hidden_layer_size_1 * (input_layer_size + 1);
Theta2_size = hidden_layer_size_2 * (hidden_layer_size_1 + 1);
Theta3_size = num_labels * (hidden_layer_size_2 + 1);

Theta1 = reshape(nn_params(1:Theta1_size), ...
                 hidden_layer_size_1, (input_layer_size + 1));
             
Theta2 = reshape(nn_params(1 + Theta1_size : Theta1_size + Theta2_size), ...
                 hidden_layer_size_2, (hidden_layer_size_1 + 1));

Theta3 = reshape(nn_params((1 + Theta1_size + Theta2_size):end), ...
                 num_labels, (hidden_layer_size_2 + 1));
             
save('final_weights.mat', 'Theta1', 'Theta2', 'Theta3');

%%%%%% ------------------------------------------------------------ %%%%%%


pred = predict(Theta1, Theta2, Theta3, X_test);
fprintf('\nTesting Set Accuracy: %f\n', mean(double(pred == y_test)) * 100);



