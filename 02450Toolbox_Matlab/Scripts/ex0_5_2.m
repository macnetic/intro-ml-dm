%% exercise 0.5.2
% We simulate measurements every 100 ms for a period of 10 seconds 
t = 0:0.1:10;

%The data from the sensors are generated as either a sine or a cosine 
%with some Gaussian noise added.
sensor1 = 3*sin(t)+0.5*randn(size(t));
sensor2 = 3*cos(t)+0.5*randn(size(t));

 % Change the font size to make axis and title readable
font_size = 15;

% Define the name of the curves
legend_strings = {'Sensor 1', 'Sensor 2'}; 

% Start plotting the simulated measurements
figure(1); clf;
    % Plot the sensor 1 output as a function of time, and
    % make the curve red and fully drawn
    plot(t,sensor1,'r-'); 
    
    % Hold (dont remove) the first plot when plotting the second
    hold on 
    
    % Plot the sensor 2 output as a function of time, and
    % make the curve blue and dashed
    plot(t,sensor2,'b--'); 
    
    % Notice that these two curves will still be distinguisable even
    % if the plot is made black and white.
    
    % Ensure that the limits on the axis fit the data 
    axis tight 
    
    % Add a grid in the background
    grid 
    
    % Add a legend describing each curve, place it at the "best" location
    % so as to minimize the amount of curve it covers
    legend(legend_strings,'Location','best'); 
    
    % Add labels to the axes
    xlabel('Time [s]')
    ylabel('Voltage [mV]')
    
    % Add a title to the plot
    title('Sensor outputs')
    
    % Set the font size
    set(gca,'FontSize',font_size)
% Export the figure
saveas(gcf,'ex1_5_2.png')