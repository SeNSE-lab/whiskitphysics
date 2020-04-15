function[Mreturn]=msplit(run,len,omitvec)

% MSPLIT				Mitra Hartmann, 22 Jun 1997
%
% function[Mreturn]=msplit(run,len,[omitvec]);
%
% MSPLIT splits the input argument 'run' into a matrix.  'run' is divided
% into N segments of length len each (where N obviously depends on the
% length of the run).  Thus Mreturn is a matrix of size N by len.  Split
% does not zero pad, it simply truncates if there are not enough points at
% then end of run.   
%
% The optional argument omitvec is a sequence of startpoints and endpoints
% to let the user select out some noisy parts of the data.  In this case
% MSPLIT divides the run up to omitstart (still no zero padding) and then
% starts the next trial with the point omitend+1; 
%
% Hartmann EDA Toolbox v1, Dec 2004

% Look for three common errors
if nargin == 1
    error('Syntax: Mreturn = msplit(run,len,[omitvec])');
end;
if nargin >=2
    if len>length(run)
        error('Error: split length was greater than run length');
    end;
end;
if nargin == 3
    if isodd(length(omitvec))
        error('Error: omitvec must conatain the same number of start and end points');
    end;
end;


% Split up the data into sections 
if nargin == 2
    NumSections =1;     % user did not input omitvec
    Section1 = run;
    TotalNumRows = floor(length(run)/len);
elseif nargin ==3
    % put omitvec into a standard format
    if omitvec(1) < len
        % user wants to remove the very first part of the data 
        run = run(omitvec(2):end);
        omitvec = omitvec - omitvec(2);
        omitvec=omitvec(3:end);
    end;
    if omitvec(end) > length(run) - len + 1
        % user wants to remove the very last part of the data 
        run = run(1: omitvec(end-1));
        omitvec=omitvec(1:end-2);
    end;
    omitvec(end+1) = length(run);
    
    NumSections = 0;
    TotalNumRows = 0;
    startpt = 1;
    
    for i=1:2:length(omitvec)      
        endpt = omitvec(i);
%         disp([startpt, endpt]);
        Section = run(startpt:endpt);
        NumRows = floor(length(Section)/len);
        TotalNumRows = TotalNumRows + NumRows;
        if NumRows >= 1,     % if that section is long enough to provide at least one row of length len
            NumSections = NumSections +1;
            eval(['Section' int2str(NumSections) '=Section;']);
        end;
        if i < length(omitvec)
            startpt = omitvec(i+1);
        end;
    end;
end;

% Divide each of the sections up into segments of length len and place them
% in Mreturn
Mreturn = zeros(TotalNumRows,len);      % initialize to all zeros to speed up processing
counter = 0;

for i=1:NumSections
    eval(['Section = Section' int2str(i) ';']);
    NumRows = floor(length(Section)/len);
    for j=1:NumRows
        counter = counter + 1;
        Mreturn(counter,:) = [Section( (j-1)*len+1 : j*len)]';
    end;
end;

