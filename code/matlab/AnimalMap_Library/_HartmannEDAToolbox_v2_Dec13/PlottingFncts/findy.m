%  Hartmann EDA Toolbox v2, Dec 2013
% function[x]=findy
% echos the min value, max value, and range of the y axis to the screen
% the return variable x = minvalue:max value
% useful for selecting portions of the data

function[x]=findy
temp=axis;
xtop=temp(4);
xbot=temp(3);
if ((abs(xbot) < 50) | (abs(xtop)<50))
    format bank;
    xdif=xtop-xbot;
    x=[xbot,xtop,xdif];
else    
    format short;
    xtop=round(xtop);
    xbot=round(xbot);
    xdif=xtop-xbot;
    x=[xbot,xtop,xdif];
end;
disp(x);
x=xbot:xtop;