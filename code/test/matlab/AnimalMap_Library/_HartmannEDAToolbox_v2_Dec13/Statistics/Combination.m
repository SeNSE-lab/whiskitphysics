% function[n]=combination(N,k)
% Returns vector n which is a random combination of k integers whose values
% range between 1 and N.
% Example:  n = comination(100,4) might return [1,4,20,99]
% Hartmann EDA Toolbox v1, Dec 2004

function[n]=combination(N,k)

vec=1:N;
counter=0;
n=zeros(1,k);

while length(find(n))<k
	counter=counter+1;
	a=randperm(length(vec));
	a=a(1);
	n(1,counter)=vec(a);
	vec(a)=[];
end;


