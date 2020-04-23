function smallen
%  Hartmann EDA Toolbox v2, Dec 2013
set(0,'Units','pixels');
ssize = get(0,'ScreenSize');
top = get(gcf,'outerposition')-get(gcf,'position'); top = top(4);
position = [ssize(3)/2-ssize(4)/8, ssize(4)/8*3, ssize(4)/4, ssize(4)/4+top];
set(gcf,'outerposition', position,'color','w');
set(gca,'FontSize',12);
figure(gcf);