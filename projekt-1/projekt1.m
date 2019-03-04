% Set working directory to scripts folder
clc; clear; close all;

%Path to the dataset
My_mfilename = mfilename('fullpath');
cdir = fileparts(cd());
% Path to the file
file_path = fullfile(cd(), '/flags/flag-data.csv');
%Load the data
flag_table = readtable(file_path);

AttributeNames = ["name" "landmass" "zone" "area" "population" "language" "religion" "bars" "stripes" "colours" "red" "green" "blue" "gold" "white" "black" "orange" "mainhue" "circles" "crosses" "saltires" "quarters" "suns/stars" "crescent moon" "triangle" "icon" "animate" "text" "topleft" "botright"];

Num4_5 = table2array(flag_table(:, 4:5)); 
Num8_10 = table2array(flag_table(:, 8:10));
Bin11_17 = table2array(flag_table(:, 11:17));
Num19_28 = table2array(flag_table(:, 19:28));


%% Convert string columns in X to numeric values
% column18 = table2array(flag_table(:, 18));
% column29 = table2array(flag_table(:, 29));
% column30 = table2array(flag_table(:, 30));
% V18 = stringArray2num(string(column18));
% V29 = stringArray2num(string(column29));
% V30 = stringArray2num(string(column30));
V18 = stringArray2num(string(table2array(flag_table(:, 18))));
V29 = stringArray2num(string(table2array(flag_table(:, 29))));
V30 = stringArray2num(string(table2array(flag_table(:, 30))));

%% convert discrete values to '1 out of k' values
%A is Assumed 1D with the same attribute in a column
clc
K02 = OneOutOfKCoding(table2array(flag_table(:, 2)));   % continent/landmass
K03 = OneOutOfKCoding(table2array(flag_table(:, 3)));   % zone 1=NE, 2=SE, 3=SW, 4=NW
K06 = OneOutOfKCoding(table2array(flag_table(:, 6)));   % language
K07 = OneOutOfKCoding(table2array(flag_table(:, 7))+1); % religion
K18 = OneOutOfKCoding(V18);                             % Mainhue
K29 = OneOutOfKCoding(V29);                             % Top left color
K30 = OneOutOfKCoding(V30);                             % bottom right color
%% Join arrays back together:

JoinedData = horzcat(K02,K03,Num4_5,K06,K07,Num8_10,Bin11_17,K18,Num19_28,K29,K30);
%% Normalize the data

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

S11_17 = (Bin11_17-mean(Bin11_17))./std(Bin11_17);%./sqrt(2)%
S19_28 = (Num19_28-mean(Num19_28))./std(Num19_28);


StandardizedData = horzcat(S02,S03,S4_5,S06,S07,S8_10,S11_17,S18,S19_28,S29,S30);
% %%
% clc
% B = table([45;41;40],[45;32;34],{'NY';'CA';'MA'},'VariableNames',{'Height' 'Weight' 'Birthplace'},'RowNames',{'Percy' 'Gordon' 'Thomas'})

%% SVD - Singular Value Decomposition
PCAData = horzcat(S03,S4_5,S07,S8_10,S11_17,S18,S19_28,S29,S30);%S02,S06
AData = horzcat(S02,S03,S4_5,S06,S07,S8_10,S11_17,S18,S19_28,S29,S30);
[U,S,V] = svd(PCAData);

eigVals = diag(S);
eigVecs = U;
Principaldirections = V;

% Normalized magnitude of the PC's
rho = diag(S).^2./sum(diag(S).^2);

%% Plot of percentage described by Principal Components
AcumulatedPC = zeros(1,length(rho)+1);
%%

AcumulatedPC(1) = 0;
AcumulatedPC(2) = rho(1);
for i = 3 : length(rho)+1
    AcumulatedPC(i) = AcumulatedPC(i-1)+rho(i-1);
end
%%
%close all;
%clc;
figure(1)
hold on
AcumulatedPCx_axis = 0:length(AcumulatedPC)-1;

