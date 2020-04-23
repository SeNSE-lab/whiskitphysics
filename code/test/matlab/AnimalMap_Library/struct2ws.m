function struct2ws(s)
%struct2ws assigns field-value pairs in a struct to workspace variables.
%
% By Yifu
% 2018/07/23

if ~isstruct(s), error('Input should be a struct.'); end

names = fieldnames(s);
values = struct2cell(s);
for i = 1:numel(names)
    assignin('base',names{i},values{i});
end

end