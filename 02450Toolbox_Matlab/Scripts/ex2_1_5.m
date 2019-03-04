%% exercise 2.1.5
% We saw in 2.1.3 that the first 3 components explaiend more than 90
% percent of the variance. Let's look at their coefficients:
pcs = 1:3; % change this to look at more/fewer, or compare e.g. [2,5]
mfig('NanoNose: PCA Component Coefficients');
h = bar(V(:,pcs));
legendCell = cellstr(num2str(pcs', 'PC%-d'));
legend(legendCell, 'location','best');
xticklabels(attributeNames);
grid
xlabel('Attributes');
ylabel('Component coefficients');
title('NanoNose: PCA Component Coefficients');

% Inspecting the plot, we see that the 2nd principal component has large
% (in magnitude) coefficients for attributes A, E and H. We can confirm
% this by looking at it's numerical values directly, too:
disp('PC2:')
disp(V(:,2)') % notice the transpose for display in console 

% How does this translate to the actual data and its projections?
% Looking at the data for water:

% Projection of water class onto the 2nd principal component.
all_water_data = Y(y==4,:);

disp('First water observation:')
disp(all_water_data(1,:))

% Based on the coefficients and the attribute values for the observation
% displayed, would you expect the projection onto PC2 to be positive or
% negative - why? Consider *both* the magnitude and sign of *both* the
% coefficient and the attribute!

% You can determine the projection by (remove comments):
disp('...and its projection onto PC2:')
disp(all_water_data(1,:) * V(:,2))
% Try to explain why?


