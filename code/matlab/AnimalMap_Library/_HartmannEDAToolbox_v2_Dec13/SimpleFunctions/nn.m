function[n] = nn(datain)
% n = nn(datain) returns number of NaNs in the variable
n = sum(isnan(datain(:)));