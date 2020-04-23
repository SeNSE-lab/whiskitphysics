function bigfig
%  Hartmann EDA Toolbox v2, Dec 2013
h=figure;
set(0,'Units','pixels');
ssize = get(0,'ScreenSize');
position = [ssize(1), ssize(4)/15, ssize(3), ssize(4)/15*14];
set(h,'outerposition', position,'color','w');
set(gca,'FontSize',12);
