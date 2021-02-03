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

a1 = 1:easySimNum;
for i = 1:size(a1, 2)
    a1(i) = d(3, 6);
end

figure;
histogram(a1);
title("Simulation of 3d6 with " + easySimNum + " Samples");
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
title("Simulation of 3d6 Using 'Fun Method' with " + easySimNum + " Samples");
xlabel("Roll");
ylabel("Frequency");

disp(newline + indent + "B:");
disp(indent + indent + "Experimental: " + prob(b1, 18));
disp(indent + indent + "Expected: " + ((3*(215)^2 + 3*(215) + 1)/216^3));


% c

c1 = zeros(6, hardSimNum);
for i = 1:size(c1, 2)
    for j = 1:size(c1, 1)
        c1(j, i) = fun(3, 6);
    end
end

disp(newline + indent + "C:");
disp(indent + indent + "Experimental: " + prob(c1, [18 18 18 18 18 18]));
disp(indent + indent + "Expected: " + ((3*(215)^2 + 3*(215) + 1)/216^3)^6);

for i = 1:size(c1, 2)
    if min(c1(:, i) == [18 18 18 18 18 18])
        disp(indent + indent + "A Fontaine was rolled!");
        break;
    end
end


% d

d1 = zeros(6, mediSimNum);
for i = 1:size(d1, 2)
    for j = 1:size(d1, 1)
        d1(j, i) = d(3, 6);
    end
end

disp(newline + indent + "D:");
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

a2troll = 1:easySimNum;
a2spell = 1:easySimNum;
for i = 1:size(a2troll, 2)
    a2troll(i) = d(1, 4);
    a2spell(i) = d(2, 2);
end

disp(indent + "A:");
disp(indent + indent + "Experimental Average Troll Health: " + mean(a2troll));
disp(indent + indent + "Expected Average Toll Health: " + 5/2);
disp(indent + indent + "Experimental Average Spell Damage: " + mean(a2spell));
disp(indent + indent + "Expected Average Spell Damage: " + 3);
disp(indent + indent + "Experimental Probability FIREBALL is >3: " + prob(a2spell, 4));
disp(indent + indent + "Expected Probability FIREBALL is >3: " + 1/4);


% b

figure;
subplot(2, 1, 1);
histogram(a2troll);
title("Probability Mass Function of Troll Hit Points with " + easySimNum + " Samples");
xlabel("Hit Points");
ylabel("Probability");
yticklabels(yticks / size(a2troll, 2));

subplot(2, 1, 2);
histogram(a2spell);
title("Probability Mass Function of Wizard Spell Damage with " + easySimNum + " Samples");
xlabel("Spell Damage");
ylabel("Probability");
yticklabels(yticks / size(a2spell, 2));


% c

c2 = zeros(2, easySimNum);
for i = 1:size(c2, 2)
    c2(1, i) = d(1, 4);
    c2(2, i) = d(1, 4);
end

for i = 1:size(c2, 2)
    fireball = d(2, 2);
    if fireball >= c2(1, i)
        c2(1, i) = 0;
    end
    if fireball >= c2(2, i)
        c2(2, i) = 0;
    end
end

disp(newline + indent + "C:");
disp(indent + indent + "Experimental: " + prob(c2, [0 0]));
disp(indent + indent + "Expected: " + 19/32);


% d

d2 = zeros(2, easySimNum);
for i = 1:size(d2, 2)
    d2(1, i) = d(1, 4);
    d2(2, i) = d(1, 4);
end

tot = 0;
n = 0;

for i = 1:size(d2, 2)
    fireball = d(2, 2);
    if d2(1, i) > fireball && d2(2, i) <= fireball
        tot = tot + d2(1, i);
        n = n + 1;
    elseif d2(2, i) > fireball && d1(1, i) <= fireball
        tot = tot + d2(2, i);
        n = n + 1;
    end
end

meanTroll = tot / n;

disp(newline + indent + "D:");
disp(indent + indent + "Experimental: " + meanTroll);
disp(indent + indent + "Expected: " + 19/5);


% e

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

disp(newline + indent + "E:");
disp(indent + indent + "Experimental: " + mean(e2));
disp(indent + indent + "Expected: " + 33/8);