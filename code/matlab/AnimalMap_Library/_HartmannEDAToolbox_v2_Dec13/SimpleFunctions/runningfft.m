function[t,f,x] = runningfft (vec1, winsize, shiftwin, SR)   

% RUNNINGFFT      Finds the running abs(fft) of the data
% function[t,f,x] = runningfft (vector, winsize, shiftwin, SR); 
% 
% vector is the signal you want to find the power spctrum of
% winsize is the window size  (an integer, usually about 1/10 to 1/50 of the
%     length of your data)
% shiftwin is how many points you want to shift the window over by (an
%       integer, usually about 1/4 to 1/2 of your window size)
% SR is the sampling rate of the signal
%
% t is simply a time vector and f is a frequency vector
% x is a matrix that contains the running power spectrum
% The easiest way to plot the output will be something like:
% pcolor(t,f,x);shading('flat')
% 
% The easiest way to explain this function is to walk you through a few
% iterations of the main loop.
%
% (1) The first window of data is vector(1:winsize) 
% (2) Find the abs(fft) of that first window of data.   
% (3) Chop off all frequencies higher than Nyquist, and put that result into the first column of matrix x. 
% (4) Now shift the window over by shiftwin number of points. 
%       This means that the next window of data will be 
%       vec(shiftwin:shiftwin+windowsize-1)
% (5) Find the power spectrum of that second window of data.
% (6) Chop off all frequencies higher than Nyquist, and put that result into the *second* column of matrix x. 
%  And so forth...
%
% Hartmann EDA Toolbox v1, Dec 2004

counter=0;  i=1;
while i<=length(vec1)-winsize,
    counter=counter+1;
    idx=i:i+winsize-1;
    data1=vec1(idx);
    dum=abs(fft(data1));
    dum=dum(1:round(length(dum)/2));
    dum=dum';
%      dum=log(dum);
    x(counter,:)=dum;
    t(counter)=idx(end);
    i=i+shiftwin;
end;

xt= 1:(winsize+1)/2;
x=x';

t=t/SR;
f=mkf(length(xt),SR);