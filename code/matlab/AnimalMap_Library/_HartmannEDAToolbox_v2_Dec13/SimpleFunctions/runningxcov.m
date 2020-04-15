
function[t,xt,x] = runningxcov(vec1,vec2,winsize, shiftwin);   

%  RUNNINGXCOV    Finds the running cross-covariance between two vectors  
%  [t,xt,x] = runningxcov(vec1,vec2,winsize, shiftwin); 
%   
%  vec1 and vec2 are the signals you want to find the xcov of
%  winsize is the window size  (an integer, usually about 1/10 to 1/50 of the
%       length of your data)
%  shiftwin is how many points you want to shift the window over by (an
%         integer, usually about 1/4 to 1/2 of your window size)
%  
%   t is simply a time vector and xt the time lag
%   x is a matrix that contains the running cross covariance
%   The easiest way to plot the output will be something like:
%   pcolor(t,xt,x);shading('flat')
%   
%   The easiest way to explain this function is to walk you through a few
%   iterations of the main loop.
%  
%   (1) The first windows of data are: vec1(1:winsize) and vec2(1:winsize)
%   (2) Find the cross-covariance of the two vectors for that first window 
%       of data and put that result into the first column of matrix x. 
%   (3) Now shift the window over by shiftwin number of points. 
%         This means that the next window of data will be 
%         vec(shiftwin:shiftwin+windowsize-1)
%   (5) Find the cross covariance of the two vectors over that second
%           window of data. and put the result in the *second* column of x.
%    And so forth...
%  
%   Hartmann EDA Toolbox v1, Dec 2004

vec1=vec1(:); vec1=vec1';
vec2=vec2(:); vec2=vec2';

counter=0;  i=1;
while i<=length(vec1)-winsize,
    
    counter=counter+1;
    idx=i:i+winsize-1;
%     dum=[idx(1),idx(end)];disp(dum);
    data1=vec1(idx);
    data2=vec2(idx); 
    dum=xcov(data1,data2);
    x(counter,:)=dum;
    t(counter)=idx(end);
    i=i+shiftwin;
end;

xt= -winsize+1: winsize-1;
x=x';

