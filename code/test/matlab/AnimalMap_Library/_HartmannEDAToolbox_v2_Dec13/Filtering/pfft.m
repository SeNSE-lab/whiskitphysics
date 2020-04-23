% Hartmann EDA Toolbox v2, Dec 2013
% PFFT
% function[f,powvec]=pfft(vec,[sr=10000],'color');
% Quick and easy power spectrum, no windowing, no detrending.
% Computes abs(fft(vec)).^2/length(vec) and plots it color of choice.
% sr is the sampling rate, defaults to 10000 Hz. 

function[f,fftvec]=pfft(vec,sr,col);

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