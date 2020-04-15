function[d,xd,yd]=distptpt(x1,y1,x2,y2)
% function[d,xd,yd]=distptpt(x1,y1,x2,y2)
% finds the  distance between two points (x1,y1), (x2,y2);
%  Hartmann EDA Toolbox v1, Dec 2004

xd=(x2-x1);
yd=(y2-y1);
d=sqrt((xd.*xd)+(yd.*yd));



