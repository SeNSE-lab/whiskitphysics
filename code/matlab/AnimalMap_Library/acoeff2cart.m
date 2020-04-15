function [x,y] = acoeff2cart(a,s,numPts)
xMax0=s;

xMax=fminsearch(@LOCAL_FitS,xMax0, optimset('Algorithm','active-set','TolFun',1e-2,'display','off'),a,s,numPts);
x=0:xMax/(numPts-1):xMax;
y=a.*(x.^2);
[x,y]=equidist(x,y,numPts);
end

function e=LOCAL_FitS(x,a,s,numPts)


    xVals=0:x/(numPts-1):x;
    yVals=a.*(xVals.^2);
%     plot(xVals,yVals);
%     title(num2str(s));
%     drawnow;
    sGuess=arclength(xVals,yVals);
    e=abs(s-sGuess);

end