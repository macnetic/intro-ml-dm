%% exercise 2.1.3

% Subtract the mean from the data
Y = bsxfun(@minus, X, mean(X));

% Obtain the PCA solution by calculate the SVD of Y
[U, S, V] = svd(Y);

% Compute variance explained
rho = diag(S).^2./sum(diag(S).^2);
threshold = 0.90;

% Plot variance explained
mfig('NanoNose: Var. explained'); clf;
hold on
plot(rho, 'x-');
plot(cumsum(rho), 'o-');
plot([0,length(rho)], [threshold, threshold], 'k--');
legend({'Individual','Cumulative','Threshold'}, ...
        'Location','best');
ylim([0, 1]);
xlim([1, length(rho)]);
grid minor
xlabel('Principal component');
ylabel('Variance explained value');
title('Variance explained by principal components');

