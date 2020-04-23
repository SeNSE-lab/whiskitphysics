function[ReturnRow]=ComputeSingleRow(data,WinSize)

f1 = data(1:WinSize);
for i = 1:WinSize
    f2 = data(i:(i-1)+WinSize);
    f1short = f1(i:WinSize);
    f2short = f2(i:WinSize);
    ReturnRow(i) = sum(f1short.*f2short);
end;
