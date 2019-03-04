%% exercise 2.1.4

% Index of the principal components
i = 1;
j = 2;

% Compute the projection onto the principal components
Z = U*S;

% Plot PCA of data
mfig('NanoNose: PCA Projection'); clf; hold all; 
C = length(classNames);
colors = get(gca,'colororder');
for c = 0:C-1
    scatter(Z(y==c,i), Z(y==c,j), 50, 'o', ...
                'MarkerFaceColor', colors(c+1,:), ...
                'MarkerEdgeAlpha', 0, ...
                'MarkerFaceAlpha', .5);
end
legend(classNames);
axis tight
xlabel(sprintf('PC %d', i));
ylabel(sprintf('PC %d', j));
title('PCA Projection of NanoNose data');