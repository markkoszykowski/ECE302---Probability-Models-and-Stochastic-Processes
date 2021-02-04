function [out] = d(x, y)
% Simple function to calculate the sum of a roll of a Y sided die X times
    out = 0;
    for i = 1:x
        out = out + randi(y);
    end
end