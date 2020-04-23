%%% loads all files in the current directly  that end in mat into matlab
s = dir('*.mat');
for i = 1:length(s)
    file2load = s(i).name;
    eval(['load ' file2load]);
end;