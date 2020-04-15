% Hartmann EDA Toolbox v2, Dec 2013
% PFFTM
% [f,powvec]=pfftm(vec,[sr=10000],'color');
% Quick and easy power spectrum after subtracting the mean of the vector
% no windowing, no detrending.
% Computes abs(fft(vec)).^2/length(vec) and plots it in the color of
% choice.
% sr is the sampling rate, defaults to 10,000 Hz. 

function[f,fftvec]=pfftm(vec,sr,col);

vec=vec-mean(vec);

if nargin==1
	sr=10000;
	col=['b'];
elseif nargin==2
	if isstr(sr)
		col=sr;
		sr=10000;
	else
		col=['b'];
	end;
end;

fftvec=abs(fft(vec))/length(vec);
fftvec=fftvec.*fftvec;

f=mkf(length(vec),sr);
 


if col~=['quiet'];
	plot(f,fftvec,col);
end;