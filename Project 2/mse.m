% Mark, Tamar, Henry
clear; close all; clc;

%% Scenario 1
% linear estimator x/5
l_est = @(x) x / 5;
% bayes estimator
b_est = @(x) (1 + x) / 2 .* (x < -1) + ...
             0 .* and(x >= -1, x < 1) + ...
             (-1 + x) / 2 .* (x >= 1);

% theoretical MSEs
BMMSE = 1/4;
LMMSE = 4/15;

% generating random vectors
N = 10e6;
W = -2 + 4 * rand(N, 1, 'double');
Y = -1 + 2 * rand(N, 1, 'double');
X = Y + W;

% linear
l_y_hat = l_est(X);
LMMSE(2) = mean((Y - l_y_hat) .^ 2);

% bayes
b_y_hat = b_est(X);
BMMSE(2) = mean((Y - y_hat) .^ 2);

% generate table
sc1_table = table(BMMSE(:), LMMSE(:), ...
            'RowNames', {'Theoretical'; 'Results'}, ...
            'VariableTypes', {'Bayes_MMSE', 'Linear_MMSE'});

%% Scenario 2
N = 10e6;
N_obs = 20;
N_obs_vect = 2:N_obs;

% parameters 
y_mean = 1;
Y_var = [1, 0.5, 0.1];
R_var = [1, 0.5, 0.1];
Y_sdv = sqrt(Y_var);
R_sdv = sqrt(R_var);
