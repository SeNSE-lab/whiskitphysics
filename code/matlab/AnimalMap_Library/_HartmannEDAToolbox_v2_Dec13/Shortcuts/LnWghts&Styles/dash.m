% Hartmann EDA toolbox v1, Dec 2004
% function [void]=dash(n)
% Changes the linestyle of object "n" to dashed
% Default (no input) is current object (n=1)

function [void]=dash(n),
if nargin==0
    n=1;
end;
h=get(gca,'Children');
h=h(n);
set(h,'LineStyle','--');