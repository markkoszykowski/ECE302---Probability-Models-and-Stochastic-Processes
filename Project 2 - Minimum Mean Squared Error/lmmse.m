function [LMMSE] = lmmse(X,Y)
    muX = mean(X);
    muY = mean(Y);
    sigmaX = std(X);
    sigmaY = std(Y);
    rho = corrcoef(X, Y);
    LMMSE = muY + rho(2) * (sigmaY / sigmaX) * (X - muX);
end