% exercise 4.3.2

% Load Matlab data file and extract variables of interest
mat_data = load('../Data/wine.mat')

%%
X = mat_data.X;
y = mat_data.y;
C = mat_data.C;
M = mat_data.M;
classNames = mat_data.classNames;
attributeNames = mat_data.attributeNames;
%%
    
% The histograms show that there are a few very extreme values in these
% three attributes. To identify these values as outliers, we must use our
% knowledge about the data set and the attributes. Say we expect volatide
% acidity to be around 0-2 g/dm^3, density to be close to 1 g/cm^3, and
% alcohol percentage to be somewhere between 5-20 % vol. Then we can safely
% identify the following outliers, which are a factor of 10 greater than
% the largest we expect.
outlier_mask = (X(:,1)>20) | (X(:,7)>200) | (X(:,11)>200);
valid_mask = ~outlier_mask;

% Finally we will remove these from the data set
X = X(valid_mask,:);
y = y(valid_mask,:);
N = length(y);
Xnorm = zscore(X);

Attributes = [1,4,5,6];
NumAtr = length(Attributes);

figure('Units','Centimeter','Position',[8,8,20,20])
for m1=1:NumAtr
    for m2=1:NumAtr
        subplot(NumAtr, NumAtr, (m1-1)*NumAtr + m2); hold all; 
        for c=1:C
            class_mask = y == (c-1);
            plot(X(class_mask,Attributes(m2)), X(class_mask,Attributes(m1)), '.');
            if m1==NumAtr
                xlabel(attributeNames(Attributes(m2)))
            else
                set(gca,'xtick',[])
            end
            if m2==1
                ylabel(attributeNames(Attributes(m1)))
            else
                set(gca,'ytick',[])
            end
        end
    end
end
legend(classNames)