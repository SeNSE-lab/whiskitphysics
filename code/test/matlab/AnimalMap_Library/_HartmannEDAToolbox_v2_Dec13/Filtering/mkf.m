
% Hartmann EDA Toolbox v2, Dec 2013
% function[f]= mkf(lengthofrun [samplingrate default=10K]);
% Given a sampling rate, generate frequency intervals (for example, for a
% power spectrum plot)

function f=mkf(len,sr);

if nargin==1,
    sr=10000;
end;

f=sr/len:sr/len:sr;
f=f-(sr/len);