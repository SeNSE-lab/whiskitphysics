% EstimateBias(var1,nbins1,var2,nbins2,spikevec,lag);
%  [ProbEvolution] = EstimateBias(var1,nbins1,var2,nbins2,spikevec,lag,minspikes);

clear;ca;clc;

load Cell2
dum = spikedata_125';
spikevec = dum(:);

% a = find(traj~=0);
% dum = min(traj(a));
% a = find(traj==0);
% traj(a) = dum - .6;

ival = 1:20000;
for i =1:50
    var1(ival) = x_125;
    var2(ival) = xdot_125;
    ival = ival+20000;
end;


% var1 = x_125; nbins1 = 15; var2 = xdot_125; nbins2 = 15; lag = 2;
nbins1 = 15; nbins2 = 15; lag = 2;

var1 = round(scale(var1,1,nbins1));
var2 = round(scale(var2,1,nbins2));

for i =1:nbins1
    for j = 1:nbins2
        varname = ['State_' int2str(i) '_' int2str(j) ];
        tempstring = [varname '=[];'];
        eval(tempstring);
    end;
end;

for j = 1:length(var1)-lag
    var1_state = var1(j);
    var2_state = var2(j);
    varname = ['State_' int2str(var1_state) '_' int2str(var2_state) ];
    if spikevec(j+lag) ==1
        tempstring = [varname '=[' varname '; [j,1]];'];
        eval(tempstring);
    elseif spikevec(j+lag) ==0
        tempstring = [varname '=[' varname '; [j,0]];'];
        eval(tempstring);
    else
        disp('error!');
    end;
end;

nspikes =zeros(nbins1,nbins2);
for i =1:nbins1
    for j = 1:nbins2
        eval(['data=State_' int2str(i) '_' int2str(j) ';']);
        if ~isempty(data)
            data = data(:,2);
            nspikes(i,j) = sum(data);
        else
            nspikes(i,j) = 0;
        end;
    end;
end;
