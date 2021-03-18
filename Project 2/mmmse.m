function [MMMSE] = mmmse(X,Y)
    muY = mean(Y);
    varY = var(Y);
    [N, N_obs] = size(X);
    varR = zeros(N, N_obs);
    for i = 1:N_obs
        varR(:, i) = X(:, i) - Y;
    end
    avgVarR = var(reshape(varR, [], 1));
    MMMSE = (1 / (N_obs * varY + avgVarR)) * (avgVarR * muY + varY * sum(X, 2));
end