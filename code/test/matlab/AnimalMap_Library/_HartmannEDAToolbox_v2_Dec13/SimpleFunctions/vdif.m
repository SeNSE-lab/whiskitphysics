function[arrayout]=vdif;

% VDIF			Compute vertical distances		
%  arrayout=vdif;
%  	Gets the vertical  difference between input points that the user clicks
%  	on. Ignores horizontal distances.  Computes mean, median, and std of
%  	the vertical  distances and displays them to the screen.
%   Note that this function is identically equal to ydif 
%   MJH - 29 October 1995
%   Hartmann EDA Toolbox v1, Dec 2004


arrayout=[];

[a,b]=ginput(2);
while ~isempty(b)
	tempdif=b(2)-b(1);
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

