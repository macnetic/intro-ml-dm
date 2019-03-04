%% exercise 1.5.4
% Start by running the exercise 1.5.3 to load the Iris data in
% "classification format":
run([pwd(), '/ex1_5_3.m'])
% remember to set your working direction to the Scripts folder

%% Classification problem
% The current variables X and y represent a classification problem, in
% which a machine learning model will use the sepal and petal dimesions
% (stored in the matrix X) to predict the class (species of Iris, stored in
% the variable y). A relevant figure for this classification problem could
% for instance be one that shows how the classes are distributed based on
% two attributes in matrix X:
X_c = X;
y_c = y;
attributeNames_classification = attributeNames;
i = 1; j = 2;
mfig('Iris classification problem')
% If you get an error: "Undefined function or variable 'mfig', you have to
% remember to run the setup.m file in the root of the toolbox!
gscatter(X_c(:,i), X_c(:,j), ...
         classNames(y_c+1)); 
axis equal; 
xlabel(attributeNames_classification{i});
ylabel(attributeNames_classification{j});
% Consider, for instance, if it would be possible to make a single line in
% the plot to delineate any two groups? Say, can you draw a line between
% the Setosas and the Versicolors? The Versicolors and the Virginicas?

%% Regression problem
% Since the variable we wish to predict is petal length,
% petal length cannot any longer be in the data matrix X.
% The first thing we do is store all the information we have in the
% other format in one data matrix:
data = [X_c, y_c];

% We know that the petal length corresponds to the third column in the data
% matrix (see attributeNames), and therefore our new y variable is:
y_r = data(:, 3);

% Similarly, our new X matrix is all the other information but without the 
% petal length (since it's now the y variable):
X_r = data(:, [1, 2, 4, 5]);

% Since the iris class information (which is now the last column in X) is a
% categorical variable, we will do a one-out-of-K encoding of the variable:
species = X_r(:, end);
species_encoding = bsxfun(@eq, species, 0:max(species));
% The encoded information is now a 150x3 matrix. This corresponds to 150
% observations, and 3 possible species. For each observation, the matrix
% has a row, and each row has two 0s and a single 1. The placement of the 1
% specifies which of the three Iris species the observations was.
% The way the bsxfun works is that it applies the operation '@eq' to each
% element in the two matrices that follow in the call. Here we use the
% logical equal comparison to see whether the value of species is equal to
% each element in 0:max(species), which is just the vector [0, 1, 2]. 
% Therefore, the bsxfun for e.g. species(75), which is a 1, will return
% the row [false, true, false], or [0, 1, 0]. 

% We need to replace the last column in X (which was the not encoded
% version of the species data) with the encoded version:
X_r = [X_r(:, [1:end-1]), species_encoding];

% Now, X is of size 150x6 corresponding to the three measurements of the
% Iris that are not the petal length as well as the three variables that
% specifies whether or not a given observations is or isn't a certain type.
% We need to update the attribute names and store the petal length name 
% as the name of the target variable for a regression:
targetName_regression = attributeNames_classification(3);
attributeNames_regression = ...
    vertcat(attributeNames_classification([1, 2, 4]), classNames);

% Lastly, we update M, since we now have more attributes:
[N,M] = size(X_r);

% A relevant figure for this regression problem could
% for instance be one that shows how the target, that is the petal length,
% changes with one of the predictors in X:
i = 3;  
mfig('Iris regression problem')
plot(X_r(:,i), y_r, 'o')
xlabel(attributeNames_regression{i});
ylabel(targetName_regression);
% Consider if you see a relationship between the predictor variable on the
% x-axis (the variable from X) and the target variable on the y-axis (the
% variable y). Could you draw a straight line through the data points for
% any of the attributes (choose different i)? 
% Note that, when i is 4, 5, or 6, the x-axis is based on a binary 
% variable, in which case a scatter plot is not as such the best option for 
% visulizing the information. 

