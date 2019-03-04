%% exercise 1.5.3
% Load the data into Matlab
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/iris.mat'));

% Since the .mat file already contained the correct formats of the
% variables, we don't need to do further work. This is of course likely not
% the case for your own dataset. The iris.mat file was made by running the
% script ex1_5_2.m and then saving the workspace using save('iris.mat'). 
