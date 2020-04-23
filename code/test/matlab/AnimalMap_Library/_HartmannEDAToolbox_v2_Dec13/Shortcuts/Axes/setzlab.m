% function h = setzlab(axisvector), returns a handle to the current z axis
%  Hartmann EDA Toolbox v1, Dec 2004

function[h] = setzlab(axisvector)
set(gca,'ZTickLabel',axisvector);
h=gca;