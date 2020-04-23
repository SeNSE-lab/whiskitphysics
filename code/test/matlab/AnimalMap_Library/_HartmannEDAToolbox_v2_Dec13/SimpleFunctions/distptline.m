function[d,xd,yd]=distptline(x1,y1,m,oldb);

% function[d,xd,yd]=distptline(x1,y1,m,b);
%
% Finds the  distance d from point (x1,y1) to the line y=mx+b
%
% The distance from a point (x1,y1) from a line having the equation
% ax+by+c =0 is given by abs(ax1+by1+c)/sqrt(a*a+b*b)
% Hartmann EDA Toolbox v1, Dec 2004

% mx-y+b=0
if m~=0

a=m; b=-1; c=oldb;
d=(a*x1+b*y1+c)/sqrt((a*a)+(b*b));

% find the point where the horizontal line y=y1 intersects the
% arbitrary line y=mx+b;

% y=mx+b
% x=(y-b)/m
  x2=(y1-oldb)/m;
  xd=(x2-x1);

% find the point where the vertical line x=x1 intersects the
% arbitrary line y=mx+b;
  y2=m*x1+oldb;
  yd=(y2-y1);

elseif m==0
    xd=0;
    yd=y1-oldb;
    d=yd;
end;
