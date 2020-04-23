function[inAnotB,inBnotA,inAandB]=comparevecs(A,B);

% function[inAnotB,inBnotA,inAandB]=comparevecs(A,B);
% Compares the values in vectors A and B and looks for values in common.
% The output variable names for this function should make it
% self-explanatory
% Hartmann EDA Toolbox v1, Dec 2004

inAnotB=[];
inBnotA=[];
inAandB=[];

lenA=length(A);
lenB=length(B);

for i=1:lenA,
	if ~any(B==A(i))
		inAnotB=[inAnotB,A(i)];
	end;
end;
		
for i=1:lenB,
	if ~any(A==B(i))
		inBnotA=[inBnotA,B(i)];
	end;
end;

if lenA<lenB
	for i=1:lenA
		if any(B==A(i)),
			inAandB=[inAandB,A(i)];
		end;
	end;
elseif lenB<=lenA
	for i=1:lenB
		if any(A==B(i)),
			inAandB=[inAandB,B(i)];
		end;
	end;
end;