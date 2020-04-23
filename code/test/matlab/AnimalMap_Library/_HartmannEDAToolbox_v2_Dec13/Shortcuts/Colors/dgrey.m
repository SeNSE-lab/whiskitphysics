%  Hartmann EDA Toolbox v1, Dec 2004
function [void]=dgrey(n),
% turns the object grey
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'Color',[.5,.5,.5]);