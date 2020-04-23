function [void]=magenta(n),
% turns the object magenta
%  Hartmann EDA Toolbox v1, Dec 2004
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'Color',[1,0,1]);