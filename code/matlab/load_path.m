% Location every milisecond
t = 0:0.001:0.05; % in s
x = t;
y = t.^2;
% plot(x,y,'k-');
% axis equal
input = [x', y'];

clearvars x y t