clear;
ca;

% x, y, likelihood
% 2-4:  l_front_prox
% 5-7:  l_front_dist
% 8-10: l_mid_prox
% 11-13:l_mid_dist
% 14-16:l_rear_prox
% 17-19:l_rear_dist
% 20-22:r_front_prox
% 23-25:r_front_dist
% 26-28:r_mid_prox
% 29-31:r_mid_dist
% 32-34:r_read_prox
% 35-37:r_rear_dist
whisker_top = readmatrix('whisker_top.csv');
% 2-4:  nose
% 5-7:  l_ear
% 8-10: r_ear
% 11-13:l_eye
% 14-16:r_eye
head_top = readmatrix('head_top.csv');
head_left = readmatrix('head_left.csv');
head_front = readmatrix('head_front.csv');

%% 3D construction for each feature: quick and dirty way
% for each feature, there should be at least two views giving likelihood
% greater than 0.9. Otherwise this feature count as missing from this frame

feature_name = {'nose', 'l_ear', 'r_ear', 'l_eye', 'r_eye'};

for start = 2:3:14
    % iterator: change every loop

    % nose (2-4)
    likelihood_top = head_top(:,start+2)>0.9;
    likelihood_left = head_left(:,start+2)>0.9;
    likelihood_front = head_front(:,start+2)>0.9;
    head_top(~likelihood_top, start:start+1) = nan;
    head_left(~likelihood_left, start:start+1) = nan;
    head_front(~likelihood_front, start:start+1) = nan;

    % fix x (top view and front view)
    idx_x = likelihood_top & likelihood_front;
    feature_x_top = head_top(:,start);
    feature_x_front = -head_front(:,start);
    diff_x = mean(feature_x_top(idx_x) - feature_x_front(idx_x));
    feature_x= nanmean([feature_x_top, feature_x_front+diff_x], 2);
    feature_x_smooth = smoothdata(feature_x, 'rlowess', 50);

    % fix y (top view and left view)
    idx_y = likelihood_top & likelihood_left;
    feature_y_top = head_top(:,start+1);
    feature_y_left = head_left(:,start);
    diff_y = mean(feature_y_top(idx_y) - feature_y_left(idx_y));
    feature_y = nanmean([feature_y_top, feature_y_left+diff_y], 2);
    feature_y_smooth = smoothdata(feature_y, 'rlowess', 50);

    % fix z (front view and left view)
    idx_z = likelihood_front & likelihood_left;
    feature_z_front = head_front(:,start+1);
    feature_z_left = head_left(:,start+1);
    diff_z = mean(feature_z_front(idx_z) - feature_z_left(idx_z));
    feature_z = nanmean([feature_z_front, feature_z_left + diff_z], 2);
    feature_z_smooth = smoothdata(feature_z, 'rlowess', 50);
    
    n = (start+1)/3;
    eval([feature_name{n},'_x=feature_x_smooth;'])
    eval([feature_name{n},'_y=feature_y_smooth;'])
    eval([feature_name{n},'_z=feature_z_smooth;'])
end

% DEBUG plotting
% x = 1:4620;
% figure('Position', [100, 100, 1500, 1000]); hold on
% plot(feature_x_smooth, 'k')
% plot(x(likelihood_top), feature_x_top(likelihood_top), 'r.');
% plot(x(likelihood_front), feature_x_front(likelihood_front)+diff_x, 'b.');
% figure('Position', [100, 100, 1500, 1000]); hold on
% plot(feature_y_smooth)
% plot(x(likelihood_top), feature_y_top(likelihood_top), 'r.');
% plot(x(likelihood_left), feature_y_left(likelihood_left)+diff_y, 'b.');
% figure('Position', [100, 100, 1500, 1000]); hold on
% plot(feature_z_smooth, 'k')
% plot(x(likelihood_front), feature_z_front(likelihood_front), 'r.');
% plot(x(likelihood_left), feature_z_left(likelihood_left)+diff_z, 'b.');


figure; hold on
plot(r_ear_x(1:2000));
plot(r_eye_x(1:2000));























