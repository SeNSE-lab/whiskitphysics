function [void]=orange(n),
% turns the object orange
%  Hartmann EDA Toolbox v1, Dec 2004
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'Color',[1,.6,0]);