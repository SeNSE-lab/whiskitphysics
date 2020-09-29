% This script geneartes whisker angles in a whisking phase
% This sceipt also generates a look-up table based on averaged EulerTheta
% angles. ~70+[-60,60] = [10, 130]

clear; close all
retraction = 10;
protraction = 35;
whisk_freq = 8;
time_stop = 1;

% compute_angles_average_rat(retraction,protraction,whisk_freq,time_stop);
compute_angles_model_rat(retraction,protraction,whisk_freq,time_stop);