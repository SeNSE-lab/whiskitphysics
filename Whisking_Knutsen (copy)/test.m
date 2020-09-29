x = readmatrix('../../../output/test/kinematics/x/RA0.csv');
y = readmatrix('../../../output/test/kinematics/y/RA0.csv');
dy = y(:,2) - y(:,1);
dx = x(:,2) - x(:,1);
p_sim = atan(dy./dx)+pi/2;