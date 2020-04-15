% this script test to see if the manually generated protraction angle from
% the orientation matrix is the same as specified phase

% the protraction angle from orientation
stick = cellfun(@(x) x*[0;-1;0], orientMat, 'UniformOutput', false);
protract = cell2mat(cellfun(@(x) atan(x(2)./x(1)), stick, 'UniformOutput', false));

% the protraction angle from angular velocity



figure; hold on;
plot(phase-phase(1));
plot(protract(1,:)-protract(1,1));