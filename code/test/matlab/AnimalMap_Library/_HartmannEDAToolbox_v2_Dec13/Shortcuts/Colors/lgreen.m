function [void]=lgreen(n),
%  Hartmann EDA Toolbox v1, Dec 2004
% turns the object light green
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'color',[0.2,.9,.5]);