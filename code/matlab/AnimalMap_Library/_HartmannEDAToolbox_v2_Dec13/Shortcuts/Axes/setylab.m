% function[h] = setylab(axisvector)
% returns a handle to the current axis
%  Hartmann EDA Toolbox v1, Dec 2004

function[h] = setylab(axisvector)
set(gca,'YTickLabel',axisvector);
h=gca;