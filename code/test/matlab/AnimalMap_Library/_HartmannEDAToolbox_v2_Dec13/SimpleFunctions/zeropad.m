function[retvec]=zeropad(vec,desiredlength,option);
% ZEROPAD       Pad a vector with zeros
% function[retvec]=zeropad(vec,desiredlength,'option');
% option can be 's' or 'start'
%		'e' or 'end'
%		'se' or 'both'  (default)
%
% If desiredlength is less than the length of the vector, the 
% program assumes you want to add on that many zeros.  Otherwise
% it assumes the final vector should end up being the desired 
% length
% Hartmann EDA Toolbox v1, Dec 2004

[a,b]=size(vec);
if a>b
	vec=vec';
end;

lenvec=length(vec);

lenneeded=desiredlength-lenvec;

if lenneeded<0,
	tempstring=['assuming you wish to add ' int2str(desiredlength) ' more zeros on.'];
	disp(tempstring);
	lenneeded=desiredlength;
end;

nopt = nan;
if nargin==2,
	option=['se'];
end
if  strcmp(option, 'se') | strcmp(option,'both'),
        nopt = 0;
elseif  strcmp(option, 'start') | strcmp(option, 's')
        nopt = 1;
elseif  strcmp(option, 'end') | strcmp(option, 'e')
        nopt = 2;
end
if isnan(nopt)
        error('Unknown OPTION')
end


if nopt==0
	halflenneeded=floor(lenneeded/2);
	retvec=[zeros(1,halflenneeded),vec,zeros(1,halflenneeded)];
	if isodd(lenneeded),
		disp('adding an extra zero on to the end');
		retvec(end+1)=0;
	end;

elseif nopt==1,
	retvec=[zeros(1,lenneeded),vec];
elseif nopt==2,
	retvec=[vec,zeros(1,lenneeded)];
end;