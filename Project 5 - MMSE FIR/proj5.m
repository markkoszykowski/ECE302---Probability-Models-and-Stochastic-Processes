% Tamar Bacalu, Mark Koszykowski, Henry Son
clc; clear; close all;

%% Part 1

%{

s[n] = +/-1 i.i.d. with p = .5
d[n] white noise Gaussian with var(d) = 1
c[n] = [1 .2 .4]

Rsr[N] = E[s[n]r[n-N]]

                 2
        = E[s[n](S{c[k]s[n-N-k]} + d[n-N])]
                k=0

        = E[s[n](s[n-N] + .2s[n-N-1] + .4s[n-N-2] + d[n-N])]

        = E[s[n]s[n-N] + .2s[n]s[n-N-1] + .4s[n]s[n-N-2] + s[n]d[n-N]]

        = Rss[N] + .2Rss[N+1] + .4Rss[N+2] + Rsd[N]

        assume noise and signal are uncorrelated

        = Rss[N] + .2Rss[N+1] + .4Rss[N+2]


Rrr[N] = E[r[n]r[n-N]]

             2                     2
        = E[(S{c[k]s[n-k]} + d[n])(S{c[k]s[n-N-k]} + d[n-N])]
            k=0                   k=0

        = E[(s[n] + .2s[n-1] + .4s[n-2] + d[n])(s[n-N] + .2s[n-N-1] + .4s[n-N-2] + d[n-N])]

        = E[s[n]s[n-N] + .2s[n]s[n-N-1] + .4s[n]s[n-N-2] + s[n]d[n-N]
            + .2s[n-1]s[n-N] + .04s[n-1]s[n-N-1] + .08s[n-1]s[n-N-2] + .2s[n-1]d[n-N]
            + .4s[n-2]s[n-N] + .08s[n-2]s[n-N-1] + .16s[n-1]s[n-N-2] + .4s[n-2]d[n-N]
            + d[n]s[n-N] + .2d[n]s[n-N-1] + .4d[n]s[n-N-2] + d[n]d[n-N]]

        = Rss[N] + .2Rss[N+1] + .4Rss[N+2] + Rsd[N]
            + .2Rss[N-1] + .04Rss[N] + .08Rss[N+1] + .2Rsd[N-1]
            + .4Rss[N-2] + .08Rss[N-1] + .16Rss[N] + .4Rsd[N-2]
            + Rds[N] + .2Rds[N+1] + .4Rds[N+2] + Rdd[N]

        assume noise and signal are uncorrelated

        = .4Rss[N+2] + .28Rss[N+1] + 1.2Rss[N] + .28Rss[N-1] + .4Rss[N-2] + Rdd[N]


where,

         1,        N  =  0                  1, N  =  0
Rss[N] = (2p-1)^2, N =/= 0   ==>   Rss[n] = 0, N =/= 0

         var, N  =  0
Rdd[N] = 0,   N =/= 0


N = 4

| Rrr[0]   Rrr[-1]   Rrr[-2]   Rrr[-3] |  | h[0] |     | Rsr[0] |
| Rrr[1]   Rrr[0]    Rrr[-1]   Rrr[-2] |  | h[1] |  =  | Rsr[1] |
| Rrr[2]   Rrr[1]    Rrr[0]    Rrr[-1] |  | h[2] |     | Rsr[2] |
| Rrr[3]   Rrr[2]    Rrr[1]    Rrr[0]  |  | h[3] |     | Rsr[3] |

| 2.2   .28   .4     0  |  | h[0] |     | 1 |
| .28   2.2   .28   .4  |  | h[1] |  =  | 0 |
| .4    .28   2.2   .28 |  | h[2] |     | 0 |
| 0     .4    .28   2.2 |  | h[3] |     | 0 |

h[0] = (1303875/2737117) ~ .476
h[1] = (-147350/2737117) ~ -.054
h[2] = (-225375/2737117) ~ -.082
h[3] = (55475/2737117) ~ .020

%}


%% Part 2

% parameters
var = 1;
N = [4, 6, 10];
c = [1, 0.2, 0.4];
Niter = 1e6;

% generate s, d, r
s = rand(Niter, 1);
s = (s < 0.5) - (s >= 0.5);
d = sqrt(var) * randn(Niter, 1);
r = d + filter(c, 1, s);

% use data to approximate Rsr and Rrr
Rsr = zeros(max(N), 1);
Rrr = zeros(max(N), 1);
for i = 1:max(N)
    Rsr(i) = mean(s(i:end) .* r(1:end + 1 - i));
    Rrr(i) = mean(r(i:end) .* r(1:end + 1 - i));
end
RrrMat = toeplitz(Rrr);

% solve for h coefficients and approximate s_hat
h = zeros(max(N), length(N));
for i = 1:length(N)
    h(1:N(i), i) = RrrMat(1:N(i), 1:N(i)) \ Rsr(1:N(i));
    s_hat(:, i) = filter(h(1:N(i), i), 1, r);
end

% print values of filter (sanity check for part 1)
disp("N = 4, h[n] = ");
disp(h(1:4, 1).');

% get MSE with filter
MSE = mean((s - s_hat) .^ 2).';

% tabulate
t = table(MSE, 'RowNames', {'N=4', 'N=6', 'N=10'});
disp(t);