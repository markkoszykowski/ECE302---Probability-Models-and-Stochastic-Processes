%% ECE310 - Prob & Stoch Project 1
%% Tamar Bacalu, Mark Koszykowski, Henry Son

clc;
clear;
close all;

rollDice = @(x) randi(x);

easySimNum = 10^5;
mediSimNum = 10^6;
hardSimNum = 10^7;
indent = "     ";

%% 1

disp("1");

% a

% P(X = 18) = (1/6)(1/6)(1/6)

% Take random samples of ability scores
a1 = 1:easySimNum;
for i = 1:size(a1, 2)
    a1(i) = d(3, 6);
end

figure;
histogram(a1);
title("Simulation of 3d6 with " + easySimNum + " Samples");
xlabel("Roll");
ylabel("Frequency");

% Calculate the probability that the scores were =18
disp(indent + "A:");
disp(indent + indent + "Experimental: " + prob(a1, 18));
disp(indent + indent + "Expected: " + 1/216);


% b

% P(Xf = 18) = 3(1/6)^3(215/216)^2 + 3(1/6)^6(215/216) + (1/6)^9
%              = (3*(215)^2 + 3*(215) + 1)/216^3

% Take random samples of ability scores with fun method (roll 3x, choose max)
b1 = 1:easySimNum;
for i = 1:size(b1, 2)
    b1(i) = fun(3, 6);
end

figure;
histogram(b1);
title("Simulation of 3d6 Using 'Fun Method' with " + easySimNum + " Samples");
xlabel("Roll");
ylabel("Frequency");

% Calculate the probability that the scores were =18
disp(indent + "B:");
disp(indent + indent + "Experimental: " + prob(b1, 18));
disp(indent + indent + "Expected: " + (3*(215)^2 + 3*(215) + 1)/216^3);


% c

% P(Xfn = 18), 1<=n<=6 = (P(Xf = 18))^6 = ((3*(215)^2 + 3*(215) + 1)/216^3)^6

% Take random samples of ability scores with fun method (roll 3x, choose max)
% for all 6 ability scores
c1 = zeros(6, hardSimNum);
for i = 1:size(c1, 2)
    for j = 1:size(c1, 1)
        c1(j, i) = fun(3, 6);
    end
end

% Calculate the probability that the character was =Fontaine
disp(indent + "C:");
disp(indent + indent + "Experimental: " + prob(c1, [18 18 18 18 18 18]));
disp(indent + indent + "Expected: " + ((3*(215)^2 + 3*(215) + 1)/216^3)^6);

for i = 1:size(c1, 2)
    if min(c1(:, i) == [18 18 18 18 18 18])
        disp(indent + indent + "A Fontaine was rolled!");
        break;
    end
end


% d

% P(Xn = 9), 1<=n<=6 = (P(X = 9))^6 = (25/216)^6

% Take random samples of ability scores for all 6 ability scores
d1 = zeros(6, hardSimNum);
for i = 1:size(d1, 2)
    for j = 1:size(d1, 1)
        d1(j, i) = d(3, 6);
    end
end

% Calculate the probability that the character was =Keene
disp(indent + "D:");
disp(indent + indent + "Experimental: " + prob(d1, [9 9 9 9 9 9]));
disp(indent + indent + "Expected: " + (25/216)^6);

for i = 1:size(d1, 2)
    if min(d1(:, i) == [9 9 9 9 9 9])
        disp(indent + indent + "A Keene was rolled!");
        break;
    end
end


%% 2

disp("2");

% a

% E[X] = 1(1/4) + 2(1/4) + 3(1/4) + 4(1/4) = 5/2

% E[Y] = 2(1/4) + 3(1/2) + 4(1/4) = 3

% P(X > 3) = P(X = 4) = 1/4

% Take random samples of Troll HPs and Fireball Damages
a2troll = 1:easySimNum;
a2spell = 1:easySimNum;
for i = 1:size(a2troll, 2)
    a2troll(i) = d(1, 4);
    a2spell(i) = d(2, 2);
end

% Calculate the E[X] of Troll HP and Fireball Damage and the probability
% that the fireball is >3
disp(indent + "A:");
disp(indent + indent + "Experimental Average Troll Health: " + mean(a2troll));
disp(indent + indent + "Expected Average Toll Health: " + 5/2);
disp(indent + indent + "Experimental Average Spell Damage: " + mean(a2spell));
disp(indent + indent + "Expected Average Spell Damage: " + 3);
disp(indent + indent + "Experimental Probability FIREBALL is >3: " + prob(a2spell, 4));
disp(indent + indent + "Expected Probability FIREBALL is >3: " + 1/4);


% b

b2trollx = [1 2 3 4];
b2trolly = [0 0 0 0];
b2spellx = [2 3 4];
b2spelly = [0 0 0];

