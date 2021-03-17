function [BMMSE] = bmmse(X,Y)
    h = histogram(X);
    condExp = zeros(h.NumBins, 1);
    for i = 1:h.NumBins
        temp = [];
        for j = 1:length(X)
            if X(j) >= h.BinEdges(i) && X(j) < h.BinEdges(i+1)
                temp(end+1) = Y(j);
            end
        end
        condExp(i) = mean(temp);
    end
    
    BMMSE = zeros(length(Y), 1);
    for i = 1:length(X)
        for j = 1:h.NumBins
            if X(i) >= h.BinEdges(j) && X(i) < h.BinEdges(j+1)
                BMMSE(i) = condExp(j);
                break;
            end
        end
    end
end