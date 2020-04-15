function [x,y] = acoeff2cart_poly3(a, b, s, numPts)
    xMax0=s;

    xMax=fminsearch(@LOCAL_FitS,xMax0, optimset('Algorithm','active-set','TolFun',1e-2,'display','off'),a,b,s,numPts);
    x=0:xMax/(numPts-1):xMax;
    y=a.*(x.^3)+b.*(x.^2);
    if ~isempty(x) && ~isempty(y)
        [x,y]=equidist(x,y,numPts);
    else
        x = NaN; y = NaN;
    end
end

function e=LOCAL_FitS(x, a, b, s, numPts)
% local fit function
xVals=0:x/(numPts-1):x;
yVals=a.*(xVals.^3) + b.*(xVals.^2);

sGuess=arclength(xVals,yVals);
e=abs(s-sGuess);

end