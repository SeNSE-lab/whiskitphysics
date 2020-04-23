%  Hartmann EDA Toolbox v1, Dec 2004
function [void]=lblue(n),
% turns the object light blue
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'color',[0,0.7,.9]);