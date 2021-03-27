function [BMMSE] = bmmse(X,Y)
    [N, edges] = histcounts(X);
    condExp = zeros(length(N), 1);
    for i = 1:length(N)
        temp = [];
        for j = 1:length(X)
            if X(j) >= edges(i) && X(j) < edges(i+1)
                temp(end+1) = Y(j);
            end
        end
        condExp(i) = mean(temp);
    end
    
    BMMSE = zeros(length(Y), 1);
    for i = 1:length(X)
        for j = 1:length(N)
            if X(i) >= edges(j) && X(i) < edges(j+1)
                BMMSE(i) = condExp(j);
                break;
            end
        end
    end
end