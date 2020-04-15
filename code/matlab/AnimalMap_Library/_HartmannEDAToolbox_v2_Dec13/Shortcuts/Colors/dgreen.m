%  Hartmann EDA Toolbox v1, Dec 2004
function [void]=dgreen(n),
% turns the object dark green
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'color',[0.2,.6,.3]);