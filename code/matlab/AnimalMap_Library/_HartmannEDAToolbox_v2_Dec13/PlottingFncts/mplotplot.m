%  Hartmann EDA Toolbox v2, Dec 2013
% Not a stand-alone function, called by mplot

function [void] = mplotplot(t,inmat,offset,li,dcoffset,color)
if nargin==5
	% mplot specified no time base, 
	% inmat was input as t, offset was input as inmat, li was input as offset
	   % dcoffset was input as li, and color was input as dcoffset
		color=dcoffset;
		dcoffset=li;
		li=offset;
		offset=inmat;
		inmat=t; clear t;
	for i=1:li
		h(i)=plot(inmat(i,:)+(dcoffset+(offset*(i-1))),color);
		hold on;
	end;
	grid on;

elseif nargin==6
	for i=1:li
		h(i)=plot(t,inmat(i,:)+(dcoffset+(offset*(i-1))),color);
		hold on;
	end;
	grid on;
end;


if 1==2,
wid=input('Set line width [default=1]: ');
	if wid~=[]
		for i=1:length(h);
			set(h(i),'LineWidth',wid);
		end;
	end;
end;