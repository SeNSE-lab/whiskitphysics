function[ret]=iseven(num)

% ISEVEN returns 1 if num is even, 0 otherwise. 
% Hartmann EDA Toolbox v1, Dec 2004

if abs(rem(num,2))==0
	ret=1;
else
	ret=0;
end;