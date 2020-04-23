function whiskername_new = beforeWhisker(whiskername, varargin)
%beforeWhisker generates the name of the whisker before.
%
%   before = beforeWhisker(this) generates the name of the whisker before.
%   before = beforeWhisker(this, maxRow, maxCol) user can specify the max
%   row (defalt 'E') and colomn (defalt '10') in an array.
%
% By Yifu
% 2018/07/18

if length(whiskername) ~= 5
    error('whiskername should be like ''2RB03''.')
end

maxRow = 'E';
maxCol = 10;
if ~isempty(varargin)
    maxRow = varargin{1};
    maxCol = varargin{2};
end

num = str2double(whiskername(1));
side = ~strcmp(whiskername(2), 'L');
row = double(whiskername(3)) - 64;
col = str2double(whiskername(4:end));

if col ~= 1
    whiskername_new = [whiskername(1:3), sprintf('%.2d', col-1)];
elseif row ~= 1
    whiskername_new = [whiskername(1:2), sprintf('%c%.2d', row+63, maxCol)];
elseif side ~= 0
    whiskername_new = [whiskername(1), 'L', sprintf('%c%.2d', maxRow, maxCol)];
elseif num ~= 1
    whiskername_new = sprintf('%dR%c%.2d', num-1, maxRow, maxCol);
else
    error('This is the first whisker.')
end


end

