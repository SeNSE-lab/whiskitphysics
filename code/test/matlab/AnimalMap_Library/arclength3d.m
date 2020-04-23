function [s_total,s,ds] = arclength3d(x,y,z,varargin)
%% * function [s_total,s,ds] = arclength(x,y,z,{nNodes})

%Returns the arc length of curve defined by (x,y).
% INPUTS:
%   x = x-coordinates
%   y = y-coordinates
%   varargin:
%       {1}: nNodes - number of sample nodes
% OUTPUTS:
%   s_total = total arc length
%   s = arclength at each (x,y) (starts at zero, ends at s_tot)
%   ds = diff(s)
% Written by Joe Solomon for elasticaPB
% Revised:
%   + March 24, 2009 - Brian Quist - added nNodes sampling capability
%   + March 13, 2010 - Brian Quist - handle (x,y) as column 

if size(x,2) == min(size(x)),
    x = x';
end
if size(y,2) == min(size(y)),
    y = y';
end
if size(z,2) == min(size(z)),
    z = z';
end

if nargin > 3,
    nNodes = varargin{1};
    if nNodes < length(x)
        index = round(1:(length(x)-1)/(nNodes-1):length(x));
        x = x(index);
        y = y(index);
        z = z(index);
    end
end

ds = sqrt((x(2:end)-x(1:end-1)).^2+((y(2:end)-y(1:end-1)).^2+((z(2:end)-z(1:end-1)).^2)));
s = [0 cumsum(ds)];
s_total = s(end);