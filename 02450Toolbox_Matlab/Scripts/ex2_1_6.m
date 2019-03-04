%% exercise 2.1.6
mfig('NanoNose: Attribute standard deviations'); clf; hold all; 
bar(1:size(X,2), std(X));
xticks(1:size(X,2))
xticklabels(attributeNames);
ylabel('Standard deviation')
xlabel('Attributes')
title('NanoNose: attribute standard deviations')

%% Investigate how standardization affects PCA
% Try this *later*, and explain the effect:
%X(:,3) = 100*X(:,3); % Multiply C with a factor 100

% Subtract the mean from the data
Y1 = bsxfun(@minus, X, mean(X));

% Subtract the mean from the data and divide by the attribute standard
% deviation to obtain a standardized dataset:
Y2 = bsxfun(@minus, X, mean(X));
Y2 = bsxfun(@times, Y2, 1./std(X));
% The formula in the exercise description corresponds to:
%Y2 = (X - ones(size(X,1),1)*mean(X) ) * diag(1./std(X))
% But using bsxfun is a bit cleaner and works better for large X.

% Store the two in a cell, so we can just loop over them:
Ys = {Y1, Y2};
titles = {'Zero-mean', 'Zero-mean and unit variance'};

% Choose two PCs to plot (the projection)
i = 1;
j = 2;

% Make the plot
mfig('NanoNose: Effect of standardization'); clf; hold all; 
nrows=3; ncols=2;
for k = 0:1
    % Obtain the PCA solution by calculate the SVD of either Y1 or Y2
    [U, S, V] = svd(Ys{k+1},'econ');
    
    % For visualization purposes, we flip the directionality of the
    % principal directions such that the directions match for Y1 and Y2.
    if k==1; V = -V; U = -U; end;
    
    % Compute variance explained
    rho = diag(S).^2./sum(diag(S).^2);
    
    % Compute the projection onto the principal components
    Z = U*S;
    
    % Plot projection
    subplot(nrows, ncols, 1+k)
        C = length(classNames);
        hold on
        colors = get(gca,'colororder');
        for c = 0:C-1
            scatter(Z(y==c,i), Z(y==c,j), 50, 'o', ...
                    'MarkerFaceColor', colors(c+1,:), ...
                    'MarkerEdgeAlpha', 0, ...
                    'MarkerFaceAlpha', .5);
        end
        xlabel(sprintf('PC %d', i)); 
        ylabel(sprintf('PC %d', j));
        axis equal
        title(sprintf( [titles{k+1}, '\n', 'Projection'] ) )
        % Add a legend to one of the plots (but not both):
        if k; h = legend(classNames, 'Location', 'best', 'color', 'none'); end;

    % Plot attribute coefficients in principal component space
    subplot(nrows, ncols,  3+k);
        z = zeros(1,size(V,2))';
        quiver(z,z,V(:,i), V(:,j), 1, ...
               'Color', 'k', ...
                'AutoScale','off', ...
               'LineWidth', .1)
        hold on
        for pc=1:length(attributeNames)
            text(V(pc,i), V(pc,j),attributeNames{pc}, ...
                 'FontSize', 10)
        end
        xlabel('PC1')
        ylabel('PC2')
        grid; box off; axis equal;
        % Add a unit circle
        plot(cos(0:0.01:2*pi),sin(0:0.01:2*pi));
        title(sprintf( [titles{k+1}, '\n', 'Attribute coefficients'] ) )
        axis tight
        
    % Plot cumulative variance explained
    subplot(nrows, ncols,  5+k);
        plot(cumsum(rho), 'x-');
        ylim([.6, 1]); 
        xlim([1, size(V,2)]);
        grid minor
        xlabel('Principal component');
        ylabel('Cumulative variance explained')
        title(sprintf( [titles{k+1}, '\n', 'Variance explained'] ) )
        grid
        box off
end
         