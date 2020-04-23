function[returnav,returnmat] = STA(stimvec,spikevec,winsize)
% [returnav,returnmat] = STA(stimvec,spikevec,winsize)
% Spike Triggered Average
%
% There are six possibliites.  So far this code only works
% for cases 1, 2, and 4.
% (1) An N-points stimulus vector, and an N-points spikevector
% (2) An N-points stimulus vector, and an M-trials by N-points spikematrix
% (3) An M-trials by N-points stimulus vector and M by N spikematrix
% (4) An N-points stimulus vector, and an P-points spiketimes list
% (5) An N-points stimulus vector, and M-trials by P-points spiketimes
% (6) An M-trials by N-points stimulus vector and M by P spiketimes

[astim,bstim]=size(stimvec);
[aspike,bspike]=size(spikevec);
if rem(winsize,2)~=0
    disp('rounding winsize');
    winsize = round(winsize);
end;

if (astim == 1 | bstim == 1)   & (aspike == 1 | bspike == 1)
    %  Assuming M-trials greater than one, this condition ensures we have
    %  either case 1 or case 4.
    if length(stimvec) == length(spikevec)
        % This ensures case 1, unless the neuron spiked at every point
        disp('Assuming case 1:  N-point stimulus, N-point spikevec of zeros and ones');
        spikevec = find(spikevec == 1);
    else
        disp('Assuming case 4:  N-point stimulus, P-point list of spiketimes');
    end;
    b = find(spikevec<=winsize);
    spikevec(b) =[];
    b = find(spikevec>=length(stimvec)-winsize);
    spikevec(b) = [];
    returnmat = zeros(length(spikevec),winsize+1);
    for i = 1:length(spikevec)
        returnmat(i,:) = stimvec(spikevec(i)-winsize/2:spikevec(i)+winsize/2);
    end;
    returnav = mean(returnmat);
end;

if (astim == 1 | bstim == 1)   & (aspike > 1 & bspike > 1)
    %  Assuming M-trials greater than one, this condition ensures we have
    %  either case 2 or case 5.  Ignore case 5 for the moment
    disp('Assuming case 2: N-points stimulus vector, M-trials by N-points spikevector');

    %  Ensure we have M-trials by N-points instead of N-points by M-trials
    if aspike == length(stimvec)  
        %bspike is the number of trials
        spikevec = spikevec';
    elseif bspike == length(stimvec)
        % Do nothing,  aspike is already the number of trials
    end;
    [aspike,bspike]=size(spikevec);  % aspike is now definitely the number of trials
    
    totalspikes = sum(sum(spikevec));
    returnmat = zeros(totalspikes,winsize+1);
    
    counter = 0;
    for j = 1:aspike
        spikedata = spikevec(j,:);
        spiketimes = find(spikedata ==1);
        b = find(spiketimes<=winsize);
        spiketimes(b) =[];
        b = find(spiketimes>=length(stimvec)-winsize);
        spiketimes(b) = [];
        for i = 1:length(spiketimes)
            counter = counter + 1;
            returnmat(counter,:) = stimvec(spiketimes(i)-winsize/2:spiketimes(i)+winsize/2);
        end;
    end;
    returnav = mean(returnmat);
end;


