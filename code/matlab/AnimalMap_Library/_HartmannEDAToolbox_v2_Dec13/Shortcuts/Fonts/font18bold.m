%  Hartmann EDA Toolbox v1, Dec 2004
function[void]=font18bold(h);

if nargin<1
   h=gco;
end;

set(h,'FontName','Times');
set(h,'FontSize',18);
set(h,'FontWeight','bold');