%  Hartmann EDA Toolbox v1, Dec 2004
% setxlabelpos sets the position of the xlabel
% function[h]=setxlabelpos([ top | cap | middle | baseline | bottom ]);
% input must be a string (in quotes);
% returns handle to the xlable

function[h]=setxlabelpos(choice);

h=gca
g=get(gca,'XLabel')
h=set(g,'VerticalAlignment', choice)