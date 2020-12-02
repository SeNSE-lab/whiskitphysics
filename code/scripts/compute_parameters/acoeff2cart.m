%% * function [x,y] = acoeff2cart(a,s,numPts)
function [x,y] = acoeff2cart(a,s,numPts)
% Returns the (x,y) coordinates for each point along the whisker baased on 
% its curvature and length.
% INPUTS:
%   a = curvature coefficient
%   s = arc length
%   numPts = number of sample points along the whisker
%
% OUTPUTS:
%   a = x-coordinates
%   s = y-coordinates
%   
% Author unkown
% ====================================================

xMax0=s;
xMax=fminsearch(@LOCAL_FitS,xMax0, optimset('Algorithm','active-set','MaxIter', 1000,'TolFun',1e-2,'display','off'),a,s,numPts);
x=0:xMax/(numPts-1):xMax;
y=a.*(x.^2);
[x,y]=equidist(x,y,numPts);

end

function e=LOCAL_FitS(x,a,s,numPts)
    xVals=0:x/(numPts-1):x;
    yVals=a.*(xVals.^2);
    sGuess=arclength(xVals,yVals);
    e=abs(s-sGuess);
end