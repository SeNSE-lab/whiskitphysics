%  Hartmann EDA Toolbox v1, Dec 2004
function[void]=font16(h);

if nargin<1
   h=gco;
end;

set(h,'FontName','Times');
set(h,'FontSize',16);