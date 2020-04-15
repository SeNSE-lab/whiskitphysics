function names = parseWhiskerID(path)
%parseWhiskerID read txt files containing the names of the whiskers in such
%format: 
%   1-02 1RA02
%   AnimalNum-WhiskerNum AnimalNumSideRowCol

% path = '../Data/outliers/GBL_outlier.txt';
fid = fopen(path);
C = textscan(fid, '%d-%d %s', 'delimiter', '\n'); 
names = cell2mat(C{3});

end