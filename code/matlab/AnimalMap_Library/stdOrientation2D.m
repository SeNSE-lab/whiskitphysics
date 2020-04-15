function [xstd, ystd, th] = stdOrientation2D(x, y, varargin)
%stdOrientation2D takes arbitrary 2D whisker to its standard orientation.
%This orientation origins at (0, 0) and curves concave up
%
%   [xstd, ystd] = stdOrientation2D(x, y) x and y are row vectors.
%   [xstd, ystd] = stdOrientation2D(x, y, 'up')
%
% By Yifu
% 2018/02/26

% Move to origin
len = length(x);
x = reshape(x,[1,len]); y = reshape(y,[1,len]);
whisker_bp = [x - x(1); y - y(1)];
% Find rotation angle
proIdx = floor(length(x)*0.10); % proximal 25%
% th = cart2pol(whisker_bp(1,proIdx), whisker_bp(2,proIdx));
[vec, val] = eig(cov(whisker_bp(:,1:proIdx)'));
[~, maxIndx] = max(diag(val));

th = cart2pol(vec(1,maxIndx),vec(2,maxIndx));
if dot(whisker_bp(:,proIdx),vec(:,maxIndx)) < 0
    th = pi + th;
end

% Rotate
whisker_bp_std = rot2(-th)*whisker_bp;
% Check concave up/down
if ~isempty(varargin)
    if ~strcmp(varargin{1},'up')
        error('The third input should be ''up'', or make it empty.')
    elseif whisker_bp_std(2,end) < 0
        whisker_bp_std(2,:) = -whisker_bp_std(2,:);
    end
end

xstd = whisker_bp_std(1,:);
ystd = whisker_bp_std(2,:);

% Check plot
PLOTTING = 0;
if PLOTTING
    figure; hold on
    plot(whisker_bp(1,:),whisker_bp(2,:),'r-')
    plot(whisker_bp_std(1,:),whisker_bp_std(2,:),'b-')
end


end

