function SetUp16Windows
%  Hartmann EDA Toolbox v2, Dec 2013

set(0,'Units','pixels'); ssize = get(0,'ScreenSize');
range = ssize(4)-ssize(4)/15;

%Fig1
h=figure; position = [1, range/4*3+ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig2
h=figure; position = [ssize(3)/4, range/4*3+ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig3
h=figure; position = [ssize(3)/4*2, range/4*3+ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig4
h=figure; position = [ssize(3)/4*3, range/4*3+ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig5
h=figure; position = [1, range/4*2+ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig6
h=figure; position = [ssize(3)/4, range/4*2+ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig7
h=figure; position = [ssize(3)/4*2, range/4*2+ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig8
h=figure; position = [ssize(3)/4*3, range/4*2+ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig9
h=figure; position = [1, range/4+ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig10
h=figure; position = [ssize(3)/4, range/4+ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig11
h=figure; position = [ssize(3)/4*2, range/4+ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig12
h=figure; position = [ssize(3)/4*3, range/4+ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig13
h=figure; position = [1, ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig14
h=figure; position = [ssize(3)/4, ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig15
h=figure; position = [ssize(3)/4*2, ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');

%Fig16
h=figure; position = [ssize(3)/4*3, ssize(4)/15, ssize(3)/4, range/4];
set(h,'outerposition', position,'color','w');
