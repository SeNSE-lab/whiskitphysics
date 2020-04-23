%  Hartmann EDA Toolbox v2, Dec 2013 
function [void]=rm(n),
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'Visible','off');