%  Hartmann EDA Toolbox v2, Dec 2013 
% VLINE					Mitra Hartmann 27 Feb 1997
%
% 	vline([startpoint],[endpoint],level,[color]);

% 	Draws a vertical line from startpoint to endpoint, 
%	at the given level.  Omitting startpoint and endpoint
%	draws the line the entire extent of the current axes.
%
%	Vline returns a handle h to the line drawn.

% vec takes the place of level


function [h] = vline(startpoint,endpoint,level,color);

disp(nargout);

if nargin==1 
   if strcmp(get(gca,'Yscale'),'log') ==1,
	  temp=get(gca,'Ytick');
	  y=[temp(1),temp(end)];
   else
	  temp=axis;
	  y=[temp(3),temp(4)];
   end;
	color=['k'];
	vec=startpoint;
end;

if nargin==2
   if strcmp(get(gca,'Yscale'),'log') ==1,
	  temp=get(gca,'Ytick');
	  y=[temp(1),temp(end)];
   else
	  temp=axis;
	  y=[temp(3),temp(4)];
   end;
	color=endpoint;
	vec=startpoint;
end;

if nargin==3 
        y=[startpoint,endpoint];
        vec=level;
	color=['k'];
end;


if nargin == 4
        y=[startpoint,endpoint];
        vec=level;
end;

chltype=0;
ltype=['-'];
if length(color)>1
	% a line type has been specified
	ltype=color(2:end);
	changeltype=1;
end;
color=color(1);
g=[];
for i=1:length(vec),
	x=[vec(i),vec(i)];
	h=line(x,y,'color',color);
	hold on;
	g=[g,h];
end;
set(g,'LineStyle',ltype);

h=g;


