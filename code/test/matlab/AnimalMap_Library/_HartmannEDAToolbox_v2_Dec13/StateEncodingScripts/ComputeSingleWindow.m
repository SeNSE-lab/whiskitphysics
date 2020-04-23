function[ReturnMat]=ComputeSingleWindow(data,WinSize)

ReturnMat = zeros(WinSize,(WinSize*2)-1)*NaN;

for j = 1:WinSize
    f1 = data(j:(j-1)+WinSize);
    for i = 1:WinSize
        f2 = data(i:(i-1)+WinSize);
        ReturnRow = xcov(f1,f2);
    end;
    ReturnMat(j,:) = ReturnRow;
end;

