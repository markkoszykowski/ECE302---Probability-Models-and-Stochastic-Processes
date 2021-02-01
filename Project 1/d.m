function [out] = d(x, y)
    out = 0;
    for i = 1:x
        out = out + randi(y);
    end
end