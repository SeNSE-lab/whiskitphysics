% function[h] = setytick(axisvector)
% returns handle to current axis
%  Hartmann EDA Toolbox v1, Dec 2004

function[h] = setytick(axisvector)
if ismono(axisvector)
	set(gca,'YTick',axisvector);
end;
set(gca,'YTickLabel',axisvector);
h=gca;
