function s = whiskerLength(whisker)
%whiskerLength returns the legth of a whisker. The input whisker should in
%the form of 3xM or 2xM dimension.
%
%   s = whiskerLength(whisker) returns the whisker length
%
% By Yifu
% 2018/03/29

if size(whisker,1) > 3 && size(whisker,2) > 3
    error('Check input dimension.')
elseif size(whisker,1) ~= 2 && size(whisker,1) ~= 3
    whisker = whisker';
end

s = sum(sqrt(sum((whisker(:,2:end) - whisker(:,1:end-1)).^2,1)));

end

