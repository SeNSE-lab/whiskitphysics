function idx = findWHindex(WH_Names,wh)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

idx = 0;
for i = 1:size(WH_Names,1)
    if strcmp(wh,WH_Names(i,1:4))
        idx = i;
        break;
    end
end

end

