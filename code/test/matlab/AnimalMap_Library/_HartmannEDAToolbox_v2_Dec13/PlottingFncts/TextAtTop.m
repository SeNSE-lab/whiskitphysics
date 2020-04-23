%  Hartmann EDA Toolbox v2, Dec 2013 
% h=TextAtTop(cellin)
% struct in should be of the form numstrings by length of string

function[h]=TextAtTop(cellin)


if isstr(cellin)
    cellin={cellin};
end;


dum=axis;
startpt=dum(4)+.1*(abs(dum(4)-dum(3)));
leftside=dum(1)+.1*(abs(dum(2)-dum(1)));

[a,b]=size(cellin);
offset=0;
allg=[];
for i=1:a
    data=cellin{i,:};
    g=text(leftside,startpt+offset,data);
    allg=[allg,g];
    offset=offset+.1*(abs(dum(4)-dum(3)));
end;
h=allg;
axis([dum(1),dum(2),dum(3),dum(4)+offset+.1*(abs(dum(4)-dum(3)))]);
