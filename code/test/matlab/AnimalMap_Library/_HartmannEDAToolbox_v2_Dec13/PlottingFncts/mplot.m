
%  Hartmann EDA Toolbox v2, Dec 2013
% MPLOT				Mitra Hartmann 13 April 97
%				Modified 19 April to offset the first trace
% Plots row matrices.
% function [void] = mplot([t],[dcoffset],matrix,[offset],[color]);
%	All parameters in square brackets are optional
%	t is a vector to plot the matrix traces against
%		(usually a time or frequency vector)
%	dcoffset is the offset for the first trace (the default is 0)
%	offset is the offset *between* traces
%		(the default calculates
%			offset=mean(max(inmat)'-min(inmat)')*multfactor;)

function [offset] = mplot(t,dcoffset,inmat,offset,color)

multfactor=3;

if nargin==1
	inmat=t; clear t;
	offset=mean(max(inmat)'-min(inmat)')*multfactor;
	color=['r'];
	dcoffset=0;
	[li,lj]=size(inmat);
	mplotplot(inmat,offset,li,dcoffset,color);
end;


if nargin==2

	% inmat and dcoffset: user input dcoffset as t and and inmat as dcoffset
	if max(size(t))==1,			% check if max size of t is 1
		inmat=dcoffset;
		dcoffset=t; clear t;
		offset=mean(max(inmat)'-min(inmat)')*multfactor;
		color=['r'];
		[li,lj]=size(inmat);
		mplotplot(inmat,offset,li,dcoffset,color)

	% inmat and t: user input t as t and and inmat as dcoffset
	elseif max(size(dcoffset))>1,	% check if max size of dcoffset is greater than 1
		t=t;
		inmat=dcoffset;
		offset=mean(max(inmat)'-min(inmat)')*multfactor;
		dcoffset=0;
		color=['r'];
		[li,lj]=size(inmat);
		mplotplot(t,inmat,offset,li,dcoffset,color)

	% inmat and color: user input inmat as t and color at dcoffset
	elseif isstr(dcoffset)	% User input matrix as t and color as dcoffset
		color=dcoffset;
		inmat=t; clear t;
		offset=mean(max(inmat)'-min(inmat)')*multfactor;
		dcoffset=0;
		[li,lj]=size(inmat);
		mplotplot(inmat,offset,li,dcoffset,color);

	% inmat and offset: user input inmat as t and offset at dcoffset
	else
		inmat=t; clear t;
		offset=dcoffset; clear dcoffset;
		dcoffset=0;
		color=['r'];
		[li,lj]=size(inmat);
		mplotplot(inmat,offset,li,dcoffset,color)
	end;
end;


%function [void] = mplot(t,dcoffset,inmat,offset,color)

if nargin==3
	if (isstr(inmat))		%%%%%%%%%%%%%%%%%%
		if max(size(dcoffset))>1 & max(size(t))==1,
		% inmat, dcoffset, and color: user input dcoffset as t, inmat as dcoffset, and color as inmat
			color=inmat;
			inmat=dcoffset;
			dcoffset=t; clear t;
			offset=mean(max(inmat)'-min(inmat)')*multfactor;
			[li,lj]=size(inmat);
			mplotplot(inmat,offset,li,dcoffset,color);

		elseif max(size(dcoffset))>1 & max(size(t))>1,
		% inmat, t, and color: user input t as t, inmat as dcoffset, and color as inmat	
			t=t;
			color=inmat;
			inmat=dcoffset; clear dcoffset;
			offset=mean(max(inmat)'-min(inmat)')*multfactor;
			[li,lj]=size(inmat);
			dcoffset=0;
			mplotplot(t,inmat,offset,li,dcoffset,color);
		else
		% inmat, offset, and color: user input inmat as t, offset as dcoffset, and color as inmat
			color=inmat;
			offset=dcoffset;
			inmat=t; clear t;
			dcoffset=0;
			[li,lj]=size(inmat);
			mplotplot(inmat,offset,li,dcoffset,color);
		end;
	
	elseif max(size(dcoffset))>1 		%%%%%%%%%
		if max(size(t))>1
		% inmat, t, and offset: user input t as t, inmat as dcoffset, and offset as inmat
			t=t;
			offset=inmat;
			inmat=dcoffset; clear dcoffset;
			dcoffset=0;
			color=['r'];
			[li,lj]=size(inmat);
			mplotplot(t,inmat,offset,li,dcoffset,color);
		else
		% inmat, dcoffset, and offset: user input dcoffset as t, inmat as dcoffset, and offset as inmat
			offset=inmat;
			inmat=dcoffset;
			dcoffset=t; clear t;
			color=['r'];
			[li,lj]=size(inmat);
			mplotplot(inmat,offset,li,dcoffset,color)
		end;
	else					%%%%%%%%%
	% inmat, t, and dcoffset: user input t as t, dcoffset as dcoffset, and inmat as inmat
		offset=mean(max(inmat)'-min(inmat)')*multfactor;
		color=['r'];
		[li,lj]=size(inmat);
		mplotplot(t,inmat,offset,li,dcoffset,color);
	end;				%%%%%%%%%%%%%%%%%%

end; 		% if nargin==3





if nargin==4
	if isstr(offset)
		if max(size(t))==1
			% inmat, dcoffset, offset, and color
			  % User input dcoffset as t, inmat as dcoffset, offset as inmat, color as offset
			color=offset;
			offset=inmat;
			inmat=dcoffset;
			dcoffset=t;clear t;		
			[li,lj]=size(inmat);
			mplotplot(inmat,offset,li,dcoffset,color);
		elseif max(size(dcoffset))==1
			% inmat, t, dcoffset and color
			  %User input t as t, dcoffset as dcoffset,inmat as inmat, and color as offset.
			color=offset;
			offset=mean(max(inmat)'-min(inmat)')*multfactor;
			[li,lj]=size(inmat);
			mplotplot(t,inmat,offset,li,dcoffset,color);
		else
			% inmat, t, offset, and color
			  %User input t as t, inmat as dcoffset, offset as inmat, and color as offset
			t=t;
			color=offset;
			offset=inmat;
			inmat=dcoffset;
			dcoffset=0;
			[li,lj]=size(inmat);
			mplotplot(t,inmat,offset,li,dcoffset,color);
		end;
	else
		% inmat, t, dcoffset and offset 
		   %User input t as t, dcoffset as dcoffset, inmat as inmat, and offset as offset.
		[li,lj]=size(inmat);
		color=['r'];
		mplotplot(t,inmat,offset,li,dcoffset,color);



	end;
end;			% if nargin==4


if nargin==5
	[li,lj]=size(inmat);
	mplotplot(t,inmat,offset,li,dcoffset,color);
end;

tempstring=['Used an offset of ' num2str(offset)];
disp(tempstring);