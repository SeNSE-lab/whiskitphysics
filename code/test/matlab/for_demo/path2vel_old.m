clear;

%% frame rate 300Hz
filename = '2018-02-19-13-44-12_rat02_smoothed_from_Kevin.csv';
% 1frame; 2nose_x; 3nose_y; 4nose_z; 5r_ear_x; 6r_ear_y; 7r_ear_z;
M = readmatrix(filename);
noseX = M(:,2);
noseY = M(:,3);
noseZ = M(:,4);
earX = M(:,5);
earY = M(:,6);
earZ = M(:,7);

%% location and direction in 3D
locX = smooth(mean([noseX, earX], 2), 100);
locY = smooth(mean([noseY, earY], 2), 100);
locZ = smooth(mean([noseZ, earZ], 2), 100);
ax = [noseX-earX, noseY-earY, noseZ-earZ];

%% linear velocity
l_vel_x = (locX(2:end)-locX(1:end-1))*300; % unit/s
l_vel_y = (locY(2:end)-locY(1:end-1))*300;
l_vel_z = (locZ(2:end)-locZ(1:end-1))*300;

%% angular velocity
% First, get projected angle in three planes
% HERE: needs discontinuity fixation
angle_xy = atan2(ax(:,2), ax(:,1));
angle_xy(angle_xy < -0.9) = angle_xy(angle_xy < -0.9) + 2*pi; %discontinuity fixation
angle_xy = smooth(angle_xy, 100);

angle_yz = atan2(ax(:,3), ax(:,2));
angle_yz = smooth(angle_yz, 100);

angle_zx = atan2(ax(:,1), ax(:,3));
angle_zx(angle_zx > 1) = angle_zx(angle_zx > 1) - 2*pi;
angle_zx = smooth(angle_zx, 100);

% Then, calculate the angular velocity
a_vel_x = (angle_yz(2:end) - angle_yz(1:end-1))*300; % projected angular difference on y-z plane
a_vel_y = (angle_zx(2:end) - angle_zx(1:end-1))*300; % projected angular difference on z-x plane
a_vel_z = (angle_xy(2:end) - angle_xy(1:end-1))*300; % projected angular difference on x-y plane

%% convert from 300Hz to 1000Hz
t_old = 0:1/300:2988/300;
t_new = 0:1e-3:2988/300;
l_vel_x_new = interp1(t_old, l_vel_x, t_new);
l_vel_y_new = interp1(t_old, l_vel_y, t_new);
l_vel_z_new = interp1(t_old, l_vel_z, t_new);
a_vel_x_new = interp1(t_old, a_vel_x, t_new);
a_vel_y_new = interp1(t_old, a_vel_y, t_new);
a_vel_z_new = interp1(t_old, a_vel_z, t_new);

locX = locX(1:end-1) - locX(1);
locY = locY(1:end-1) - locY(1);
locZ = locZ(1:end-1) - locZ(1);
l_loc_x_new = interp1(t_old, locX, t_new);
l_loc_y_new = interp1(t_old, locY, t_new);
l_loc_z_new = interp1(t_old, locZ, t_new);

%% save


M = [l_loc_x_new', l_loc_y_new', l_loc_z_new',...
     l_vel_x_new', l_vel_y_new', l_vel_z_new',...
     a_vel_x_new', a_vel_y_new', a_vel_z_new'];
writematrix(M, 'kevin_bad.csv', 'Delimiter', ',');





