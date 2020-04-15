
%  Hartmann EDA Toolbox v2, Dec 2013 
% RECT
% h=rect(lowerleft,upperright,[color])
%
% Plots the rectangle specified by points at the lowerleft and upperright.  
% Returns a graphics handle to a patch. 
%
% Example: h=rect([0,.5], [2,3], 'b') draws a blue rectangle whose bottom
% left corner is at [0,.5] and whose top right corner is at [2,3].
%
% Mitra Hartmann, 1997

function h=rect(lowerleft,upperright,col)

if nargin==1,
    disp('function h=rect(lowerleft,upperright,[color])');
elseif nargin==2,
    col=['k'];
end;

xlo=lowerleft(1); ylo=lowerleft(2);
xhi=upperright(1);yhi=upperright(2);

x=[xlo,xlo,xhi,xhi];
y=[ylo,yhi,yhi,ylo];
h=patch(x,y,col);
set(h,'EdgeColor','none');
