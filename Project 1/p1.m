%% ECE310 - Prob & Stoch Project 1
%% Tamar Bacalu, Mark Koszykowski, Henry Son

clc;
clear;
close all;

% rollDice = @(x) randi(x);

easySimNum = 10^6;
mediSimNum = 10^6;
hardSimNum = 10^6;
indent = "     ";

%% 1

disp("1");

% a

a1 = 1:easySimNum;
for i = 1:size(a1, 2)
    a1(i) = d(3, 6);
end

figure;
histogram(a1);
title("Simulation of 3d6");
xlabel("Roll");
ylabel("Frequency");

disp(indent + "A:");
disp(indent + indent + "Experimental: " + prob(a1, 18));
disp(indent + indent + "Expected: " + 1/216);


% b

b1 = 1:easySimNum;
for i = 1:size(b1, 2)
    b1(i) = fun(3, 6);
end

figure;
histogram(b1);
title("Simulation of 3d6 Using 'Fun Method'");
xlabel("Roll");
ylabel("Frequency");

disp(newline + indent + "B:");
disp(indent + indent + "Experimental: " + prob(b1, 18));
disp(indent + indent + "Expected: " + 1/72);


% c

c1 = zeros(6, hardSimNum);
for i = 1:size(c1, 2)
    c1(:, i) = [fun(3, 6) fun(3, 6) fun(3, 6) fun(3, 6) fun(3, 6) fun(3, 6)];
end

disp(newline + indent + "C:");
disp(indent + indent + "Experimental: " + prob(c1, [18 18 18 18 18 18]));
disp(indent + indent + "Expected: " + 1/(72^6));

for i = 1:size(c1, 2)
    if min(c1(:, i) == [18 18 18 18 18 18])
        disp("A Fontaine was rolled!");
        break;
    end
end


% d

d1 = zeros(6, hardSimNum);
for i = 1:size(d1, 2)
    d1(:, i) = [fun(3, 6) fun(3, 6) fun(3, 6) fun(3, 6) fun(3, 6) fun(3, 6)];
end

disp(newline + indent + "D:");
disp(indent + indent + "Experimental: " + prob(d1, [9 9 9 9 9 9]));
disp(indent + indent + "Expected: " + 1/(24^6));

for i = 1:size(d1, 2)
    if min(d1(:, i) == [9 9 9 9 9 9])
        disp("A Keene was rolled!");
        break;
    end
end


%% 2

% a

% b

% c

% d

% e