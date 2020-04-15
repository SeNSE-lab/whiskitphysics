function[d] = RemoveUnderscores(stringin,charchoice)

if nargin ==1
    charchoice = [];
end;

a = find(stringin == '_');
if ~isempty(charchoice)
    stringin(a) = charchoice;
else
    stringin(a) = [];
end;
d = stringin;