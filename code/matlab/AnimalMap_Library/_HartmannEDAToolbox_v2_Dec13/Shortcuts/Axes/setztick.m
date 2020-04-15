%function[h] = setztick(axisvector)
% returns handle to current axis
%  Hartmann EDA Toolbox v1, Dec 2004

function[h] = setztick(axisvector)
set(gca,'ZTickLabel',axisvector);
set(gca,'ZTick',axisvector);
h=gca;