% Calculate the probability of each value for Troll HP and Fireball Damage
for i = 1:size(a2troll, 2)
    if a2troll(i) == 1
        b2trolly(1) = b2trolly(1) + 1;
    elseif a2troll(i) == 2
        b2trolly(2) = b2trolly(2) + 1;
    elseif a2troll(i) == 3
        b2trolly(3) = b2trolly(3) + 1;
    elseif a2troll(i) == 4
        b2trolly(4) = b2trolly(4) + 1;
    end
    if a2spell(i) == 2
        b2spelly(1) = b2spelly(1) + 1;
    elseif a2spell(i) == 3
        b2spelly(2) = b2spelly(2) + 1;
    elseif a2spell(i) == 4
        b2spelly(3) = b2spelly(3) + 1;
    end
end
b2trolly = b2trolly / size(a2troll, 2);
b2spelly = b2spelly / size(a2spell, 2);

figure;
subplot(1, 2, 1);
stem(b2trollx, b2trolly);
title("Probability Mass Function of Troll Hit Points with " + easySimNum + " Samples");
xlabel("Hit Points");
ylabel("Probability");

subplot(1, 2, 2);
stem(b2spellx, b2spelly);
title("Probability Mass Function of Wizard Spell Damage with " + easySimNum + " Samples");
xlabel("Spell Damage");
ylabel("Probability");


% c

% P(Y >= Xn), 1<=n<=2 = P(Y >= Xn & Y = 2) & P(Y >= Xn & Y = 3) & P(Y >= Xn & Y = 4)
%                       = 4(1/4)^3 + 9(1/2)(1/4)^2 + 16(1/4)^3
%                            = 19/32

% Take random samples of Troll HPs for 2 Trolls
c2 = zeros(2, easySimNum);
for i = 1:size(c2, 2)
    c2(1, i) = d(1, 4);
    c2(2, i) = d(1, 4);
end

% For each set of trolls, produce a fireball and see if it would have killed
% the trolls
for i = 1:size(c2, 2)
    fireball = d(2, 2);
    % Sets value to zero if dead since prob() cant accept ranges
    if fireball >= c2(1, i)
        c2(1, i) = 0;
    end
    if fireball >= c2(2, i)
        c2(2, i) = 0;
    end
end

% Calculate the probability that both Trolls were killed
disp(indent + "C:");
disp(indent + indent + "Experimental: " + prob(c2, [0 0]));
disp(indent + indent + "Expected: " + 19/32);


% d

% E[Xn|Y >= X!n & Xn > Y], 1<=n<=2 
%   = 3 * P(Y >= X!n & Xn > Y & Y = 2) / P(Y >= X!n & Xn > Y)
%     + 4 * P(Y >= X!n & Xn > Y & Y = 3) / P(Y >= X!n & Xn > Y)
%       = 3 * (1/16)/(5/16) + 4 * (1/4)/(5/16)
%           = 19/5

% Take random samples of Troll HPs for 2 Trolls
d2 = zeros(2, mediSimNum);
for i = 1:size(d2, 2)
    d2(1, i) = d(1, 4);
    d2(2, i) = d(1, 4);
end

% Calculate the E[X] of the Troll HP of the Troll that survived given one
% died and one survived
tot = 0;
n = 0;

for i = 1:size(d2, 2)
    fireball = d(2, 2);
    % Check condition that either Troll 1 died and Troll 2 survived or
    % vice-versa
    if d2(1, i) > fireball && d2(2, i) <= fireball
        tot = tot + d2(1, i);
        n = n + 1;
    elseif d2(2, i) > fireball && d1(1, i) <= fireball
        tot = tot + d2(2, i);
        n = n + 1;
    end
end

meanTroll = tot / n;

disp(indent + "D:");
disp(indent + indent + "Experimental: " + meanTroll);
disp(indent + indent + "Expected: " + 19/5);


% e

% E[Z] = (1/2)E[2d6] + (1/4)E[1d4]
%       = (1/2)7 + (1/4)(5/2)
%           = 33/8

% Take random samples of Shedjam Damage
e2 = 1:mediSimNum;
for i = 1:size(e2, 2)
    damage = 0;
    if rollDice(20) >= 11
        damage = damage + d(2, 6);
        if rollDice(20) >= 11
            damage = damage + d(1, 4);
        end
    end
    e2(i) = damage;
end

figure;
histogram(e2);
title("Simulation of Shedjam Damage with " + mediSimNum + " Samples");
xlabel("Damage");
ylabel("Frequency");

% Calculate the E[X] of Shedjam Damage
disp(indent + "E:");
disp(indent + indent + "Experimental: " + mean(e2));
disp(indent + indent + "Expected: " + 33/8);