% Hartmann EDA Toolbox v2, December 2013

function[MovieVer] = GetMovieVersionSuffix(MoviePrefix)
%%% Creates movies sequentially named
%%% _v001, _v002, _v003....  _v999

s = dir([MoviePrefix '*.avi']);

if isempty(s)
    MovieVer = '_v001';
else
    maxnum = -1;
    for i = 1:length(s)
        fname = s(i).name;
        a = find(fname == '_');
        idx1 = a(end)+2;
        a = find(fname == '.');
        idx2 = a(end)-1;
        num = eval(fname(idx1:idx2));
        if num>=maxnum
            maxnum = num;
        end;
    end;
    maxnum = maxnum + 1;
    MovieVer = ['_v' int2str2(maxnum,100)];
end


