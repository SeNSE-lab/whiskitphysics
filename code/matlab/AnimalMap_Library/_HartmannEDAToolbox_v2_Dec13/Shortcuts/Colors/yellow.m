function [void]=yellow(n),
% turns the object yellow
%  Hartmann EDA Toolbox v1, Dec 2004
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'Color',[1,.8,0]);