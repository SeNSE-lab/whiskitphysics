function[t,g]=gaussian(xbar,sigm,col);

% function[t,g]=gaussian(xbar,sigma,[color]);
% 	OR
% function[t,g]=gaussian(vector,[color]);
%
% Creates a gaussian with mean x and std sigm
%	OR
% Creates a gaussian with mean x=mean(vector) and std=std(vector)
%
% g  =  [ 1/(sigm*sqrt(2*pi)) ] * [exp (  (-(t-xbar).^2)  / (2*sigm*sigm) ) ] 
% t is a vector that ranges from minus 5 sigma to plus 5 sigma against which to plot g.
%
% Hartmann EDA Toolbox v1, Dec 2004


if nargin==1,
	vec=xbar;
	if any(isnan(vec)), 
	    [xbar,sigm]=nmean(vec);
	else
	    xbar=mean(vec);	    
	    sigm=std(vec);
	end;
	col=['b'];

elseif nargin==2,
	% either input vector and color
		if isstr(sigm),
			vec=xbar;
			col=sigm;
			
			if any(isnan(vec)), 
			    [xbar,sigm]=nmean(vec);
			else
			    xbar=mean(vec);	    
			    sigm=std(vec);
			end;			
		else	
	% or input xbar and sigm, with no color specified
			col=['b'];
		end;
end;

len= 2* (xbar + (5*sigm));
ival=len/1000;
t=xbar-(5*sigm):ival:xbar+(5*sigm);
part1=1/(sigm*sqrt(2*pi));

num=-(t-xbar).*(t-xbar);
dem=(2*sigm*sigm);

eterm=exp(num/dem);

g=part1*eterm;

g=g/sum(g);	% normalize area under curve to exactly equal one

% plot(t,g,col);


