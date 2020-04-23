% This script geneartes whisker angles in a whisking phase
% This sceipt also generates a look-up table based on averaged EulerTheta
% angles. ~70+[-60,60] = [10, 130]

clear; close all
data = load('../../../data/param_bp_angles.csv');
%% Collecting information
% a_vel is a 60x(nStep*3) matrix with 30 whiskers on each side.
% 1-5    6-11    12-18    20-25    26-31
% A12345 B123456 C1234567 D1234567 E234567
minimap = containers.Map();
% for every whisker, put info into the container
for col = 1:5
    this_name = ['A0', num2str(col)];
    this_index = 1:5;
    this_struct.EulerTheta = data(this_index(col), 1);
    this_struct.EulerPhi = data(this_index(col), 2);
    this_struct.EulerZeta = data(this_index(col), 3);
    minimap(this_name) = this_struct;
end
for col = 1:6
    this_name = ['B0', num2str(col)];
    this_index = 6:11;
    this_struct.EulerTheta = data(this_index(col), 1);
    this_struct.EulerPhi = data(this_index(col), 2);
    this_struct.EulerZeta = data(this_index(col), 3);
    minimap(this_name) = this_struct;
end
for col = 1:7
    this_name = ['C0', num2str(col)];
    this_index = 12:18;
    this_struct.EulerTheta = data(this_index(col), 1);
    this_struct.EulerPhi = data(this_index(col), 2);
    this_struct.EulerZeta = data(this_index(col), 3);
    minimap(this_name) = this_struct;
end
for col = 1:7
    this_name = ['D0', num2str(col)];
    this_index = 19:25;
    this_struct.EulerTheta = data(this_index(col), 1);
    this_struct.EulerPhi = data(this_index(col), 2);
    this_struct.EulerZeta = data(this_index(col), 3);
    minimap(this_name) = this_struct;
end
for col = 2:7
    this_name = ['E0', num2str(col)];
    this_index = [nan,26:31];
    this_struct.EulerTheta = data(this_index(col), 1);
    this_struct.EulerPhi = data(this_index(col), 2);
    this_struct.EulerZeta = data(this_index(col), 3);
    minimap(this_name) = this_struct;
end



% The whisker start at rest.
% Azimuth span: -60~60
%
timepoints = 101;
k = keys(minimap)';
EulerThetas = zeros(31, timepoints);
EulerPhis = zeros(31, timepoints);
EulerZetas = zeros(31, timepoints);
% Elevation with azimuth
dPhi = [0.12*ones(5,1);     %   A row:  0.12 +/- 0.17
        0.3*ones(6,1);      %   B row:  0.30 +/- 0.17
        0.3*ones(7,1);      %   C row:  0.30 +/- 0.13
        0.14*ones(7,1);     %   D row:  0.14 +/- 0.14
        -0.02*ones(6,1)];   %   E row:  -0.02 +/- 0.13
% Torsion with azimuth
dZeta = [-0.75*ones(5,1);   %   A row:  -0.75
        -0.25*ones(6,1);    %   B row:  -0.25
        0.20*ones(7,1);     %   C row:  0.20
        0.40*ones(7,1);     %   D row:  0.40
        0.73*ones(6,1)];    %   E row:  0.73
% for 30 whiskers
for i = 1:31
    EulerThetaRest = nanmean(minimap(k{i}).EulerTheta)*180/pi;
    EulerPhiRest = nanmean(minimap(k{i}).EulerPhi)*180/pi;
    EulerZetaRest = nanmean(minimap(k{i}).EulerZeta)*180/pi;
        
    EulerThetas(i, :) = linspace(EulerThetaRest-60, EulerThetaRest+60, timepoints);
    EulerPhis(i, :) = linspace(EulerPhiRest+60*dPhi(i), EulerPhiRest+60*dPhi(i), timepoints);
    EulerZetas(i, :) = linspace(EulerZetaRest-60*dZeta(i), EulerZetaRest+60*dZeta(i), timepoints);
end
save('angles_in_whisking_[-60,60]', 'EulerThetas','EulerPhis','EulerZetas');




