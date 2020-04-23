function[h,v]=rmbox(c,lw);
%  Hartmann EDA Toolbox v1, Dec 2004
% function[h,v]=rmbox(c,lw);
% removes the boundary box and replaces it with plain black lines

if nargin<1
    c=0.005;
    lw='ln1';
elseif nargin==1
    lw='ln1';
end;


h=gca; a=axis;
 set(h,'Box','off');
% h=hline(a(1),a(2),a(4)-c*(a(4)-a(3)),'k');eval(lw);
% v=vline(a(3),a(4),a(2),'k');eval(lw);


