% Hartmann EDA Toolbox v1, Dec 2004
% function [void]=dashdot(n)
% Changes the linestyle of object "n" to dashdot
% Default (no input) is current object (n=1)

function [void]=dashdot(n),
if nargin==0
    n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'LineStyle','-.');