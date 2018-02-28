% THIS CODE WILL GENERATE A CSV FILE CONTAINING 9000 CORRELATION FACTORS
% REFERRED TO AN AVERAGE(MEAN) OF A GROUP OF SELECTED BASE SIGNALS

% RESET THE COMMNAD WINDOW
clc;

% RESET THE WORKSPACE
clear; 

% THIS IS THE ABSOLUTE PATH OF THE REFERRED DIRECTORY.
% THE CODE WILL READ ALL THE WAV FILES IN THE GIVEN DIRECTORY AND CALCULATE
% THE AVERAGE OF IT AND USE IT AS A BASE SIGNAL FOR CORRELATIONS.
% DEAFAULT SETTING IS './15-0/(15, 0, 30)-1/chunk/*.wav'.
ref_path = './15-0/(15, 0, 30)-1/chunk/*.wav';

% MAP EACH OF THE NICE POINTS TO A SPECIFIC NUMBER
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

% READ ALL THE WAV FILES, CONCAT THEM IN A MATRIX
ref_file = dir( ref_path );
ref_l_base = [];
ref_r_base = [];

for i = 1 : length( ref_file )
    
    % fprintf("%s\n", ref_file(i).name);
    ref_temp = audioread( strcat(ref_file(i).folder, '/', ref_file(i).name) );
    ref_l_base = [ ref_l_base, ref_temp(:, 1)];
    ref_r_base = [ ref_r_base, ref_temp(:, 2)];
    
end


ref_base = [mean(ref_l_base, 2), mean(ref_r_base, 2)];
 
% TEMP ALL THE DIRECTORIES PATH
x2y = dir('*-*');

% DESCRIPTORS
featfd = fopen('features.csv', 'W');
labelfd = fopen('labels.csv', 'W');
debug = 1;

% ITERATING THRU THE X-Y DIRECTORIES
for i = 1 : length( x2y )
    
    xny = sscanf( strrep(x2y(i).name, '-', ' '), '%d%d');
    x = xny(1);
    y = xny(2);
    
    % HAVE NO IDEA WHY MATLAB STARTS FROM 1.
    if x == 0
        x = x + 1;
    end
    
    if y == 0
        y = y + 1;
    end
    
    x2y2h = dir( x2y(i).name );
    % AVOIDING '.' AND '..' USING LOOP LESS SOLUTIONS
    x2y2h = x2y2h(~ismember({x2y2h.name}, {'.', '..'}));
    
    % ITERATING THRU X2Y2H DIRECTORIES
    for j = 1 : length( x2y2h )
    
        aupath = dir( strcat('./', x2y(i).name, '/', x2y2h(j).name, '/chunk/*.wav') );
        
        % ITERATING THRU 50 AUDIO WAV FIELS
        for k = 1 : length( aupath )
            
            % SHOW THE PROGRESS
            fprintf("%d runs\n", debug);
            debug = debug + 1;
            
            temp = audioread( strcat(aupath(k).folder, '/', aupath(k).name) );
          
            
            % CALCULATE THE CORRELATION COEFF OF LEFT, RIGHT CHANNELS
            cc1 = corrcoef(ref_base(:, 1), temp(:, 1));
            cc2 = corrcoef(ref_base(:, 2), temp(:, 2));
            fprintf(featfd, "%f,%f\n", cc1(1, 2), cc2(1, 2));
            
            % THE LABELS ARE SAVED BEFORE ONE-HOT ENCODE
            fprintf(labelfd, '%d\n', map(x, y));
                       
        end   
        
    end
    
end

fclose(featfd);
fclose(labelfd);
return;