function [out] = fun(x, y)
% Simple function to produce a value using a fun method of rolling a set of
% dice three times and choosing the maximum
    out = 1:3;
    for i = 1:3
        out(i) = d(x, y);
    end
    out = max(out);
end