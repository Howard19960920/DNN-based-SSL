%This code generates the csv file which contains all the CC factors comparing to a selected referred point 

% Reset Command Window
clc;

% Reset Workspace
clear; 

% This is the absolute path of the referred wav file. 
% Default = './15-30/(15, 30, 20)-1/chunks0.wav'
ref_path = './15-15/(15, 15, 40)-1/chunk/chunks0.wav';

% Map each of the 9 coordinates to a specific no.
map = zeros(30, 30);
map(1, 1) = 1;
map(15, 1) = 2;
map(30, 1) = 3;
map(1, 15) = 4;
map(15, 15) = 5;
map(30, 15) = 6;
map(1, 30) = 7;
map(15, 30) = 8;
map(30, 30) = 9;

% Read the referred audio file, ignoring the sampling rate
ref_base = audioread( ref_path ); 

% Temp all directory paths
x2y = dir('*-*');

% Start up a file descriptor
fd = fopen('CC.csv', 'W');

debug = 1;

% Iterating the x2y directories
for i = 1 : length( x2y )
    
    xny = sscanf( strrep(x2y(i).name, '-', ' '), '%d%d');
    x = xny(1);
    y = xny(2);
    
    if x == 0
        x = x + 1;
    end
    if y == 0
        y = y + 1;
    end
    
    x2y2h = dir( x2y(i).name );
    % Avoiding '.' and '..' using loop less solution
    x2y2h = x2y2h(~ismember({x2y2h.name}, {'.', '..'}));
    
    % Iterating the x2y2h directories
    for j = 1 : length( x2y2h )
    
        aupath = dir( strcat('./', x2y(i).name, '/', x2y2h(j).name, '/chunk/*.wav') );
        
        % Iterating each of the 50 audio files
        for k = 1 : length( aupath )
            
            % show the progress
            fprintf("%d runs\n", debug);
            debug = debug + 1;
            
            temp = audioread( strcat(aupath(k).folder, '/', aupath(k).name) );
            
            % left right channel altogether
            % cc = corrcoef(ref_base, temp);
            % fprintf(fd, "%f,%d\n", cc(1, 2));
            
            % left right channel seperate
            cc1 = corrcoef(ref_base(:, 1), temp(:, 1));
            cc2 = corrcoef(ref_base(:, 2), temp(:, 2));
            fprintf(fd, "%f,%f,%d\n", cc1(1, 2), cc2(1, 2), map(x, y));
            
        end   
        
    end
    
end

fclose(fd);
return;