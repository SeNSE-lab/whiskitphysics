% CAX
% 	function[void]=cax(lower,upper); 
%	Rescales coloraxis and adds the colorbar
%  Hartmann EDA Toolbox v1, Dec 2004

function[void]=cax(a,b);

caxis([a,b]);
colorbar;


