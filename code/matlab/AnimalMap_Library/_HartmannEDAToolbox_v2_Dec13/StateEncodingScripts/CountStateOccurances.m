
function[bin1c,bin1e,bin2c,bin2e,M]= CountStateOccurrences(var1,nbins1,var2,nbins2);
% [bin1c,bin1e,bin2c,bin2e,M]= CountStateOccurances(var1,nbins1,var2,nbins2);


[n,x,bw] = HistWithBinEdges(var1,nbins1)

xc = x;  % centers of the bins
xel = x-bw/2; xeu = x+bw/2;
xe = [xel,xeu(end)];  % edges of the bins


 