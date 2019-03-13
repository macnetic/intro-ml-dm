%% Project 2 - 02450 Introduction to Machine Learning and Data Mining
%#########################################%
%##   This script only works in 2018b   ##%
%##   It will probably not function     ##%
%##   completely in earlier versions.   ##%
%##                                     ##%
%##   The course toolbox for Matlab     ##%
%##   must be installed for the         ##%
%##   script to work.                   ##%
%#########################################%

clc; clear; close all;

%Path to the dataset
My_mfilename = mfilename('fullpath');
cdir = fileparts(cd());
% Path to the file
file_path = fullfile(cd(), 'flags/flag-data.csv');
% Load the data
flag_table = readtable(file_path);

AttributeNames = {'name' 'landmass' 'zone' 'area' 'population' 'language' 'religion' 'bars' 'stripes' 'colours' 'red' 'green' 'blue' 'gold' 'white' 'black' 'orange' 'mainhue' 'circles' 'crosses' 'saltires' 'quarters' 'suns/stars' 'crescent moon' 'triangle' 'icon' 'animate' 'text' 'topleft' 'botright'};

Num4_5 = table2array(flag_table(:, 4:5)); 
Num8_10 = table2array(flag_table(:, 8:10));
Bin11_17 = table2array(flag_table(:, 11:17));
Num19_28 = table2array(flag_table(:, 19:28));


% Convert string columns in X to numeric values
V18 = stringArray2num(string(table2array(flag_table(:, 18))));
V29 = stringArray2num(string(table2array(flag_table(:, 29))));
V30 = stringArray2num(string(table2array(flag_table(:, 30))));

% convert discrete values to '1 out of k' values
%A is Assumed 1D with the same attribute in a column
K02 = OneOutOfKCoding(table2array(flag_table(:, 2)));   % continent/landmass
K03 = OneOutOfKCoding(table2array(flag_table(:, 3)));   % zone 1=NE, 2=SE, 3=SW, 4=NW
K06 = OneOutOfKCoding(table2array(flag_table(:, 6)));   % language
K07 = OneOutOfKCoding(table2array(flag_table(:, 7))+1); % religion
K18 = OneOutOfKCoding(V18);                             % Mainhue
K29 = OneOutOfKCoding(V29);                             % Top left color
K30 = OneOutOfKCoding(V30);                             % bottom right color

% Join arrays back together:
JoinedData = horzcat(K02,K03,Num4_5,K06,K07,Num8_10,Bin11_17,K18,Num19_28,K29,K30);

% Normalize the data
%for '1 out of k' divide the rows by sqrt(k)
S02 = (K02-mean(K02))./sqrt(length(K02(1,:)));
S03 = (K03-mean(K03))./sqrt(length(K03(1,:)));
S06 = (K06-mean(K06))./sqrt(length(K06(1,:)));
S07 = (K07-mean(K07))./sqrt(length(K07(1,:))); 
S18 = (K18-mean(K18))./sqrt(length(K18(1,:)));
S29 = (K29-mean(K29))./sqrt(length(K29(1,:)));
S30 = (K30-mean(K30))./sqrt(length(K30(1,:)));
%for all other attributes divide by the standard deviation of the attribute
S4_5   = (Num4_5-mean(Num4_5))./std(Num4_5);
S8_10  = (Num8_10-mean(Num8_10))./std(Num8_10);
S11_17 = (Bin11_17-mean(Bin11_17))./std(Bin11_17);
S19_28 = (Num19_28-mean(Num19_28))./std(Num19_28);

StandardizedData = horzcat(S02,S03,S4_5,S06,S07,S8_10,S11_17,S18,S19_28,S29,S30);
% %%
% clc
% B = table([45;41;40],[45;32;34],{'NY';'CA';'MA'},'VariableNames',{'Height' 'Weight' 'Birthplace'},'RowNames',{'Percy' 'Gordon' 'Thomas'})

% SVD - Singular Value Decomposition
PCAData = horzcat(S03,S4_5,S07,S8_10,S11_17,S18,S19_28,S29,S30);%S02,S06
AData = horzcat(S02,S03,S4_5,S06,S07,S8_10,S11_17,S18,S19_28,S29,S30);
[U,S,V] = svd(PCAData);

eigVals = diag(S);
eigVecs = U;
Principaldirections = V;

% Normalized magnitude of the PC's
rho = diag(S).^2./sum(diag(S).^2);

%% Regression A

%% Regression B

%% Classification




