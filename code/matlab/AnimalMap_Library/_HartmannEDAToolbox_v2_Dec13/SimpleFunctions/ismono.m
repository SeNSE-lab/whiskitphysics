
function[ret]= ismono(vec);

% function [ret] = ismono(vec);
% returns 1 if values in vec are monotonically increasing or decreasing,
% otherwise returns 0
% Hartmann EDA Toolbox v1, Dec 2004

tempvec=diff(vec);
if (all(tempvec>0)) | (all(tempvec<0))
	ret=1;
else
	ret=0;
end;