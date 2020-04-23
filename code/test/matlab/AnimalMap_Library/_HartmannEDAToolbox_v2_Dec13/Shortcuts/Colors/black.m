%  Hartmann EDA Toolbox v1, Dec 2004
function [void]=black(n),
% turns the object black
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'Color',[0,0,0]);