% Doesn't work in MATLAB R2017a
% yline(0.5,'k:','50%','LabelVerticalAlignment','middle','FontSize',18,'HandleVisibility','off');
% yline(0.80,'k:','80%','LabelVerticalAlignment','middle','FontSize',18,'HandleVisibility','off');
% yline(0.95,'k:','95%','LabelVerticalAlignment','bottom','FontSize',18,'HandleVisibility','off');
% yline(0.975,'k:','97.5%','LabelVerticalAlignment','middle','FontSize',18,'HandleVisibility','off');

% H1 = area(AcumulatedPCx_axis,AcumulatedPC,'FaceColor',[0 0 0]);

% 0.975 and above:
    idx975 = find(AcumulatedPC>.975,1);
    APCx975 = AcumulatedPCx_axis(idx975:length(AcumulatedPCx_axis));
    APCy975 = AcumulatedPC(idx975:length(AcumulatedPC));
    H975 = area(APCx975,APCy975,'FaceColor',[.9 .9 .9],'HandleVisibility','off');
% 0.500 and bellow
    idx5 = find(AcumulatedPC>.5,1);
    area(0:idx5-1,AcumulatedPC(1:idx5),'FaceColor',[.7 .7 .7],'HandleVisibility','off');
    
% 0.500 to 0.800
    idx8 = find(AcumulatedPC>.8,1);
    area(idx5-1:idx8-1,AcumulatedPC(idx5:idx8),'FaceColor',[.75 .75 .75],'HandleVisibility','off');
% 0.800 to 0.950
    idx95 = find(AcumulatedPC>.95,1);
    area(idx8-1:idx95-1,AcumulatedPC(idx8:idx95),'FaceColor',[.8 .8 .8],'HandleVisibility','off');
% 0.950 to 0.975
    area(idx95-1:idx975-1,AcumulatedPC(idx95:idx975),'FaceColor',[.85 .85 .85],'HandleVisibility','off');
% Strings:
    s5 = "Describes at least 50% with " + (idx5-1) + " PC's";
    s8 = "Describes at least 80% with " + (idx8-1) + " PC's";
    s95 = "Describes at least 95% with " + (idx95-1) + " PC's";
    s975 = "Describes at least 97.5% with " + (idx975-1) + " PC's";
% Text display:
%   text(idx5,AcumulatedPC(idx5),s5,'FontSize',14)%'vert','bottom','horiz','center',
%   text(idx8,AcumulatedPC(idx8),s8)
% 	text(idx95,AcumulatedPC(idx95),s95)
% 	text(idx975,AcumulatedPC(idx975),s975)
    annotation('textarrow',[.25,.21],[0.5,.565],'String',s5,'FontSize',20)
    annotation('textarrow',[.35,.30],[0.722,.783],'String',s8,'FontSize',20)
    annotation('textarrow',[.42,.377],[0.83,.887],'String',s95,'FontSize',20)
    annotation('textarrow',[.45,.403],[0.87,.905],'String',s975,'FontSize',20)
    
% PC sum plot:
    plot(AcumulatedPCx_axis,AcumulatedPC,'bo-','LineWidth',1,'MarkerSize',10);
% PC plot:
    plot(rho,'rx-','LineWidth',1,'MarkerSize',10)

grid on
xlabel('Number of Principal Components')
ylabel("Accumulated % of \sigma described by PC's")
legend("Accumulative sum of PC's","Magnitude of PC's",'location','southeast')
hold off

%% Quantiles, mean & variance:
%clc;
summary_statistics_extract = [4 5 8 9 10 19 20 21 22 23];
summary_statistics = zeros(length(summary_statistics_extract),9);%output
temp_data = zeros(length(summary_statistics_extract)   ,   length(table2array(flag_table(:, summary_statistics_extract(1))))); 
for i = 1 : length(summary_statistics_extract)
    temp_data(i,:)= table2array(flag_table(:, summary_statistics_extract(i)));%% TODO: elementsize mismatch
end

for i = 1 : length(temp_data(:,1)) %for all attributes:
    summary_statistics(i,:) = horzcat(mean(temp_data(i,:)),std(temp_data(i,:)),quantile(temp_data(i,:),[0.0 0.025 0.25 0.50 0.75 0.975 1.0]));
