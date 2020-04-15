function x = unMNnFS(y,lb,ub)
%unMNnFS un- mean normalization and feature scaling
%
%   x = unMNnFS(y,lb,ub) returns the original data set x from data set y
%   that has been applied with mean normalization and feature scaling, by
%   using the lower and upper bound. The input data set should range from
%   -1 to 1. The output data set range from
    if ~all(y>-1 & y<1), error('Inputs are not within the range of [-1 1]!'); end
    x = (y.*(ub-lb)+ub+lb)/2;

end

