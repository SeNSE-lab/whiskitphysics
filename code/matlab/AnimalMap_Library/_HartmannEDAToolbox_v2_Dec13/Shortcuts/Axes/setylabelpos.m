% setylabelpos sets the position of the ylabel
% function[h]=setylabelpos([ top | cap | middle | baseline | bottom ]);
% input must be a string (in quotes);
% returns handle to the ylable
%  Hartmann EDA Toolbox v1, Dec 2004

function[h]=setylabelpos(choice);

h=gca;  
g=get(gca,'YLabel');
h=set(g,'VerticalAlignment', choice);