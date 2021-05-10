%% parameters
var = 1;
N = [1, 4, 6, 10, 100];
c = [1, 0.2, 0.4];
Niter = 1e6;

%% generate s, d, r
s = rand(Niter, 1);
s = (s < 0.5) - (s > 0.5);
d = sqrt(var) * randn(Niter, 1);
r = d + filter(c, 1, s);

%% use data to approximate Rrr and Rsr
Rsr = zeros(max(N), 1);
for ii = 1:max(N)
    rrr(ii) = mean(r(ii:end) .* r(1:end + 1 - ii));
    Rsr(ii) = mean(s(ii:end) .* r(1:end + 1 - ii));
end
Rrr = toeplitz(rrr);

%% solve for h coefficients and approximate s
h = zeros(max(N), length(N));
for ii = 1:length(N)
    h(1:N(ii), ii) = Rrr(1:N(ii), 1:N(ii)) \ Rsr(1:N(ii));
    s_hat(:, ii) = filter(h(1:N(ii), ii), 1, r);
end

%% get MSE with filter
MSE = mean((s - s_hat) .^ 2).';

%% tabulate
t = table(MSE, 'RowNames', {'N=1', 'N=4', 'N=6', 'N=10', 'N=100'})
