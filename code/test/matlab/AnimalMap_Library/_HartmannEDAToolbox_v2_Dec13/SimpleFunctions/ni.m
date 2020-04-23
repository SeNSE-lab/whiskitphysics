function[n] = ni(datain);
% n = ni(datain) returns number of Infs in the variable
n = sum(isinf(datain(:)));