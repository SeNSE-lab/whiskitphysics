function [x,y]  =  getCubic(a,b,s,numPts)
%getCubic generates a fitted cubic curve given the number of points
% on the curve, the A, B coefficient and the arc length. The cubic curve's
% derivative at (0,0) is 0.
%
%   y = A*x^3 + B*x^2
%
%   [x, y]  =  getCubic(A,S,numPts) calculates the planar coordinates of
%   the fitted curve in dimension of numPts, using the given A, B 
%   coefficient and arc length S. The points have equal distance.
%
% By Yifu
% 2017/12/06

% Find x corresponding to arc length
xMax0 = s;
xMax = fminsearch(@LOCAL_FitS,xMax0, optimset('Algorithm','active-set','TolFun',1e-2,'display','off'),a,b,s,numPts);
% Generate curve
x = 0:xMax/(numPts-1):xMax;
y = a.*(x.^3)+b.*(x.^2);
[x, y] = equidist(x,y,numPts);
end

function e = LOCAL_FitS(x,a,b,s,numPts)
    xVals = 0:x/(numPts-1):x;
    yVals = a.*(xVals.^3)+b.*(xVals.^2);
    sGuess = arclength(xVals,yVals);
    e = abs(s-sGuess);

end