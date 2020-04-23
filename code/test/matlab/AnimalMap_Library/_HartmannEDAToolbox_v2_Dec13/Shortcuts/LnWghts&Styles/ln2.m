% Hartmann EDA Toolbox v1, Dec 2004
% function [void]=ln2(n)
% Sets the line width of object "n" to 2.
% Default (no input) is current object (n=1)

function [h]=ln2(n),
if nargin==0
	n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'LineWidth',2);

