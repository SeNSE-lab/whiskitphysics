%function[h] = setxtick(axisvector)
% returns handle to current axis
%  Hartmann EDA Toolbox v1, Dec 2004

function[h] = setxtick(axisvector)
set(gca,'XTickLabel',axisvector);
set(gca,'XTick',axisvector);
h=gca;