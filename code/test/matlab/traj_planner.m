clear

%% Load input path
load_path

%% generate velocity profile
dt = 0.001; %1ms
v = input(2:end,:) - input(1:end-1,:);

%% output path
output = cumsum(v);

%%
figure; hold on
plot(input(:,1), input(:,2), 'r+', ...
     output(:,1), output(:,2), 'ko');
axis equal