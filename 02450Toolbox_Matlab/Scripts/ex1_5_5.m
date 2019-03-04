%% exercise 1.5.5
% We start by defining the path to the file that we're we need to load.
% Upon inspection, we saw that the messy_data.data was infact a file in the
% format of a CSV-file with a ".data" extention instead. So we renamed the
% file to be a .csv-file. If you haven't done this, go ahead and make a
% copy of the .data-file which has the extension .csv instead. 
file_path = fullfile(pwd(),'../Data/messy_data/messy_data.csv');
% Once again, here we assume your pwd is the Scripts-folder (you can
% right-click on the tab in the editor and change it to its placement).

% First of we simply read the file in using readtable
messy_data = readtable(file_path);

%%
% Inspection of messy_data at this point shows that readtable correctly
% identifies a header with the variable names. It fails to identify a
% headerline of short forms of the variable names that was included in the
% data, so we skip the first row of the loaded data:
messy_data = messy_data(2:end, :);

% We extract the attribute names:
attributeNames = messy_data.Properties.VariableNames;
% As we progress through this script,messy_data we might change which attributes are
% stored where. For simplicity in presenting the processing steps, we wont
% keep track of those changes in attributeNames in this example script.

% We convert the table to an array of cells for making some operations
% easier to follow:
messy_data = table2array(messy_data);

%%
% The last column is a unique string for each observation defining the
% car make and model. We decide to extract this in a variable for itself
% for now, and then remove it from the array:
car_names = messy_data(:,end);
messy_data = messy_data(:, 1:end-1);

%%
% If we inspect messy_data we see that some formatting issues needs to be
% handled. We can do this programatically using cellfun and the function
% regexprep. The cellfun applies the function to each element in a supplied
% array, and regexprep simply replaces a certain expression in a given
% string with another expression. 

% First off, we remove the question marks in the third column and replace
% them with the MATLAB naming convention for not a number, NaN:
messy_data(:,3) = cellfun(@(x) regexprep(x, "?", "NaN"), messy_data(:,3), ...
                          'UniformOutput', false);
% Similarly, we remove the formatting for a thousand seperator that is
% present in column five:
messy_data(:,5) = cellfun(@(x) regexprep(x, "'", ""), messy_data(:,5), ...
                          'UniformOutput', false);
% And lastly, we replace all the commas that were used as decimal seperatos
% in column 6 with dots:
messy_data(:,6) = cellfun(@(x) regexprep(x, ",", "."), messy_data(:,6), ...
                          'UniformOutput', false);

% We also see that some parts of the messy_data simply has nothing in them,
% but the creators of the dataset did not include a question mark to
% highlight it. For these, we find the empty cells and replace their values
% with a NaN:
idx = cellfun(@isempty, messy_data(:,3));
messy_data(idx, 3) = {'NaN'};

% Now we use cellfun again, but this time - instead of regexprep - we use
% the funtion str2num which converts a string (or text) to a number:
data = cellfun(@str2num, messy_data);

% data has some zero values that the README.txt tolds us were missing
% values - this was specifically for the attributes mpg and displacement,
% so we're careful only to replace the zeros in these attributes, since a
% zero might be correct for some other variables:
data(data(:,1) == 0, 1) = NaN;
data(data(:,3) == 0, 3) = NaN;

% We later on find out that a value of 99 for the mpg is not value that is
% within reason for the MPG of the cars in this dataset. The observations
% that has this value of MPG is therefore incorrect, and we should treat
% the value as missing. How would you add a line of code to this data
% cleanup script to account for this information?

%% X,y-format
% If the modelling problem of interest was a classification problem where
% we wanted to classify the origin attribute, we could now identify obtain
% the data in the X,y-format as so:
X_c = data(:, 1:end-1);
y_c = data(:, end);

% However, if the problem of interest was to model the MPG based on the
% other attributes (a regression problem), then the X,y-format is
% obtained as:
X_r = data(:, 2:end);
y_r = data(:, 1);
% Since origin is categorical variable, we can do as in previos exercises
% and do a one-out-of-K encoding:
origin = X_r(:, end) - 1;% subtract so the numbering starts from 0
origin_encoding = bsxfun(@eq, origin, 0:max(origin)); 
X_r = [X_r(:, [1:end-1]), origin_encoding];
% Since the README.txt doesn't supply a lot of information about what the
% levels in the origin variable mean, you'd have to either make an educated
% guess based on the values in the context, or preferably obtain the
% information from any papers that might be references in the README.
% In this case, you can inspect origin and car_names, to see that (north)
% american makes are all value 0 (try looking at car_names(origin == 0),
% whereas origin value 1 is European, and value 2 is Asian.

%% Missing values
% In the above X,y-matrices, we still have the missing values. In the
% following we will go through how you could go about handling the missing
% values before making your X,y-matrices.

% Once we have identified all the missing data, we have to handle it
% some way. Various apporaches can be used, but it is important
% to keep it mind to never do any of them blindly. Keep a record of what
% you do, and consider/discuss how it might affect your modelling.

% The simplest way of handling missing values is to drop any records 
% that display them, we do this by first determining where there are
% missing values:
missing_idx = isnan(data);
% Observations with missing values have a row-sum in missing_idx
% which is greater than zero:
obs_w_missing = sum(missing_idx, 2) > 0;
data_drop_missing_obs = data(~obs_w_missing, :);
% This reduces us to 15 observations of the original 29.

% Another approach is to first investigate where the missing values are.
% A quick way to do this is to visually look at the missing_idx:
mfig('Visual inspection of missing values');
imagesc(missing_idx); xlabel('Observations'); ylabel('Attributes');

% From such a plot, we can see that the issue is the third column, the
% displacement attribute. This can be confirmed by e.g. doing:
%sum(missing_idx, 1)
% which shows that 12 observations are missing a value in the third column. 
% Therefore, another way to move forward is to disregard displacement 
% (for now) and remove the attribute. We then remove the few
% remaining observations with missing values:
cols = logical(ones(1, size(data, 2)));
cols(3) = false;
data_wo_displacement = data(:, cols); 
obs_w_missing_wo_displacement = sum(isnan(data_wo_displacement),2)>0;
data_drop_disp_then_missing = data(~obs_w_missing_wo_displacement, :);
% Now we have kept all but two of the observations. This however, doesn't
% necesarrily mean that this approach is superior to the previous one,
% since we have now also lost any and all information that we could have
% gotten from the displacement attribute. 

% One could impute the missing values - "guess them", in some
% sense - while trying to minimize the impact of the guess.
% A simply way of imputing them is to replace the missing values
% with the median of the attribute. We would have to do this for the
% missing values for attribute 1 and 3:
data_imputed = data;
for att = [1:3]
     % We use nanmedian to ignore the nan values
    impute_val = nanmedian(data(:, att));
    idx = missing_idx(:, att);
    data_imputed(idx, att) = impute_val;
end

% Note, you can change the format between 'format long' and 'format bank'
% to change how the Command Window displays numerical values.
