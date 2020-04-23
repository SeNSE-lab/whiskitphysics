function d=mksin(frequency,samplerate,len,phs);
%
% MKSIN				Mitra Hartmann, 13 March 1997
%				
% d=mksin(frequency,samplerate,length,[phase]);
% Creates a sine wave of desired length, given frequency and sampling rate
% Last input (phase) is optional and defaults to zero.
% Hartmann EDA Toolbox v1, Dec 2004

% User wants frequency full cycles within the given sample rate.
% To find the number of points in ONE full cycle, divide the two

PtsPerCycle=samplerate/frequency;

% waveform must go from 0 to 2pi in those number of points, so to find the
% appropriate interval, divide 2pi by pts per cycle

x=((2*pi)/PtsPerCycle);
y=x:x:len*x;

if nargin==4
    PhasePoints=(phs/(2*pi))*PtsPerCycle;
    %shft=PtsPerCycle/PhasePoints;
    y=y+PhasePoints*x;
end;
d=sin(y);
