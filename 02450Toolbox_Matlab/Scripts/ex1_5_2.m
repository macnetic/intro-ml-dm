%% exercise 1.5.2
cdir = fileparts(mfilename('fullpath')); 

% Load the data into Matlab
% Type 'help xlsread' to learn how to use the function for reading Excel files into Matlab.
[NUMERIC, TXT, RAW] = xlsread(fullfile(cdir,'../Data/iris.xls'));

% By default 'xlsread' only reads numeric cells.
% Using the syntax [NUMERIC,TXT,RAW]=xlsread(FILE) you can get both 
% the numeric data, text data, and raw data as a cell array.

% Extract the rows and columns corresponding to the data
X = NUMERIC(2:end,1:4); 
% You can use indexing to get submatrices of the returned matrices, 
% here we ignore the header row of the file (which is NaNs in NUMERIC),
% which we do by starting from row number 2, and we extract the attributes 
% that we not are stored in columns 1 to 4.

% Extract attribute names from the first row
attributeNames = RAW(1,1:4)';
% We transpose to have it fit the standard representation
% that you saw in the exercise description (size M x 1)

% Extract unique class names from the last column
classLabels = RAW(2:end,end);
classNames = unique(classLabels);

% Extract class labels that match the class names
[~,y] = ismember(classLabels, classNames); y = y-1;

[N, M] = size(X);
C = length(classNames);

% Clean up the workspace
clearvars cdir NUMERIC RAW TXT
 