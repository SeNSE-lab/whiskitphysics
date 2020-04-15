function[c,d]=invunc(a,b)

% INVUNC        Calculate inverse uncertainty
% function[c,d]=invunc(a,b)
% 
% Suppose you have some quantity with an error, such as 10 +- 2.
% You want to find 1/(10+-2).  
% This function returns c=1/a and d= the appropriate uncertainty.
% The trick is that whatever percentage of a b is, you want
% d to be that same percentage of c.
%  Hartmann EDA Toolbox v1, Dec 2004

% b=x percent of a 
% b=(x)*(100)*(a);
% 100ax=b
x=b./a;

% now find d that is x percent of c =1/a

c=1./a;
d=x.*c;



