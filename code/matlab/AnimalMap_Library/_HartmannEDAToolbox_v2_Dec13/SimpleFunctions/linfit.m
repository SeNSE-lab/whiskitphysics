% LINFIT                        Mitra Hartmann, May 1999
%
% [m,b,normres,r2,stringout]=linfit(x,y,plotflag,echoflag)
% Finds the equation y=m*x + b that best fits the data x and y.
%
% plotflag defaults to 'n' (no plot). Set plotflag to 'y' to plot the
%   linear fit.
% echoflag defaults to 'y' (echos result to the screen).  Set echoflag to
%   'n' to avoid screen echo of results.
%
% normres is the norm of the residuals.  Note that normres depends on how your y values
%   are scaled.  If your y values range from 1 to 10, normres will be 100
%   times smaller than if they range from 100 to 1000.    
%
% r2 is a measure that does not depend on how the data is scaled. r2 is calculated
%   by normalizing the covariance of x and y by their standard deviations,
%   that is r2 = cov(x,y)/(std(x)*std(y)).   Remember that std is the
%   square root of the variance.  Note that the r2 value will be identical
%   to the value obtained using corrcoef(x,y);
%
% stringout is a useful string you can put at the top of your graph using
%   the function TextAtTop

function[m,b,normres,r2,stringout]=linfit(x,y,plotflag,echoflag)

if nargin == 2 % user input only x and y
    plotflag = 'n'; echoflag = 'y';
elseif nargin == 3
    if strcmp(plotflag,'y')~=1, plotflag ='n'; end;
    echoflag = 'y';
elseif nargin == 4
    if strcmp(plotflag,'y')~=1, plotflag='n'; end;
    if strcmp(echoflag,'n')~=1, echoflag='y'; end;
end;


a = find(isnan(x));  c= find(isnan(y));
if ~isempty(a) | ~isempty(c)
    d = [a,c];
    x(d) = [];  y(d) = [];
    disp(['removed ' int2str(length(d)) ' NaNs']);
end;

[p,er]=polyfit(x,y,1);
m=p(1);b=p(2);
normres=er.normr;
r2=corrcoef(x,y);
if length(r2)>1
    r2=r2(2).*r2(2);
else
    r2=NaN;
end;

if b>=0
    tempstring=['y=' num2str(m) 'x+' num2str(b)];
else		
    tempstring=['y=' num2str(m) 'x' num2str(b)];
end;
stringout=['    ' tempstring ', r^2=' num2str(r2,3)];

if strcmp(plotflag,'y'),
    hold on;
    temp=axis;
    xtop=temp(2);
    xbot=temp(1);
    ival=(xtop-xbot)/2;
    newx=xbot:ival:xtop;
    newy=m*newx+b;
    h=plot(newx,newy,'k');ln2;
end;

if strcmp(echoflag,'y'),
    disp(stringout);
end;

