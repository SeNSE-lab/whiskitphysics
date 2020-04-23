function[arrayout]=xdif;

%XDIF				Compute horizontal distances	
%   arrayout=xdif;
%	Gets the horizontal difference between input points that the user
%	clicks on. Ignores vertical distances.  Computes mean, median, and std
%	of the horiontal  distances and displays them to the screen.
%   Note that this function is identically equal to tdif
%   MH 29 October 1995
%   Hartmann EDA Toolbox v1, Dec 2004

arrayout=[];

[a,b]=ginput(2);
while ~isempty(a)
    tempdif=a(2)-a(1);
    arrayout=[arrayout,tempdif];
    tempstring=['Difference is ' num2str(tempdif) ];
    disp(tempstring);
    [a,b]=ginput(2);
end;

arrayout=arrayout';
mn=mean(arrayout);
md=median(arrayout);
dev=std(arrayout);

tempstring=['Mean of the differences is: ' num2str(mn)];
disp(tempstring);
tempstring=['Median of the differences is: ' num2str(md)];
disp(tempstring);
tempstring=['Standard Deviation of the differences is: ' num2str(dev)];
disp(tempstring);

