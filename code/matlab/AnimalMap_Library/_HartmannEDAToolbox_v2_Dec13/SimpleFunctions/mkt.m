function[t]=mkt(n,SR,typ)

% MKT		            Make a time vector against which to plot data
% function[t]=mkt(N,[SR=10000],['m'])
%
% Generate a time vector (in units of seconds or milliseconds) of length N
% samples, while assuming a sample rate of SR.   SR defaults to 10000 Hz. 
% By default, t is generated in units of seconds.  Set the last optional
% argument to 'm' to generate the t vector  in milliseconds
%
% Hartmann EDA Toolbox v1, Dec 2004



if nargin==1,
	SR=10000;
	typ=['s'];
elseif nargin==2
	if isstr(SR)
		typ=SR;
		SR=10000;
	else
		typ=['s'];
	end;
end;

if isstr(n)
	disp('must input vector length, not name'); 
else
	neededlength=n;
end;

intvl=1/SR;
t=intvl:intvl:(neededlength/SR);


if typ==['m'],
	t=t*1000;
end;
