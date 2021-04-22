clear;
% Mark Koszykowski, Henry Son, Tamar Bacalu
% ECE302: Detection Theory
%% Radar Detection

%% part 1 
clear all; close all;clc;

%%a. 
Niter = 1e3;

% determine SNR
Amag = 1;      
var = 1;      
SNR = Amag/var;

% probability that target is or not there
P0 = 0.8;
P1 = 1-P0;
eta = P0/P1;

% generate Y vector;
[Y, Trgt] = genYsamestd(Amag, Niter, var, P0);

% find gamma between 2 gaussians:
Gamma = @(Amag,var, eta) Amag./2+var*log(eta)*ones(size(Amag))./(Amag);
gam = Gamma(Amag, var, eta);


% check if chose correctly or not:
Perr_exp =1- sum(or(and(Y>gam,Trgt),and(Y<=gam, ~Trgt)))/Niter;

% theory
P10 = 1- normcdf(gam,0, sqrt(var));
P01 = normcdf(gam, Amag, sqrt(var));

Perr_ther = (P10*P0 + P01*P1);

%% b. 
Niter = 1e4;

Amag = [0.5, 1, 2,4];
eta = logspace(-7,7,1e4);
figure

for i = 1:max(size(Amag))
    [Y, Trgt] = genYsamestd(Amag(i), Niter, var, P0);

    [Pd,Pf] = getROC(Amag(i), var, eta, Y, Trgt);
    plot(Pf,Pd, 'DisplayName', ['SNR = ',num2str(Amag(i)/var)], 'linewidth', 1)
    hold on
end

legend
xlabel('Pf')
ylabel('Pd')
title('ROC plot- Different \mu same \sigma^2')

%% c. 
% C01 = 10*C10;
Amag = 1;
Niter = 1e4;

% get the ROC curve
[Y, Trgt] = genYsamestd(Amag, Niter, var, P0);
[Pd,Pf] = getROC(Amag, var, eta, Y, Trgt);

figure;
plot(Pf,Pd, 'DisplayName', ['SNR = ',num2str(Amag)], 'linewidth', 1)
legend
xlabel('Pf')
ylabel('Pd')
title(['ROC plot with C_{01} = 10*C_{10} (\eta = 0.4), SNR = ', num2str(Amag/var)])
hold on

% find the point on ROC curve:
% eta = (C10-C00)P0/((C01-C11)*P1) => nu = P0/(10*P1)
etac = (.1)*P0/P1;
[Pdc,Pfc] = getROC(Amag, var, etac, Y, Trgt);
plot(Pfc, Pdc, '*', 'DisplayName', '\eta = 0.4')

%% d. 
% generating a bunch of a-priori probabilities
P1 = 0:0.01:1;
P0  = 1-P1;

% keeping same cost structure
C10 = 10;

% determining probabilities
eta = P0./(C10.*P1);
gam = (2*var*log(eta)+Amag^2)/(2*Amag);
P10 = 1- normcdf(gam,0, sqrt(var));
P01 = normcdf(gam, Amag, sqrt(var));

% cost
Ecost = (C10*P10.*P0 + P01.*P1);

figure
plot(P1,Ecost)
title('Expected cost for P1')
xlabel('Probability target is present (P1)')
ylabel('Expected cost')

%% e. 
clear all;

Niter = 1e6;
varx = 1;
varz = 25;
sigx = sqrt(varx);
sigz = sqrt(varz);
A = 10;
P0 = 0.8;
P1 = 1-P0;
eta = P0/P1;

% generate Y
[Y, Trgt] = genYsamemean(sigx,sigz,Niter,A,P0);

% P(y|Hi)
PyH1 = @(Y,varx,A) (1/sqrt(varx*2*pi))*exp(-((Y-A).^2)/(2*varx));
PyH0 = @(Y,varz,A) (1/sqrt(varz*2*pi))*exp(-((Y-A).^2)/(2*varz));


% P(error) - using the decision based on which likelyhood is greater
Perr_exp = sum(or(and(PyH1(Y,varx,A)*P1 >= PyH0(Y,varz,A)*P0, Trgt) ...
    , and(PyH1(Y,varx,A)*P1 >= PyH0(Y,varz,A)*P0,~Trgt)))/Niter;

% theoretical results
Gammameansq = @(varx,varz,eta) sqrt(2*(varx*varz/(varx-varz))*log(sqrt(varx/varz)*eta));
gamsq = Gammameansq(varx, varz, eta);

