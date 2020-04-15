function [x,y] = getCircle(R,s,numPts)
%getCircle generates a fitted curve which is a part of a circle, given the 
% number of points on the curve, the radius and the arc length. 
%
%   x^2 + (y-R)^2 = R^2
%
%   [x, y]  =  getCircle(A,S,numPts) calculates the planar coordinates of
%   the fitted curve in dimension of numPts, using the given radius R
%   and arc length S. The points have equal distance.
%
% By Yifu
% 2017/12/06

% Find x corresponding to arc length
xMax = R*sin(s/R);
% Generate curve
x = 0:xMax/(numPts-1):xMax;
y = -sqrt(R.^2-x.^2) + R;
[x, y] = equidist(x,y,numPts);

end