
%  Hartmann EDA Toolbox v2, Dec 2013 
% PLOTV
%
% function[h]=plotv(twovector,[col]);
% prevents you having to type  plot(vec(:,1),vec(:,2)) all the time
% b=[ (x1,y1)
%     (x2,y2)
%     (x3,y3) ...
%     (xn,yn)];

function[h]=plotv(twovector,colr);

if nargin==1,
	colr=['b'];
end;

dum=size(twovector);
if dum(2)~=2
	twovector=twovector';
end;
h=plot(twovector(:,1),twovector(:,2),colr);
