function result = cstrcmp(ch1,ch2)
%CSTRCMP compare two char array, in C/C++ version.
%
%   result = cstrcmp(ch1,ch2)   returns 0 if ch1 = ch2
%                               returns 1 if ch1 > ch2
%                               returns -1 if ch1 < ch2
%
% By Yifu
% 2018/02/02

result = 0;
for i = 1:min(length(ch1),length(ch2))
    if ch1(i) < ch2(i)
        result = -1;
        break
    elseif ch1(i) > ch2(i)
        result = 1;
        break
    end
end
if result == 0 && length(ch1) > length(ch2)
    result = 1;
elseif result == 0 && length(ch1) < length(ch2)
    result = -1;
end

end

