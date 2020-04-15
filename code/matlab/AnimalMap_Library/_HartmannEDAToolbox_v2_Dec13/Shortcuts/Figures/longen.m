function longen
% make a long figure at the top of the screen
% Hartmann EDA Toolbox v2, Feb 2013
set(0,'Units','pixels');
ssize = get(0,'ScreenSize');
position = [ssize(1), ssize(4)/2, ssize(3), ssize(4)/2];
set(gcf,'outerposition', position);
set(gca,'FontSize',12);


