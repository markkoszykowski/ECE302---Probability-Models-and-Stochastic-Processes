% Tamar Bacalu, Mark Koszykowski
clc; clear; close all;

%% Part 1

disp("Part 1:")

% a

p0 = 0.8;
p1 = 0.2;
% constant value for A
Aval = 1;
% number of iterations
N = 1e3;
% standard deviation of X distribution
sigma = .5;

A = zeros(N, 1);
% generate 1000 random values 1-5
rands = randi(5, N, 1);
% 1/5 (20%) chance that A takes on constant value, otherwise 0
A(rands == 1) = Aval;
% generate X values
X = normrnd(0, sigma, [N, 1]);
Y = A + X;

% Max A Posteriori Rule
thres = (sigma^2 / Aval) * log(p0 / p1) + (Aval / 2);

% po * P_F + p1 * (1 - P_D)
theo_err = p0 * (1 - normcdf(thres, 0, sigma)) + p1 * normcdf(thres, Aval, sigma);
% put matrices in terms of their classes and find probability of unequal
expr_err = sum((Y > thres) ~= (A == Aval)) / N;

% sanity check
% False Alarm
F = sum((Y > thres) & (A == 0)) / sum((A == 0));
% Detection
D = sum((Y > thres) & (A == Aval)) / sum((A == Aval));
% should be same as expr_err (check console)
expr_err_check = (1 - D) * (sum((A == Aval)) / N) + F * (sum((A == 0)) / N);

disp("     A:");
disp("          Theoretical Error: " + theo_err);
disp("          Experimental Error: " + expr_err);


% b & c

% define some matrix of Signal to Noise Ratios
SNR = linspace(1, 10, 6);

disp("     C:");
figure();
set(gcf, 'position', [50, 50, 1200, 700]);
% keeping noise constant while altering constant A
for i = 1:length(SNR)
    % calculate new A
    newAval = SNR(i) * sigma^2;
    
    newA = zeros(N, 1);
    % 1/5 (20%) chance that A takes on constant value
    newA(rands == 1) = newAval;
    newY = newA + X;
    
    % Part c threshold
    % Max A Posteriori Rule but set c01 to 10
    newthres = (sigma^2 / newAval) * log(p0 / (10 * p1)) + (newAval / 2);
    disp("          Threshold if missing target is 10x worse than false detection for SNR = " ...
        + SNR(i) + ": " + newthres);
    
    % create a bunch of thresholds to create ROC plot
    testthres = linspace(-10, 10, 1e3);
    P_F = zeros(length(testthres), 1);
    P_D = zeros(length(testthres), 1);
    
    for j = 1:length(testthres)
        % calculate the False Positive and Detection probabilities for each
        % threshold and the specific threshold for part c
        F10 = sum((newY > newthres) & (newA ~= newAval)) / sum((newA == 0));
        D10 = sum((newY > newthres) & (newA == newAval)) / sum((newA == newAval));
        P_F(j) = sum((newY > testthres(j)) & (newA ~= newAval)) / sum((newA == 0));
        P_D(j) = sum((newY > testthres(j)) & (newA == newAval)) / sum((newA == newAval));
    end
    
    % plot results for each SNR
    subplot(2, 3, i);
    plot(P_F, P_D, '-b', F10, D10, 'r*');
    title("Reciever Operating Curve for SNR of " + SNR(i));
    xlabel("Probability of False Alarm (P_F)");
    ylabel("Probability of Detection (P_D)");
    legend("ROC", "c_{01} = 10 * c_{10}", 'Location', 'southeast');
    xlim([0 1]);
    ylim([0 1]);
end


%e

% standard deviation of Z distribution
sigmaZ = .75;

% generate Z values
Z = normrnd(0, sigmaZ, [N, 1]);
% target present
Y(rands == 1) = Aval + X(rands == 1);
% target not present
Y(rands ~= 1) = Aval + Z(rands ~= 1);

% no real threshold exists for chosen value of sigmaZ => always choose that target isnt 
% present (H0) since probability is always higher than if target is present (H1)

% squared difference threshold (easier than solving quadratic)
% this must be positive otherwise always choose H0 for sigmaZ^2 > sigma^2
thres = 2 * ((sigma^2 * sigmaZ^2) / (sigmaZ^2 - sigma^2)) * log((p1 * sigmaZ) / (p0 * sigma));

% always choosing not present, so probability of error should just be 
% probability of target present
theo_err = p1;
% put matrices in terms of their classes and find probability of unequal
% if value is real, choose target not present
expr_err = sum((imag(Y) ~= 0) ~= (rands == 1)) / N;

disp("     E:");
disp("          Theoretical Error: " + theo_err);
disp("          Experimental Error: " + expr_err);

% define some matrix of sigmaZ^2 to sigma^s ratios
ZXR = linspace(1, 100, 6);

