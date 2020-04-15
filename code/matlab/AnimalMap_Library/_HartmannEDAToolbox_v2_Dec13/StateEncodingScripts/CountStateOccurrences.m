function[bin1c,bin1e,bin2c,bin2e,M]= CountStateOccurrences(var1,nbins1,var2,nbins2);
% [bin1c,bin1e,bin2c,bin2e,M]= CountStateOccurrences(var1,nbins1,var2,nbins2);

[n,x,bw] = HistWithBinEdges(var1,nbins1);
bin1c = x;  % centers of the bins
xel = x-bw/2; xeu = x+bw/2;
bin1e = [xel,xeu(end)];  % edges of the bins for variable 1
clear xel xeu;
[n,x,bw] = HistWithBinEdges(var2,nbins2);
bin2c = x;  % centers of the bins
xel = x-bw/2; xeu = x+bw/2;
bin2e = [xel,xeu(end)];  % edges of the bins for variable 2
clear xel xeu;

M = zeros(nbins1,nbins2);

for i = 1:length(var1)  % assume var1 and var2 are the same length
    dum = bin1e - var1(i);
    if var1(i) == min(var1)
        bin1 = 1;
    elseif var1(i) == max(var1)
        bin1 = nbins1;
    else
        a = find (dum > 0);
        bin1 = a(1)-1;
    end;
    dum = bin2e - var2(i);
    if var2(i) == min(var2)
        bin2 = 1;
    elseif var2(i) == max(var2)
        bin2 = nbins2;
    else
        a = find (dum > 0);
        bin2 = a(1)-1;
    end;
    M(bin1,bin2) = M(bin1,bin2)+1;
end;



