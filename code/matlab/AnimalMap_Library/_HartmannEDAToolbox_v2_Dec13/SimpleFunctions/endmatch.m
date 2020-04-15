function [longvec] = EndMatch(vec);
% longvec = EndMatch(vec);
%
% Endmatch is generally used in conjunction with bpfft or another filter. 
%
% Suppose you have a signal whose first point has a value of 8 and whose
% last point has a value of 100.   You want to filter the signal (using 
% bpfft, for example) to look at  a particular frequency range.  
% Because the fft assumes infinitely repeating data, the discontinuity 
% between the last and first point will give you bad ringing near the
% edges.
%
% One way to solve this problem is to "detrend" the
% data, but this only works if the best straight-line linear fit really
% does succeed in matching up the first and last points, which often
% doesn't happen. Detrending also changes the mean of the data.   
%
% An alternative  approach is to simply add a bunch of points onto the 
% end of your vector that slowly connect up the endpoint with a point at
% the same value as your start point.   It doesn't really matter how long
% it takes for the points to match up as long as they eventually do so. 
%
% EndMatch matches up the two ends of the vector with a line the length of
% the vector.  The output argument longvec is of length 2*length(vec)
%
%  Hartmann EDA Toolbox v1, Dec 2004

x1=length(vec);
x2=2*length(vec);
y1=vec(end);
y2=vec(1);
x=[x1,x2]; y=[y1,y2];

[m,b]=linfit(x,y,'n','n');
x=x1:x2;
y=m*x+b;

longvec=vec;
longvec(x)=y;