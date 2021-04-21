clear;
% Mark Koszykowski, Henry Son, Tamar Bacalu
% ECE302: Detection Theory
%% Radar Detection
 
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