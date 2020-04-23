function [flag, index] = searchWhisker(whiskername, s)
%searchWhisker searches the specified whisker in a rearranged data struct. 
%If exists, returns the index of that whisker; if not, returns the index
%for insersion.
%
%   [flag, index] = searchWhisker(whiskername, struct) intakes the 
%   whisker you want to search by 'whiskername' and search space, returns
%   the index of that whisker. If non-existence, returns the index for
%   potential insersion operation.
%
% By Yifu
% 2018/07/18

if length(whiskername) ~= 5
    error('whiskername should be like ''2RB03''.')
end

num = str2double(whiskername(1));
side = ~strcmp(whiskername(2), 'L');
row = double(whiskername(3)) - 64;
col = str2double(whiskername(4:end));

index = find(s.AnimalNum == num & s.Side == side &...
    s.Row == row & s.Col == col);
flag = ~isempty(index);

%% If whisker does not exist
if flag == 0
    found = 0;
    while (~found)
        whiskername = beforeWhisker(whiskername);
        [found, index] = searchWhisker(whiskername,s);
    end
    index = index + 1;
end

end




