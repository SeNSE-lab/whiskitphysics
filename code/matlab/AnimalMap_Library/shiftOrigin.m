function point = shiftOrigin(point,to)
%shiftOrigin Shift the origin of the basepoints and whiskers
%
%   points_shifted = shiftOrigin(points, origin) The function takes
%   the basepoints and whiskers points as Nx1 cell array, and shifts the
%   origin to a new one.
%
% By Yifu
% 2018/01/24

for i = 1:size(point,1), point{i,1} = point{i,1} + to; end


end

