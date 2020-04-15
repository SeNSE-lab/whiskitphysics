function [filt_data] = butter_lowpass(input_data,n,fc,fs,plotyn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Chris Schroeder
%Version 1.0 (2/1/2013)
%
%[output_data] = butter_lowpass(input_data,n,fc,fs,plotyn)
%
% This is a simple function to create a Butterworth filter with a set order
% and cutoff frequency and filter data through that filter. 
%
% INPUTS
%     input_data = raw input data (in samples at fs)
%     n = order of the Butterworth filter (1 works well for M,FX, etc.)
%     fc = desired cutoff frequency in Hz
%     fs = sampling rate in Hz
%     plotyn = plot variable, 1 for plotting, omit or 0 for no plotting
%
% OUTPUTS
%     filt_data = filtered output with the set parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 4
    plotyn = 0;
end

%Filter cutoff frequency is expressed as a fraction from 0 to 1 of the
%Nyquist frequency
Wn = fc/(0.5*fs);

%Set up the Butterworth filter poles and zeros
[b,a]=butter(n,Wn);

%Filter the data
% % filter_data=filter(b,a,input_data);
filt_data = filtfilt(b,a,input_data);

%Plot if wanted
if plotyn == 1
    fig;
    plot(input_data,'b');ho;
    plot(filt_data,'r');
    zoom on;
end


