function [h] = hline(startpoint,endpoint,level,col);
%%  Hartmann EDA Toolbox v1, Dec 2004
%HLINE					Mitra Hartmann 27 Feb 1997
%
% 	h=hline([startpoint],[endpoint],level,[color]);
%
% 	Draws a horizontal line from startpoint to endpoint, 
%	at the given level.  Bracketed inputs are optional.
%	Omitting startpoint and endpoint
%	draws the line the entire extent of the current axes.
%
%	hline returns a handle h to the line drawn.


if nargin == 1    % user only specified level
    temp=axis;
    x=[temp(1),temp(2)];
    col=['k'];
    vec=startpoint;
    
elseif nargin == 2  % user specified level and color
    temp=axis;
    x=[temp(1),temp(2)];
    col=endpoint;
    vec=startpoint;
    
elseif nargin == 3 % user specified startpoint, endpoint, and level
    x=[startpoint,endpoint];
    vec=level;
    col=['k'];
    
elseif nargin == 4
    x=[startpoint,endpoint];
    vec=level;
end;


g=[];
for i=1:length(vec),
    y=[vec(i),vec(i)];
    hold on;
    h=line(x,y,'color',col);
    g=[g,h];
end;
h=g;