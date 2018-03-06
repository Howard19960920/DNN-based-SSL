% THISE CODE VISUALIZES THE CLUSTER OF THE CORRELATION COEFICIENT WITH A
% PLOT IMAGE.

% CLEAN UP WORKSPACE AND COMMAND WINDOWS
clc;
clear;


temp = csvread('./features.csv');
xs = temp(:, 1);
ys = temp(:, 2);

labels = csvread('labels.csv');
gscatter(xs, ys, labels);
    
xlabel('correlation of left channels');
ylabel('correlation of right channels');