%% ECE310 - Prob & Stoch Project 1
%% Mark Koszykowski, Henry Son, Tamar Bacalu

clc;
clear;
close all;

% rollDice = @(x) randi(x);

easySimNum = 10^6;
mediSimNum = 10^6;
hardSimNum = 10^6;

%% 1


% a

a = 1:easySimNum;
for i = 1:size(a, 2)
    a(i) = d(3, 6);
end

figure;
histogram(a);
title("Simulation of 3d6");
xlabel("Roll");
ylabel("Frequency");

disp("A:");
disp("Experimental: " + prob(a, 18));
disp("Expected: " + 1/216);


% b

b = 1:easySimNum;
for i = 1:size(b, 2)
    b(i) = fun(3, 6);
end

figure;
histogram(b);
title("Simulation of 3d6 Using 'Fun Method'");
xlabel("Roll");
ylabel("Frequency");

disp(newline + "B:");
disp("Experimental: " + prob(b, 18));
disp("Expected: " + 1/72);


% c

c = zeros(6, hardSimNum);
for i = 1:size(c, 2)
    c(:, i) = [fun(3, 6) fun(3, 6) fun(3, 6) fun(3, 6) fun(3, 6) fun(3, 6)];
end

disp(newline + "C:");
disp("Experimental: " + prob(c, [18 18 18 18 18 18]));
disp("Expected: " + 1/(72^6));

for i = 1:size(c, 2)
    if min(c(:, i) == [18 18 18 18 18 18])
        disp("A Fontaine was rolled!");
        break;
    end
end


% d

d = zeros(6, mediSimNum);
for i = 1:size(d, 2)
    d(:, i) = [fun(3, 6) fun(3, 6) fun(3, 6) fun(3, 6) fun(3, 6) fun(3, 6)];
end

disp(newline + "D:");
disp("Experimental: " + prob(d, [9 9 9 9 9 9]));
disp("Expected: " + 1/(24^6));

for i = 1:size(d, 2)
    if min(d(:, i) == [9 9 9 9 9 9])
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