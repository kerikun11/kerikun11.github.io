%% cleaning
clear;
set(groot, 'DefaultTextInterpreter', 'Latex');
set(groot, 'DefaultLegendInterpreter', 'Latex');
% set(groot, 'DefaultAxesFontSize', 14);
set(groot, 'DefaultLineLineWidth', 2);

%% load
rawdata = csvread('out.csv');
t = rawdata(:, 1);
j = rawdata(:, 2);
a = rawdata(:, 3);
v = rawdata(:, 4);
x = rawdata(:, 5);

%% plot
titles= {'Jerk', 'Acceleration', 'Velocity', 'Position'};
ylabels= {'$j$ [mm/s/s/s]', '$a$ [mm/s/s]', '$v$ [mm/s]', '$x$ [mm]'};
xlabelstr = '$t$ [s]';

figure(1);
data = [j a v x];
for i = 1 : 4
    subplot(4, 1, i);
    hold off; plot(nan, nan); % clean
    hold on;
    ax = gca; ax.ColorOrderIndex = i;
    plot(t, data(:, i));
    grid on;
    xlabel(xlabelstr);
    ylabel(ylabels(i));
    title(titles(i));
end
