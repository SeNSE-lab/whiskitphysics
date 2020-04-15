function y = MNnFS(x,lb,ub)
%MNnFS Mean normalization and feature scaling.
%
%   y = MNnFS(x,lb,ub) applies mean normalization and feature scaling to
%   the data set x by using its lower and upper bounds. The output data set
%   y ranges from -1 to 1.
%
% By Yifu
% 2018/1/16

    if ~all(x>lb & x<ub), error('Input exceeds boundaries!'); end
    y = (2*x-ub-lb)./(ub-lb);

end

