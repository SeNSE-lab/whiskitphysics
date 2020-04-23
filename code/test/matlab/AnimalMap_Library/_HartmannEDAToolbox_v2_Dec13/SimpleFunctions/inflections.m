function [infsup,infsdown] =inflections(f)
% Finds inflection points (zero crossings of the second derivative)
%  Hartmann EDA Toolbox v1, Dec 2004

temp=size(f);

if temp(1)>1 
    if temp(2)==1
        disp('transposing vector');
        f=f';
    else
        disp('error');
        break;
    end;
end;

f1=diff(f);
f2=diff(f1)<0;
ox=diff(f2);
infsdown=find(ox==1) + 2; % indices of crossings

f2=diff(f1)>0;
ox=diff(f2);
infsup=find(ox==1) + 2; % indices of crossings



