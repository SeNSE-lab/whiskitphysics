clear;

locX = readmatrix('../../output/test/kinematics/x/LA0.csv');
locY = readmatrix('../../output/test/kinematics/y/LA0.csv');
locZ = readmatrix('../../output/test/kinematics/z/LA0.csv');

figure('Color','w'); hold on
plot(locX(:,1), locY(:,1), 'r-');

kevin = readmatrix('loc_vel_kevin.csv');
plot(kevin(:,1), kevin(:,2), 'k-');