%  Hartmann EDA Toolbox v1, Dec 2004
function [void]=dblue(n),
% turns the object dark blue
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'color',[0.3,.1,.8]);