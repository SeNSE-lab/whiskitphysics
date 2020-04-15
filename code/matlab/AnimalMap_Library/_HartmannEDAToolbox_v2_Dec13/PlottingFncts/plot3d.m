% NEW
%  Hartmann EDA Toolbox v2, Dec 2013
% PLOT3D
%
% function[h]=plot3d(threevector,[col]);
% Prevents you having to type  plot(vec(:,1),vec(:,2),vec(:,3)) when you
% use the command plot3
 

function[h]=plot3d(threevector,colr);

if nargin==1,
	colr=['b'];
end;

dum=size(threevector);
if dum(2)~=3
	threevector=threevector';
end;
h=plot3(threevector(:,1),threevector(:,2),threevector(:,3),colr);
