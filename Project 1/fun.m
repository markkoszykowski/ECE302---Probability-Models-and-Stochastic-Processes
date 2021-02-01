function [out] = fun(x, y)
    out = 1:3;
    for i = 1:3
        out(i) = d(x, y);
    end
    out = max(out);
end