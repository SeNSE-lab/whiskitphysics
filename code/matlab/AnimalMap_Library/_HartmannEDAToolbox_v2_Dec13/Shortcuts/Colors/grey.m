%  Hartmann EDA Toolbox v1, Dec 2004
function [void]=grey(n),
% turns the object grey
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'Color',[.65,.65,.65]);