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
Y_var = [.5, .75, .75];
R_var = [1, .75, .5];

% theoretical MSEs
MMSE1 = (Y_var(1) * R_var(1)) / (N_obs * Y_var(1) + R_var(1));
MMSE2 = (Y_var(2) * R_var(2)) / (N_obs * Y_var(2) + R_var(2));
MMSE3 = (Y_var(3) * R_var(3)) / (N_obs * Y_var(3) + R_var(3));

% generating random vectors
Y1 = normrnd(1, sqrt(Y_var(1)), [N 1]);
R1 = normrnd(0, sqrt(R_var(1)), [N N_obs]);
X1 = zeros(N, N_obs);
for i = 1:N_obs
    X1(:, i) = R1(:, i) + Y1;
end

Y2 = normrnd(1, sqrt(Y_var(2)), [N 1]);
R2 = normrnd(0, sqrt(R_var(2)), [N N_obs]);
X2 = zeros(N, N_obs);
for i = 1:N_obs
    X2(:, i) = R2(:, i) + Y2;
end

Y3 = normrnd(1, sqrt(Y_var(3)), [N 1]);
R3 = normrnd(0, sqrt(R_var(3)), [N N_obs]);
X3 = zeros(N, N_obs);
for i = 1:N_obs
    X3(:, i) = R3(:, i) + Y3;
end

% calculate errors
y1_hat = mmmse(X1, Y1);
MMSE1(2, 1) = mean((Y1 - y1_hat) .^ 2);

y2_hat = mmmse(X2, Y2);
MMSE2(2, 1) = mean((Y2 - y2_hat) .^ 2);

y3_hat = mmmse(X3, Y3);
MMSE3(2, 1) = mean((Y3 - y3_hat) .^ 2);

Rows = {'Theoretical'; 'Experimental'};

% generate plot
tot = [MMSE1 MMSE2 MMSE3];

x = linspace((min(tot, [], 'all') - .25 * (max(tot, [], 'all') - min(tot, [], 'all'))), ...
    (max(tot, [], 'all') + .25 * (max(tot, [], 'all') - min(tot, [], 'all'))));

figure;
plot(x, x);
hold on;
scatter(tot(1, :), tot(2, :));
for i = 1:length(Y_var)
    text(tot(1, i) - .003, tot(2, i) + .0018, "\sigma_{\it Y}^2 = " + Y_var(i) + ", \sigma_{\it R}^2 = " + R_var(i));
end
xlim([min(x) max(x)]);
title("Comparison of Theoretical and Experimental MMSE with " + N_obs + " observations");
xlabel("Theoretical MMSE Results");
ylabel("Experimental MMSE Results");

% generate table
sc1_table = table(Rows, MMSE1, MMSE2, MMSE3)