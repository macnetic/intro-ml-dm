%% exercise 1.5.1
% We start by determing the path to the data that we want to load.
% We can do this relative to the current script, by determining the
% path to the current script first:
cdir = fileparts(mfilename('fullpath'));
% Next, we know that the data is stored in the Data folder within the 
% 02450Toolbox_Matlab. Since this script is within a folder called Scripts
% within the toolbox, we first go up one level (using '..'), and then enter
% the Data-folder:
file_path = fullfile(cdir,'../Data/iris.csv');

% >>Notice!<<
% If you try to tun this command using e.g. F9 or CTRL/CMD+Enter,
% the cdir will not be the folder where the scripts are stored, and the 
% file_path will be incorrect. For this to work, run the script using 'Run'
% (or using F5).

% Load the data into matlab using readtable. Type 'help readtable' to see 
% more on how the function works. 
iris_table = readtable(file_path);
% iris_table is in table format, which could be used for working with the 
% data, but we will use a slightly different format in this course.
% Therefore, we need to extract the various informations we need to store
% in the variables X, y, M, N, C, attributeNames, and classNames (see the
% standard representation as described in the exercise document).
% We get a warning because the header contains spaces - which isn't really
% an issue.

% Extract the rows and columns corresponding to the flower dimensions:
X = table2array(iris_table(:, 1:4)); 

% Extract attribute names from the loaded table
attributeNames = iris_table.Properties.VariableNames(1:4)';

% Extract unique class names from the first row
classLabels = table2cell(iris_table(:,5)); 
classNames = unique(classLabels);

% Extract class labels that match the class names
[~,y] = ismember(classLabels, classNames);
% Using '~' ignores an output. Try writing 'help ismember'. Here, we use
% the output that the doc calls LOCB to determine to which class name each
% class label in classLabels corresponds. Since classLabels(75) is an
% 'Iris-versicolor', we could call:
%[~, b] = ismember(classLabels(75), classNames)
% to see that classLabels(1) corresponds to b=2, and therefore the second
% class name in classNames.
% Since we want to assign numerical values to the classes starting from a
% zero and not a one, we subtract one to the get final y:
y = y-1;

% Lastly, we determine the number of attributes M, the number of
% observations N and the number of classes C:
[M, N] = size(X);
C = length(classNames);
 