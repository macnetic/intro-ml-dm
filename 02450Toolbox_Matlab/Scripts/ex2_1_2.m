%% exercise 2.1.2
% Data attributes to be plotted
i = 1;
j = 2;

% Make a simple plot of the i'th attribute against the j'th attribute
mfig('NanoNose: Data'); clf;
plot(X(:,i), X(:,j),'o');
axis tight

% Make another more fancy plot that includes legend, class labels, 
% attribute names, and a title
mfig('NanoNose: Classes'); clf; hold all; 
C = length(classNames);
% Use a specific color for each class (easy to reuse across plots!):
colors = get(gca, 'colororder'); 
% Here we the standard colours from MATLAB, but you could define you own.
for c = 0:C-1
    h = scatter(X(y==c,i), X(y==c,j), 50, 'o', ...
                'MarkerFaceColor', colors(c+1,:), ...
                'MarkerEdgeAlpha', 0, ...
                'MarkerFaceAlpha', .5);
end
% You can also avoid the loop by using e.g.: 
% gscatter(X(:,i), X(:,j), classLabels)
legend(classNames);
axis tight
xlabel(attributeNames{i});
ylabel(attributeNames{j});
title('NanoNose data');

