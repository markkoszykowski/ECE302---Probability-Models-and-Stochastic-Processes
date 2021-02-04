function [out] = prob(input, targ)
% Simple function to calculate the experimental probability that samples
% within a input vector are equal to a specified 'targ'
    out = 0;
    for i = 1:size(input, 2)
        if min(input(:, i) == targ)
            out = out + 1;
        end
    end
    out = out / size(input, 2);
end