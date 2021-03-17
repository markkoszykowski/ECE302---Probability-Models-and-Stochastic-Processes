% Tamar Bacalu, Mark Koszykowski, Henry Son
clc; clear; close all;

%% Scenario 1

% theoretical MSEs
BMMSE = 1/4;
LMMSE = 4/15;

% generating random vectors
N = 1e6;
W = unifrnd(-2, 2, [N 1]);
Y = unifrnd(-1, 1, [N 1]);
X = Y + W;

% bayes
b_y_hat = bmmse(X, Y);
BMMSE(2, 1) = mean((Y - b_y_hat) .^ 2);

% linear
l_y_hat = lmmse(X, Y);
LMMSE(2, 1) = mean((Y - l_y_hat) .^ 2);

Rows = {'Theoretical'; 'Experimental'};

% generate table
sc1_table = table(Rows, LMMSE, BMMSE)

%% Scenario 2

N = 1e6;
N_obs = 20;
N_obs_vect = 2:N_obs;

% parameters 
y_mean = 1;
Y_var = [1, 0.5, 0.1];
R_var = [1, 0.5, 0.1];
Y_sdv = sqrt(Y_var);
R_sdv = sqrt(R_var);
