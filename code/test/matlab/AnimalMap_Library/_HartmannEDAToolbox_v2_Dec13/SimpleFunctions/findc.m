function[idx,valatidx]=findc(run,val,quiet);

% function[index,value_at_index]=findc(vector_in,value_desired,[quiet]);
%
% FINDC determines the value in vector_in closest to value_desired.
% This is useful because the Matlab function "find" does not work unless
% there is an exact match out to the umpteenth decimal place. 
%
% The output argument "value_at_index" is the value in vector_in 
% closest to value_desired. The output argument "index" is the index 
% location of that value in vector_in
%
% If vector_in contains more than one closest match to value_desired, then 
% the output argument index is set to the first location of the closest match.
%
% By default, FINDC echos the results to the screen in the form of a
% matrix.   For details on the matrix, see complete documentation. 
%
% The optional argument quiet (either a string or a number) suppresses the 
% screen echo if set to anything other than the number 0. 
%
%  Hartmann EDA Toolbox v1, Dec 2004


[a,b]=size(run); if a>b, run=run';  end;

quiet=0; if nargin==3, quiet=1; end;

run=run-val;
dum=abs(run);
[y,i]=min(dum);

% choose the 4 points that surround the value for display purposes only
if length(run) <= 5
    idx = 1:length(run);
elseif (i>2 & i<=length(run)-2),
    idx=i-2:i+2;
elseif i==1
    idx = i:i+4;
elseif i==2
    idx = i-1:i+3;
elseif i>length(run)-2
    idx = i-2:length(run);
end;

tempvalatidx=run(idx);

run=run+val;
valatidx=run(idx);

if quiet==0,
    disp('	');
    tempstring=['Closest value is ' num2str(run(i)) ' at index point ' int2str(i)];
    disp(tempstring);
    format short;
    temp=[idx;valatidx;tempvalatidx];
    disp(temp);
    disp('		');
    disp('		');
end;

idx=i;
valatidx=num2str(run(i));