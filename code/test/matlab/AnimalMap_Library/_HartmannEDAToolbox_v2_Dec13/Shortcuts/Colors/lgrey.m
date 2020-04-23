function [void]=lgrey(n)
%  Hartmann EDA Toolbox v1, Dec 2004
% turns the object grey
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'Color',[.85,.85,.85]);