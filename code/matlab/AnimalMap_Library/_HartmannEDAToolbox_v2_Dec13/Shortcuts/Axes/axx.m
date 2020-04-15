% AXX
% 	axx(newxmin, newxmax);
%	Changes the x axis while keeping the y and z axes the same
%  Hartmann EDA Toolbox v1, Dec 2004

function[void] = axx(newxmin, newxmax)

if nargin==1,
    newxmax=newxmin(length(newxmin));
    newxmin=newxmin(1);
end;

temp=axis;
if length(temp)>4
    axis([newxmin,newxmax,temp(3),temp(4),temp(5),temp(6)]);
else
    axis([newxmin,newxmax,temp(3),temp(4)]);
end;