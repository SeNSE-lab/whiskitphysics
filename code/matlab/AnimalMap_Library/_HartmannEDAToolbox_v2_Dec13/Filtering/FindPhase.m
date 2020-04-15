%  Hartmann EDA Toolbox v2, Dec 2013
%%% wow, this is an ugly code! someone should clean it up!

% Computationally, the Hilbert Transform is the Fourier
% Transform with zero amplitude at all negative frequenices.  This
% is equivalent to phase-shifting the time-domain signal by 90 degrees
% at all frequencies and then adding this as an imaginary signal to the
% original signal.
% So for example, the signal cos(t) becomes cos(t) + i sin(t).
%
%The phase of the original signal is taken as the angle of this new
%complex signal.
%
%inputs -
%    signal  - vector containing whisker angle
%    Fs   - sampling rate (Hz)
%    bp - frequency range for band-pass filtering
%
%outputs -
%    phase  - phase estimate from Hilbert transform
%    filtered_signal - input signal after filtering
%
% function  [phase, filtered_sig] = phase_from_hilbert( signal, Fs, bp )
%%     % de-trend the signal with a band-pass filter
%     % you may need the signal processing toolbox ....
%     bp = bp * 2 / Fs; % convert Hz to radians/S
%     [N, Wn] = buttord( bp, bp .* [.5 1.5], 3, 20);
%     [B,A] = butter(N,Wn);
%     filtered_sig = filtfilt(B,A,signal); % zero-phase filtering
%
%
%
%%%% everything above is from Dan Hill.  I modified Jan 02 2011 to not
%%%% filter the data
%
% [phase] = phase_from_hilbert( signal, Fs);


function  [phase] = phase_from_hilbert( signal, Fs)

disp('this code needs some cleanup');

% remove negative frequency component of fourier transform
X = fft(signal);
halfway = 1 + ceil(length(X)/2);
X(  halfway:end) = 0 ;
ht_signal = ifft(X);

% keep phase
phase = angle( ht_signal );
