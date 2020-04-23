%YDIF					29 October 1995
%
%	Gets the y axis difference between input points
%

function[arrayout]=ydif;

arrayout=[];

[a,b]=ginput(2);
while ~isempty(a)
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

if max(size(arrayout))>=2,

tempstring=['Mean of the differences is: ' num2str(mn)];
	disp(tempstring);
tempstring=['Median of the differences is: ' num2str(md)];
	disp(tempstring);
tempstring=['Standard Deviation of the differences is: ' num2str(dev)];
	disp(tempstring);
end;