%% exercise 0.4.5
% Setup two matrices
x = 1:5
y = 2:2:10
% Have a look at them by typing 'x' and 'y' in the console.

% There's a difference between matrix multiplication and elementwise 
% multiplication:
y'              % transposition/transpose of y
transpose(y)    % also transpose

x.*y            % element-wise multiplication
times(x,y)      % also element-wise multiplication

x*y'            % matrix multiplication
mtimes(x,y')    % also matrix multiplication

% In general, the . operator (as in .*) means element-wise operations

% There are various ways to make certain type of matrices.
a1 = [1, 2, 3; 4, 5, 6]         % define explicitly
a2 = reshape(1:6, [2,3])        % reshape range of numbers
a3 = zeros(3,3)                 % zeros array
a4 = eye(3)                     % diagonal array
a5 = rand(2,3)                  % random array (uniformly random from [0,1])
a6 = a1                         % copy (changing a1 wont change a6)


% It is easy to extract and/or modify selected items from matrices. 
% Here is how you can index matrix elements:
m = [1, 2, 3; 4, 5, 6; 7, 8, 9]
m(1,1)      % first element
m(end,end)  % last element
m(1,:)      % first row
m(:,2)      % second column
m(2:3, end)	% specific rows in specific 


% Similarly, you can selectively assign values to matrix elements or columns:
m(end, end) = 10000
m(1:2,end) = [100,1000]
m(:,1) = 0

% Logical indexing can be used to change or take only elements that 
% fulfil a certain constraint, e.g.
a5(a5>0.5)          % display values in m2 that are larger than 0.5
a5(a5<0.5) = 0      % set all elements that are less than 0.5 to 0 

% Below, several examples of common matrix operations, 
% most of which we will use in the following weeks.
% First, define two matrices:
m1 = 10 * ones(3,3) 
m2 = rand(3,3)

m1+m2               % matrix summation
m1*m2               % matrix product
m1.*m2              % element-wise multiplication
m1>m2               % element-wise comparison
m3 = [m1,m2]        % combine/concatenate matrices horizontally (also horzcat)
m4 = [m1;m2]        % combine/concatenate matrices vertically (also vertcat)
size(m3)            % shape of matrix
mean(m3(:))         % mean value of all elements
mean(m3, 1)         % mean values of the columns
mean(m3, 2)         % mean values of the rows
m3'                 % transpose 
inv(m2)             % inverse matrix


% MATLAB also has linear indexing, such that e.g. these are the same:
m(1,2) 
m(4) 
% here the index 4 means that the element (1,2) in the matrix is the same
% as the fourth element when counting by starting in the first column 
% going through all the rows, and then starting at the next column
% For more info, try to understand what i and k are in:
% [i,k] = ind2sub(size(m), 4)



