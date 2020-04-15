% Hartmann EDA Toolbox v2, December 2013
% ENVELOPE				Mitra Hartmann, 15 March, 1997
% 
% 	Compute the envelope of a waveform by removing all positive frequency 
%	components.  It leaves f0 and Nyquist.  This function has not been tested on 
%   matrices, only vectors. 
%
%	The analytic signal is what one gets by removing all negative frequency terms 
%   from the signal.  The envelope is then given by the absolute value of the analytic 
%	signal
%
%   Note that if the signal is narrow band the envelope is identical to
%       sqrt(2*bpfft(signal.*signal,SR,0,midvalue));

function d=envelope(waveform)

[leni,lenj]=size(waveform);
if leni>lenj
	waveform=waveform';
end;
[leni,lenj]=size(waveform);
d=zeros(size(waveform));

for i=1:leni,
	temp=fft(waveform(i,:));
	templen=length(temp);
	hlf=floor(templen/2);
	temp(2:hlf-1)=zeros(size(2:hlf-1));
	d(i,:)=2*abs(ifft(temp));
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % testing what happens if you remove positive instead of 
% % negative frequencies:
% 
% 	temp=fft(waveform(i,:));
% 	temp(hlf+1:templen)=zeros(size(hlf+1:templen));
% 	dtest(i,:)=2*abs(ifft(temp));
% fig;
% plot(d,'r');
% hold on;
% plot(dtest,'b');
% axx(1,1000);
% title('neg removed in red, pos removed in blue');
% pause;
% close;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%