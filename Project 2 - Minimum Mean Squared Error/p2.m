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

% params
N = 1e6;
N_obs = 20;
obs = 1:1:N_obs;
Y_var = [.5, .75, .75];
R_var = [1, .75, .5];

% theoretical MSEs
MMSE1 = (Y_var(1) .* R_var(1)) ./ (obs .* Y_var(1) + R_var(1));
MMSE2 = (Y_var(2) .* R_var(2)) ./ (obs .* Y_var(2) + R_var(2));
MMSE3 = (Y_var(3) .* R_var(3)) ./ (obs .* Y_var(3) + R_var(3));

for n = obs
    % generating random vectors
    Y1 = normrnd(1, sqrt(Y_var(1)), [N 1]);
    R1 = normrnd(0, sqrt(R_var(1)), [N n]);
    X1 = zeros(N, n);
    for i = 1:n
        X1(:, i) = R1(:, i) + Y1;
    end

    Y2 = normrnd(1, sqrt(Y_var(2)), [N 1]);
    R2 = normrnd(0, sqrt(R_var(2)), [N n]);
    X2 = zeros(N, n);
    for i = 1:n
        X2(:, i) = R2(:, i) + Y2;
    end

    Y3 = normrnd(1, sqrt(Y_var(3)), [N 1]);
    R3 = normrnd(0, sqrt(R_var(3)), [N n]);
    X3 = zeros(N, n);
    for i = 1:n
        X3(:, i) = R3(:, i) + Y3;
    end

    % calculate errors
    y1_hat = mmmse(X1, Y1);
    MMSE1(2, n) = mean((Y1 - y1_hat) .^ 2);

    y2_hat = mmmse(X2, Y2);
    MMSE2(2, n) = mean((Y2 - y2_hat) .^ 2);

    y3_hat = mmmse(X3, Y3);
    MMSE3(2, n) = mean((Y3 - y3_hat) .^ 2);
end

% generate plot
figure;
plot(obs, MMSE1(1, :), '-', ...
    obs, MMSE1(2, :), 'x', ...
    obs, MMSE2(1, :), '-', ...
    obs, MMSE2(2, :), 'x', ...
    obs, MMSE3(1, :), '-', ...
    obs, MMSE3(2, :), 'x');
title("Theoretical and Experimental MSE vs. Number of Observations");
xlabel("Number of Observations");
ylabel("MSE");
legend("Theoretical: \sigma_{\it Y}^2 = " + Y_var(1) + ", \sigma_{\it R}^2 = " + R_var(1), ...
    "Experimental: \sigma_{\it Y}^2 = " + Y_var(1) + ", \sigma_{\it R}^2 = " + R_var(1), ...
    "Theoretical: \sigma_{\it Y}^2 = " + Y_var(2) + ", \sigma_{\it R}^2 = " + R_var(2), ...
    "Experimental: \sigma_{\it Y}^2 = " + Y_var(2) + ", \sigma_{\it R}^2 = " + R_var(2), ...
    "Theoretical: \sigma_{\it Y}^2 = " + Y_var(3) + ", \sigma_{\it R}^2 = " + R_var(3), ...
    "Experimental: \sigma_{\it Y}^2 = " + Y_var(3) + ", \sigma_{\it R}^2 = " + R_var(3));