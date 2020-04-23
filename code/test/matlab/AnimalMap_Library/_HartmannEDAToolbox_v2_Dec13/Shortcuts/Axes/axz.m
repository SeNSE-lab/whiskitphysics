% AXZ
% 	axz(newzmin, newzmax);
%	Changes the z axis while keeping the x and y axis the same
%  Hartmann EDA Toolbox v1, Dec 2004

function[void] = axz(newzmin, newzmax)

if nargin==1,
    newzmax=newzmin(length(newzmin));
    newzmin=newzmin(1);
end;


temp=axis;
if length(temp)>4
    axis([temp(1),temp(2),temp(3),temp(4),newzmin,newzmax]);
else
    axis([temp(1),temp(2),newzmin,newzmax]);
end;
