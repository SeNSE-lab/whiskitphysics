function longfig
%  Hartmann EDA Toolbox v2, Dec 2013
h=figure;
set(0,'Units','pixels');
ssize = get(0,'ScreenSize');
position = [ssize(1), ssize(4)/2, ssize(3), ssize(4)/2];
set(h,'outerposition', position,'color','w');
set(gca,'FontSize',12);

