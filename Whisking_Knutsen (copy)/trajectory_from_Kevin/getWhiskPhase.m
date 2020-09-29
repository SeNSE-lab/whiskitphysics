clear;
close all;

load('for_yifu.mat');
nose = for_yifu.nose;
left = for_yifu.l_eye;
right = for_yifu.r_ear;
whisk_right = for_yifu.whisk_right;
whisk_left = for_yifu.whisk_left;
clear for_yifu

phase = whisk_left(300:1000)*180/pi;
% phase = normalize(phase_temp, 'range', [0,1]);
save('phase', 'phase');