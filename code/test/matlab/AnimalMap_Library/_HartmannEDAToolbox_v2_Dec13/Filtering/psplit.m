
% Hartmann EDA Toolbox v2, Dec 2013
% function[p]=psplit(matrix)
% finds the power spectrum of each column of matrix
% no detrending, no windowing, simply (abs(fft)/len).^2
% matrix should be of the form (i,:) where there are i trials
% you want fft'ed

function[p]=psplit(matrix)

[a,b]=size(matrix);
p=zeros(size(matrix));
for i=1:a,
    dum=abs(fft(matrix(i,:)))./length(matrix(i,:));
    p(i,:)=dum.*dum;
end;
