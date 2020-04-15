% how displays all variables starting with the string initialstring
%  Hartmann EDA Toolbox v1, Dec 2004

format compact;
initialstring=input(['Display all variables starting with: '],'s');
len=length(initialstring); s=whos;
for j=1:length(s)
    datastring=getfield(s(j,1),'name');
    if length(datastring)>=len   %otherwise will have trouble with filenames shorter . and ..
	if strcmp(datastring(1:len),initialstring)==1,
	    eval(datastring)
	end;
    end;
end;
