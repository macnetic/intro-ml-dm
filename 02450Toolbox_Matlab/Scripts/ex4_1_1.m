% exercise 4.1.1

% Number of samples
N = 200; 

% Mean
mu = 17;       

% Standard deviation
s = 2;  

% Number of bins in histogram
NBins = 20;

%% Generate samples from the Normal distribution
X = normrnd(mu, s, N, 1);

%% Plot a histogram
mfig('Normal distribution');
subplot(1,2,1);
plot(X, 'x');
subplot(1,2,2);
hist(X, NBins);
