function[ret]=isodd(num)

% ret = isodd(num)
% Returns 1 if num is odd, 0 otherwise.
% Hartmann EDA Toolbox v1, Dec 2004

if abs(rem(num,2))==1
	ret=1;
else
	ret=0;
end;