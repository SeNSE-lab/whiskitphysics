function [void]=purple(n),
% turns the object purple
%  Hartmann EDA Toolbox v1, Dec 2004
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'Color',[.6,.2,.9]);