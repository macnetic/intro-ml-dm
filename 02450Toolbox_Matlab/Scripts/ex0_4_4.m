%% exercise 0.4.4

% Extracting the elements from vectors is easy. Consider the
% following definition of x and the echoed results
x = [zeros(1,2),linspace(0,3,6),ones(1,3)]
x(2:5) % take out elements 2 through 5 (inclusive)
size(x) % return the size of x (not equivalent to length(x))
length(x) % return the length of x 

% Try typing 'help length' and 'help size'

x(end) % take the last element of x
x(2:2:end) % return every other element of x starting from the 2nd

% Inserting numbers into vectors is also easy. Using the same
% definition of x and observe the results when typing
y = x;
y(2:2:end) = pi

% Notice that we're inserting the same scalar value "pi" into all elements 
% that we index y with

% You can also try:
%y(2:2:end) = 2:2:10

%Observe the results when indexing the vector y with
%y(1) and y(0). Is y(0) defined?