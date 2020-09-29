% read trajectory from simulation
x = readmatrix('../../../output/test/kinematics/x/RC1.csv');
y = readmatrix('../../../output/test/kinematics/y/RC1.csv');
dy = y(:,2) - y(:,1);
dx = x(:,2) - x(:,1);
p_sim = atan(dy./dx)+pi/2;

% trajectory from tracking
p_track = load('trajectory_from_Kevin/phase.mat').phase*pi/180;


% the protraction angle from orientation
stick = cellfun(@(x) x*[0;-1;0], orientMat, 'UniformOutput', false);
p_orient = cell2mat(cellfun(@(x) atan(x(2)./x(1))+pi/2, stick, ...
                    'UniformOutput', false));


figure('Color', 'w'); hold on
plot(p_sim, 'b.-', 'linewidth', 1)
% plot(p_track, 'k', 'linewidth', 5)
% plot(p_orient(1:31,:)', 'k')
plot(p_orient(13,:), 'r')

% legend({'sim', 'track', 'orient'})



