
function [x,y] = acoeff2cart_cubic(a,s,numPts)
xMax0=s;

xMax=fminsearch(@LOCAL_FitS,xMax0, optimset('Algorithm','active-set','TolFun',1e-2,'display','off'),a,s,numPts);
x=0:xMax/(numPts-1):xMax;
y=a.*(x.^3);
if ~isempty(x) & ~isempty(y)
    [x,y]=equidist(x,y,numPts);
else
    x = NaN; y = NaN;
end;
end

function e=LOCAL_FitS(x,a,s,numPts)


xVals=0:x/(numPts-1):x;
yVals=a.*(xVals.^3);
%     plot(xVals,yVals);
%     title(num2str(s));
%     drawnow;
sGuess=arclength(xVals,yVals);
e=abs(s-sGuess);

end