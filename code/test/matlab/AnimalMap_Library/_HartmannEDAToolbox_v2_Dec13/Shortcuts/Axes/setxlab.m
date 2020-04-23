% function h = setxlab(axisvector)
% returns a handle to the current axis
%  Hartmann EDA Toolbox v1, Dec 2004

function[h] = setxlab(axisvector)
set(gca,'XTickLabel',axisvector);
h=gca;