end %= [1 2 3 4 5 6 7 8 9]%
% summary_statistics
% Area
% Population
% Bars
% Stripes
% circles
% crosses
% saltires
% quarters
% sunstars

%% Color percentage appereance of color as Mainhue
colorSum = sum(K18,1);
% colorLabels = {'green','red','blue','gold','white','black','brown','orange'};
colormeans = colorSum./sum(colorSum);
set(0,'defaultAxesFontSize',24);
MyColors = categorical({'red','blue','green','white','gold','black','orange','brown'});
MyColors = reordercats(MyColors,{'red','blue','green','white','gold','black','orange','brown'});
MyColorsAndPercent = sort(round(colormeans*100,2),'descend'); % [36.6 20.62 15.98 11.34 9.79 2.58 2.06 1.03];
%close(2);
figure(2)
hold on
grid on
%title('Percent distribution of Mainhue');
bar(MyColors,MyColorsAndPercent,'b')
bar(categorical({'red'}),MyColorsAndPercent(1),'r')
bar(categorical({'blue'}),MyColorsAndPercent(2),'b')
bar(categorical({'green'}),MyColorsAndPercent(3),'g')
bar(categorical({'white'}),MyColorsAndPercent(4),'w')
bar(categorical({'gold'}),MyColorsAndPercent(5),'y')
bar(categorical({'black'}),MyColorsAndPercent(6),'k')
bar(categorical({'orange'}),MyColorsAndPercent(7),'FaceColor', [1.0 .55 .0])
bar(categorical({'brown'}),MyColorsAndPercent(8),'FaceColor', [.545098 .270588 .07451])
text(1:length(MyColorsAndPercent),MyColorsAndPercent,num2str(MyColorsAndPercent'),'vert','bottom','horiz','center','FontSize',24); 
xlabel('Mainhue categories')
ylabel('% of flags with colour as mainhue')
hold off

%% Procent af flag der har en given farve i sig:
% Attributes 11 - 17 in the dataset describe whether a colour is present or
% not on a flag.
Num11_17 = table2array(flag_table(:,11:17));
color_proportions = mean(Num11_17, 1);
[color_proportions, I] = sort(color_proportions, 'descend');

colors = {'Red', 'Green', 'Blue', 'Gold/Yellow', 'White', 'Black', 'Orange/Brown'};
color_categories = categorical(colors(I), colors(I));

figure(4);
hold on;
grid on;
color_codes = {'r', 'w', 'b', 'g', 'y', 'k', [1.0 .55 .0]};
for i = 1:length(colors)
    bar(color_categories(i), color_proportions(i)*100, 'FaceColor', color_codes{i});    
end
hold off
text(1:length(color_proportions),color_proportions*100,num2str(color_proportions'*100),'vert','bottom','horiz','center','FontSize',24); 
xlabel('Color');
ylabel('% of flags using color');
ylim([0 100]);

%% Histogram for outlier detection and distribution test:
HistPlotVector = [5 6 15 16 17 33 34 35 36 37]
HistLegendxAxis = ["Area" "Population" "Bar" "Stripes" "Colours" "Circles" "Crosses" "Saltires" "Quarters" "Suns/Stars"]
figure
for i = 1 : length(HistPlotVector)
    subplot(2,5,i)
    hold on
    grid on
    histogram(PCAData(:,HistPlotVector(i)))
    xlabel(HistLegendxAxis(i))
    hold off
end

%% Measures of similarity:

% SMC
sim_smc = zeros(size(JoinedData, 2));
for i = 1:size(JoinedData,2)
    for j = 1:size(JoinedData,2)
        sim_smc(i,j) = similarity(JoinedData(:,i)', JoinedData(:,j)', 'smc');
    end
end

% Jaccard
sim_jac = zeros(size(JoinedData, 2));
for i = 1:size(JoinedData,2)
    for j = 1:size(JoinedData,2)
        sim_jac(i,j) = similarity(JoinedData(:,i)', JoinedData(:,j)', 'jac');
    end
end

% Cosine
sim_cos = zeros(size(JoinedData, 2));
for i = 1:size(JoinedData,2)
    for j = 1:size(JoinedData,2)
        sim_cos(i,j) = similarity(JoinedData(:,i)', JoinedData(:,j)', 'cos');
    end
end

% Correlation
sim_cor = zeros(size(JoinedData, 2));
for i = 1:size(JoinedData,2)
    for j = 1:size(JoinedData,2)
        sim_cor(i,j) = similarity(JoinedData(:,i)', JoinedData(:,j)', 'cor');
    end
end

% Extended Jaccard
sim_ext = zeros(size(JoinedData, 2));
for i = 1:size(JoinedData,2)
    for j = 1:size(JoinedData,2)
        sim_ext(i,j) = similarity(JoinedData(:,i)', JoinedData(:,j)', 'ext');
    end
end

figure;
heatmap(sim_smc, 'ColorMethod', 'none');
title('SMC');
xlabel('Attribute index');
ylabel('Attribute index');

figure;
heatmap(sim_jac, 'ColorMethod', 'none');
title('Jaccard');
xlabel('Attribute index');
ylabel('Attribute index');

figure;
heatmap(sim_cos, 'ColorMethod', 'none');
title('Cosine');
xlabel('Attribute index');
ylabel('Attribute index');

figure;
heatmap(sim_cor, 'ColorMethod', 'none');
title('Correlation');
xlabel('Attribute index');
ylabel('Attribute index');

figure;
heatmap(sim_ext, 'ColorMethod', 'none');
title('Extended Jaccard');
xlabel('Attribute index');
ylabel('Attribute index');

%% Boxplot:
% Area
% Population
% No. of bars
% No. of stripes 
% No. of stars
clc
figure
%Subplot
hold on
grid on

% Doesn't work in MATLAB R2017a
boxplot(horzcat(S4_5,S8_10(:,1:2),S19_28(:,5)),'Labels',AttributeNames([4 5 8 9 23]));

xlabel('Attributes');
ylabel('Values of attributes in flags');
hold off
%% Projection of data to PC1 and PC2
PercentPCData = PCAData * V;
figure
hold on
grid on
j = 1; k = 2;
gscatter(PercentPCData(:,j),PercentPCData(:,k),S06)
% legend('off')
lgd = legend({'English', 'Spanish', 'French', 'German', 'Slavic', 'Other Indo-European','Chinese', 'Arabic','Japanese/Turkish/Finnish/Magyar','Other'},...
    'FontSize',16, 'Location', 'best');

% Doesn't work in MATLAB R2017a
% lgd.NumColumns = 2;

xlabel("PC 1");
ylabel("PC 2");

figure
hold on
grid on
j = 1; k = 2;
gscatter(PercentPCData(:,j),PercentPCData(:,k),S02)
%legend('off')
lgd = legend({'N. America', 'S. America', 'Europe', 'Africa', 'Asia', 'Oceania'},...
    'FontSize',16, 'Location', 'best');

% Doesn't work in MATLAB R2017a
% lgd.NumColumns = 2;

xlabel("PC 1");
ylabel("PC 2");
hold off
% %% Dataprojection to parallel Dimentions
% MultiDPCAPlot = zeros(length(S06(1,:)),idx975-1)
% %PercentPCData = PCAData * V;
% 
% for i = 1 : length(S06(1,:))
%     for j = 1 : (idx975-1)
%         MultiDPCAPlot(i,j) = sum(S06(
%         
%     end
% end
% figure
% hold on
% grid on

%% pillar diagram of PCA's
%extract first row of V
clc
PCAPlots = 6;

for j = 1 : PCAPlots
    figure
    hold on
    grid on

    bar(sqrt(V(:,j).^2),'faceColor',[0 0 0])
    myMax = max(V(:,j));
    myExpMax = sqrt(max(exp(V(:,j)))^2);
    normV = sqrt(V.^2);
    myMean = mean(normV(:,j));

    for i = 1 : length(V(:,j))
        nV = sqrt(V(i,j).^2);
        plotcolorR = 1;
        plotcolorG = 1;
%         plotcolorB = 1;
        if myMean < nV
           % color red 
            weight = myMax-nV+.5;%/max(exp(nV))
            plotcolorG = weight;
            plotcolorB = weight;
        else
           % color green
            weight = 1-(myMax-nV+.5);
            plotcolorR = weight;
            plotcolorB = weight;
        end
    %     plotcolorR = exp(nV)/max(exp(nV));
    %     plotcolorG = exp(nV)/max(exp(nV));
    %     plotcolorB;
        bar(i,sqrt(V(i,j).^2),'faceColor',[(plotcolorR) (plotcolorG) (plotcolorB)])% exp(-sqrt(V(j,i).^2))
    end
    %(1-sqrt((V(j,i)./3).^2)+.6)
    %bar(sqrt(V(j,:).^2),'faceColor',[sqrt(V(j,i).^2) 0 0])
    %text(1:length(MyColorsAndPercent),MyColorsAndPercent,num2str(MyColorsAndPercent'),'vert','bottom','horiz','center','FontSize',24); 
    xlabel('Attributes') %  (some are 1 out of k coded)
    yString = "Magnitude of each attribue in PC " + j;
    ylabel(yString);
    hold off
end

%%
% % Extract attribute names from the loaded table
% attributeNames = flag_table.Properties.VariableNames([2:17 19:28])';
% 
% % Extract unique class names from the first row
% classLabels = table2cell(flag_table(:,1)); 
% classNames = unique(classLabels);
% 
% % Extract class labels that match the class names
% [~,y] = ismember(classLabels, classNames);
% 
% % Since we want to assign numerical values to the classes starting from a
% % zero and not a one, we subtract one to the get final y:
% y = y-1;
% 
% % Lastly, we determine the number of attributes M, the number of
% % observations N and the number of classes C:
% [M, N] = size(X);
% C = length(classNames);

% %% Classification problem and regression - ex1_5_4.m
% 
% X_c = X;
% y_c = y;
% attributeNames_classification = attributeNames;
% 
% i = 1; j = 2;
% mfig('Flags classification problem')
% % If you get an error: "Undefined function or variable 'mfig', you have to
% % remember to run the setup.m file in the root of the toolbox!
% gscatter(X_c(:,i), X_c(:,j), ...
%          classNames(y_c+1)); 
% axis equal; 
% xlabel(attributeNames_classification{i});
% ylabel(attributeNames_classification{j});
% 
% %
% Subtract the mean from the data
% Y = bsxfun(@minus, X, mean(X));
% 
% PCA from SVD of Y
% [U, S, V] = svd(Y)
% 
% Compute variance explained
% rho = diag(S).^2./sum(diag(S).^2);
% threshold = 0.90;

% Plot variance explained
% mfig('Flags: Var. explained'); clf;
% hold on
% plot(rho, 'x-');
% plot(cumsum(rho), 'o-');
% plot([0,length(rho)], [threshold, threshold], 'k--');
% legend({'Individual','Cumulative','Threshold'}, ...
%         'Location','best');
% ylim([0, 1]);
% xlim([1, length(rho)]);
% grid minor
% xlabel('Principal component');
% ylabel('Variance explained value');
% title('Variance explained by principal components');

%% Functions:
function out = OneOutOfKCoding(A) %A is Assumed 1D with the same attribute in a column
    C = unique(A);
    out = zeros(length(A(:)),length(C));
    for i = 1 : length(A(:))
        out(i,find(C == A(i),1)) = 1;
    end
end

function B = stringArray2num(A)
B = zeros(length(A),1);
    for n = 1 : length(A)
        B(n) = c2n(A(n));
    end
end

function out = c2n(colorStr)
switch colorStr
    case "green"
        out = 1;
    case "red"
        out = 2;
    case "blue"
        out = 3;
    case "gold"
        out = 4;
    case "white"
        out = 5;
    case "black"
        out = 6;
    case "brown"
        out = 7;
    case "orange"
        out = 8;
    otherwise
        out = -1;
end
end
