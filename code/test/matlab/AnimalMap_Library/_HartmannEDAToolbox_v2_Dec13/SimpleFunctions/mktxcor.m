function t=mktxcor(rname,SR,form);
  
% MKTXCOR	            Make a time vector against which to plot cross correlation of data
% function[t]=mktxcor(N,[SR=10000],['m'])
%
% Generate a time vector (in units of seconds or milliseconds) of length N
% samples, while assuming a sample rate of SR.   SR defaults to 10000 Hz. 
% By default, t is generated in units of seconds.  Set the last optional
% argument to 'm' to generate the t vector in milliseconds.  Set the last
% optional argument to 'p' to generate the vector in samples.
%
% Hartmann EDA Toolbox v1, Dec 2004


if nargin==1
	SR=10000; form='m'; 
    
elseif nargin==2,
	if isstr(SR)        % user input rname and form
        form = SR;
		SR=10000;
    else                % user input rname and SR
		form='m';
	end;
end;

if form~=['s'] & form~=['m'] & form~=['p'],
	disp('Unknown last optional argument.  Creating t in msecs');
	form=['m'];
end;


if length(rname)==1,
	len=rname;
else
	len=length(rname);
end;

intvl=1/SR;	
eval(['t=intvl:intvl:len/SR;']);

if form==['m'],
	t=t*1000;
elseif form==['p']
	t=t*10000;
end;

temp=ceil(length(t)/2);
t=t(1:temp);
t2=-t;
t2=sort(t2);
t=[t2,t];
eval(['t=t(1:len);']);