figure();
set(gcf, 'position', [60, 60, 1200, 700]);
% simulation to plot one sided threshold ROC
% keeping sigma constant while altering sigmaZ
for i = 1:length(ZXR)
    % calculate new standard deviation of Z distribution
    newsigmaZ = sqrt(ZXR(i) * sigma^2);
    
    % generate Z values
    newZ = normrnd(0, newsigmaZ, [N, 1]);
    
    newY = zeros(N, 1);
    % target present
    newY(rands == 1) = Aval + X(rands == 1);
    % target not present
    newY(rands ~= 1) = Aval + newZ(rands ~= 1);
    
    % create a bunch of thresholds to create ROC plot
    testthres = linspace(-100, 100, 1e3);
    P_F = zeros(length(testthres), 1);
    P_D = zeros(length(testthres), 1);
    
    for j = 1:length(testthres)
        % calculate the False Positive and Detection probabilities for each
        % one sided threshold
        P_F(j) = sum((newY > testthres(j)) & (rands ~= 1)) / sum((rands ~= 1));
        P_D(j) = sum((newY > testthres(j)) & (rands == 1)) / sum((rands == 1));
    end
        
    % plot results for each ZXR
    subplot(2, 3, i);
    plot(P_F, P_D);
    title("One Sided ROC for \sigma_Z^2 / \sigma^2 of " + ZXR(i));
    xlabel("Probability of False Alarm (P_F)");
    ylabel("Probability of Detection (P_D)");
    xlim([0 1]);
    ylim([0 1]);
end

figure();
set(gcf, 'position', [70, 70, 1200, 700]);
% simulation to plot two sided ROC
% keeping sigma constant while altering sigmaZ
for i = 1:length(ZXR)
    % calculate new standard deviation of Z distribution
    newsigmaZ = sqrt(ZXR(i) * sigma^2);
    
    % generate Z values
    newZ = normrnd(0, newsigmaZ, [N, 1]);
    
    newY = zeros(N, 1);
    % target present
    newY(rands == 1) = Aval + X(rands == 1);
    % target not present
    newY(rands ~= 1) = Aval + newZ(rands ~= 1);
    
    % create a bunch of thresholds to create ROC plot
    testthres = linspace(0, 200, 1e3);
    P_F = zeros(length(testthres), 1);
    P_D = zeros(length(testthres), 1);
    
    for j = 1:length(testthres)
        % calculate the False Positive and Detection probabilities for each
        % two sided threshold
        P_F(j) = sum((((newY - Aval).^2) < testthres(j)) & (rands ~= 1)) / sum((rands ~= 1));
        P_D(j) = sum((((newY - Aval).^2) < testthres(j)) & (rands == 1)) / sum((rands == 1));
    end
    
    % calculating threshold for False Positive and Detection probabilities for MAP rule
    MAP_thres = 2 * ((sigma^2 * newsigmaZ^2) / (newsigmaZ^2 - sigma^2)) * log((p1 * newsigmaZ) / (p0 * sigma));
    % make sure value isnt less than zero or infinite (occurs when
    % variances are the same)
    if MAP_thres >= 0 && MAP_thres ~= Inf
        MAP_F = sum((((newY - Aval).^2) < MAP_thres) & ((rands == 1) == 0)) / sum((rands ~= 1));
        MAP_D = sum((((newY - Aval).^2) < MAP_thres) & ((rands == 1) == 1)) / sum((rands == 1));
    else
    % if threshold is less than zero, then always pick H0
        MAP_F = sum(((imag(newY) ~= 0) == 1) & ((rands == 1) == 0)) / sum((rands ~= 1));
        MAP_D = sum(((imag(newY) ~= 0) == 1) & ((rands == 1) == 1)) / sum((rands == 1));
    end
        
    % plot results for each ZXR
    subplot(2, 3, i);
    plot(P_F, P_D, '-b', MAP_F, MAP_D, 'r*');
    title("Two Sided ROC for \sigma_Z^2 / \sigma^2 of " + ZXR(i));
    xlabel("Probability of False Alarm (P_F)");
    ylabel("Probability of Detection (P_D)");
    legend("ROC", "MAP", 'Location', 'southeast');
    xlim([0 1]);
    ylim([0 1]);
end

%% Part 2

data = load('Iris.mat');

% shuffle data to keep training random
shuffledInd = randperm(size(data.features, 1));
shuffledF = data.features(shuffledInd, :);
shuffledL = data.labels(shuffledInd, :);

% divide up data into train and test
trainF = shuffledF(1:75, :);
testF = shuffledF(76:end, :);

trainL = shuffledL(1:75);
testL = shuffledL(76:end);

class1 = trainF(trainL == 1, :);
class2 = trainF(trainL == 2, :);
class3 = trainF(trainL == 3, :);

% mean vectors
mu1 = [mean(class1(:, 1)), mean(class1(:, 2)), mean(class1(:, 3)), mean(class1(:, 4))];
mu2 = [mean(class2(:, 1)), mean(class2(:, 2)), mean(class2(:, 3)), mean(class2(:, 4))];
mu3 = [mean(class3(:, 1)), mean(class3(:, 2)), mean(class3(:, 3)), mean(class3(:, 4))];

% covariance matrices
cov1 = cov(class1);
cov2 = cov(class2);
cov3 = cov(class3);

% calculate MVNPDF and find max likelihood
likelihood = [mvnpdf(testF, mu1, cov1), ...
    mvnpdf(testF, mu2, cov2), ...
    mvnpdf(testF, mu3, cov3)];
[~, result] = max(likelihood, [], 2);

disp("Part 2:");

% compute cumulative error
error = sum(testL ~= result) / size(testL, 1);
disp("     Cumulative Error: " + error);

confusionM = confusionmat(testL, result);
disp("     Confusion Matrix:");
disp(confusionM);