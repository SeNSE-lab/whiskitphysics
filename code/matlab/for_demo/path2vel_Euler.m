clear;

%% frame rate 300Hz
% Kevin
filename = 'raw_from_Kevin.csv';
% 1frame; 2nose_x; 3nose_y; 4nose_z; 5r_ear_x; 6r_ear_y; 7r_ear_z;
M = readmatrix(filename);
noseX = M(:,2);
noseY = M(:,3);
noseZ = M(:,4);
earX = M(:,5);
earY = M(:,6);
earZ = M(:,7);

% % Admir
% filename = 'raw_from_Admir.csv';
% % 1nose_x; 2nose_y; 3nose_z; 4l_eye_z; 5l_eye_y; 6l_eye_x;
% M = readmatrix(filename);
% noseX = M(:,1);
% noseY = M(:,2);
% noseZ = M(:,3);
% earX = M(:,4);
% earY = M(:,5);
% earZ = M(:,6);

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
% First, get Euler angles at each time step (roll = 0)
[theta, phi, ~] = cart2sph(ax(:,1), ax(:,2), ax(:,3));
theta(theta<0.9) = theta(theta<0.9) + 2*pi;

% Second, get orientation matrix at each time step
orient = cell(length(theta), 1);
for tt = 1:length(theta)
    orient{tt} = rotz(theta(tt))*roty(-phi(tt));
end

% Third, get angular velocity tensor by 
% d(Rsb)/dt = [w]*Rsb
% [w] = dA/dt*A';
W = cell(length(theta)-1, 1);
for tt = 1:length(theta)-1
    W{tt} = (orient{tt+1}-orient{tt})*300*orient{tt}';
end

% Fourth, convert tensor to vector
w = cell2mat(cellfun(@tensor2vector, W, 'UniformOutput', false));
a_vel_x = w(:,1);
a_vel_y = w(:,2);
a_vel_z = w(:,3);

%% convert from 300Hz to 100Hz
t_old = 0:1/300:(length(w)-1)/300;
t_new = 0:1/300:(length(w)-1)/300;
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
writematrix(M, 'loc_vel_kevin.csv', 'Delimiter', ',');

function w = tensor2vector(W)
    w = zeros(1,3);
    w(1) = W(3,2);
    w(2) = W(1,3);
    w(3) = W(2,1);
end

