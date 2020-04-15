clear;
ca;

load('for_yifu.mat');
nose = for_yifu.nose;
left = for_yifu.l_eye;
right = for_yifu.r_ear;
whisk_right = for_yifu.whisk_right;
whisk_left = for_yifu.whisk_left;
clear for_yifu

fps = 300;
%% Linear velocity
locX = smooth(mean([nose(:,1), left(:,1), right(:,1)], 2), 100);
locY = smooth(mean([nose(:,2), left(:,2), right(:,2)], 2), 100);
locZ = smooth(mean([nose(:,3), left(:,3), right(:,3)], 100);












