%  Hartmann EDA Toolbox v2, Dec 2013
% function[x]=findz
% echos the min value, max value, and range of the z axis to the screen
% the return variable x = minvalue:maxvalue
% useful for selecting portions of the data

function[x]=findz
temp=axis;
xtop=temp(6);
xbot=temp(5);
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