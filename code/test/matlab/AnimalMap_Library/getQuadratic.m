function [x,y] = getQuadratic(a,s,numPts)
%getQuadratic generates a fitted quadratic curve given the number of points
% on the curve, the A coefficient and the arc length.
%
%   y = A*x^2
%
%   [x, y] = getQuadratic(A,S,numPts) calculates the planar coordinates of
%   the fitted curve in dimension of numPts, using the given A coefficient
%   and arc length S. The points have equal distance.
%
% By Yifu
% 2017/12/06

% Find x corresponding to arc length
xMax0 = s;
xMax = fminsearch(@LOCAL_FitS,xMax0, ...
    optimset('Algorithm','active-set','TolFun',1e-2,'display','off'),a,s,numPts);
% Generate curve
x = 0:xMax/(numPts-1):xMax;
y = a.*(x.^2);
[x, y] = equidist(x,y,numPts);
end

function e = LOCAL_FitS(x,a,s,numPts)
    xVals = 0:x/(numPts-1):x;
    yVals = a.*(xVals.^2);
    sGuess = arclength(xVals,yVals);
    e = abs(s-sGuess);
end