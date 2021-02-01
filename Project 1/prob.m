function [out] = prob(input, targ)
    out = 0;
    for i = 1:size(input, 2)
        if min(input(:, i) == targ)
            out = out + 1;
        end
    end
    out = out / size(input, 2);
end