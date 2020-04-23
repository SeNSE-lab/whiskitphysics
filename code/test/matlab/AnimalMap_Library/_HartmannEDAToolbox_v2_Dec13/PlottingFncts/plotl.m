%  Hartmann EDA Toolbox v2, Dec 2013 

function[h]= plotl(x,y,col); %[h]= plotl(x,y,col);
if nargin == 2
    col = 'b';
end;

%h=plot(x,y,col);
linfit(x,y,'y','y');
