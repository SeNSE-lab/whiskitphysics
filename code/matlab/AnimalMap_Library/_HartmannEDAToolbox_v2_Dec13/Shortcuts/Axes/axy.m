% AXY
% 	axy(newymin, newymax);
%	Changes the y axis while keeping the x and z axes the same
%  Hartmann EDA Toolbox v1, Dec 2004

function[void] = axx(newymin, newymax)

if nargin==1,
    newymax=newymin(length(newynmin));
    newymin=newymin(1);
end;	

temp=axis;
if length(temp)>4
    axis([temp(1),temp(2),newymin,newymax,temp(5),temp(6)]);
else
    axis([temp(1),temp(2),newymin,newymax]);
end;