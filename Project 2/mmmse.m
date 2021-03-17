function [MMMSE] = mmmse(X,Y)
    muY = mean(Y);
    varY = var(Y);
    [N, N_obs] = size(X);
    varR = zeros(N_obs, 1);
    for i = 1:N_obs
        varR(i) = var((X(:, i) - Y));
    end
    avgVarR = mean(varR);
    MMMSE = (1 / (N_obs * varY + avgVarR)) * (avgVarR * muY + varY * sum(X, 2));
end