P10 = normcdf(gamsq,0,sigz)-normcdf(-gamsq,0,sigz); 
P01 = 2*(1-normcdf(gamsq,0,sigx));  
Perr_ther = (P10*P0 + P01*P1);

%% b - like
Niter = 1e4;

varz = [4, 9, 16, 25]; 
sigz = sqrt(varz);

eta = logspace(-5,3,5e2);
figure
for i = 1:max(size(varz))
    % generate Y
    [Y, Trgt] = genYsamemean(sigx,sigz(i),Niter,A,P0);
    
    % ROC values
    Pd = sum(and(PyH1(Y,varx,A) >= PyH0(Y,varz(i),A)*eta, Trgt))/sum(Trgt);
    Pf = sum(and(PyH1(Y,varx,A) >= PyH0(Y,varz(i),A)*eta, ~Trgt))/sum(~Trgt);
    
    plot(Pf,Pd, 'DisplayName', ['\sigma^2_z/\sigma^2_x= ',num2str(varz(i)/varx)], 'linewidth', 1)
    hold on
end
legend
xlabel('Pf')
ylabel('Pd')
title('ROC plot - Same \mu different \sigma^2')
xlim([0,1])

%%

function [Y, Trgt] = genYsamestd(Amag, Niter, var, P0)
% Generate a Y vector for two distributions of variance var and mean difference
% Amag, where the probability of target being there is P0 (Niter is the
% number of elements)
X = sqrt(var)*randn(Niter,1);
Trgt = (rand(Niter,1)>P0);
A = Amag*double(Trgt);
Y = A+X;
end

function [Pd,Pf] = getROC(Amag, var, eta, Y, Trgt)
% Given the Amag, and eta, determines the point where H1 becomes more likely
% than H0 (gam) and then go through the Y and Trgt vectors to determine
% the probability of true positives (Pd) and false positives (Pf). 
    gam = Amag./2+var*log(eta)*ones(size(Amag))./(Amag);
    Pd = sum(and(Y>gam,Trgt))./sum(Trgt);
    Pf = sum(and(Y>gam,~Trgt))/sum(~Trgt);
end

function [Y, Trgt] = genYsamemean(sigx,sigz,Niter,A,P0)
% Generate a Y vector for two distributions of std sigx and sigz and same
% mean A, where the probability of target being there is P0 (Niter is the
% number of elements)
    X = sigx*randn(Niter,1);
    Z = sigz*randn(Niter,1);
    Trgt = (rand(Niter,1)>P0);
    Y = A+X.*Trgt+Z.*(~Trgt);
end

%% part 2
%a
 p0 = 0.8;
 p1 = 0.2;
 A = 1;
 N = 1000; %number of iterations
 
 target = randi(5,1,N); 
 target(find(target == 1)) = A;
 target(find(target  > 1)) = 0;
 
 SNR = [1,2,5,8];
 
%b
%c
%d

%% Pattern Classification and Machine Learning
data = load('Iris.mat');

trainingF = zeros(75,4);
testF = zeros(75,4);

%shuffle data to keep training random
shuffledInd = randperm(size(data.features,1));
shuffledF = data.features(shuffledInd,:);
shuffledL = data.labels(shuffledInd,:);
trainingF = shuffledF(1:75, :);
testF = shuffledF(76:end,:);
trainingL = shuffledL(1:75);
testL = shuffledL(76:end);

p1 = trainingF(trainingL == 1,:);
p2 = trainingF(trainingL == 2,:);
p3 = trainingF(trainingL == 3,:);

%Means
mu1 = [mean(p1(:,1)),mean(p1(:,2)),mean(p1(:,3)),mean(p1(:,4))];
mu2 = [mean(p2(:,1)),mean(p2(:,2)),mean(p2(:,3)),mean(p2(:,4))];
mu3 = [mean(p3(:,1)),mean(p3(:,2)),mean(p3(:,3)),mean(p3(:,4))];

%Variances
cov1 = cov(p1);
cov2 = cov(p2);
cov3 = cov(p3);

%Finding max likelihood and error
likelihood = [mvnpdf(testF,mu1,cov1),mvnpdf(testF,mu2,cov2),mvnpdf(testF,mu3,cov3)];
[~,result] = max(likelihood, [], 2);
error = sum(testL~=result);
pError = error/size(testL,1)
confutionM = confusionmat(testL,result)
