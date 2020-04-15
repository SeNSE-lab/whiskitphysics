 
function[shortvec]=shorten(vec,len)

% SHORTEN			    Shorten a vector to a specified length
%
%	shortvector=shorten(vector, [length] or ['nXXX'])
%		where nXXX stands for nearest XXX, where XXX is whatever
%		power of 10 you want it rounded closest to.
%   
%   With only one input argument, SHORTEN will do one of three things:
%     (1) Shorten to the nearest 1000, 
%     (2) Shorten to the nearest pow2n (see function pow2n)
%     (3) If the vector is very long (>100000 points), shorten to 
%             pow2n(vec) + pow2n(vec)/2
%
% SHORTEN decides which of these three things to do depending on which
% value is closest to the orginal length of "vec".   The point here is to
% remove as few points as possible, but still have a reasonable vector to
% work with so that ffts don't take forever.
% Mitra Hartmann, 19 April 1997
%
% Example:   shortvec = shorten(data, 'n100') shortens the vector data to
% the nearest 100. 
% 
% Hartmann EDA Toolbox v1, Dec 2004



if nargin==1

	pos=pow2n(vec);
	posplus=pos+pos/2;

	if length(vec)>100000,

		if length(vec)-pos<900 & length(vec)-pos>0
			shortvec=vec(1:pos);
		elseif length(vec)-posplus<900 & length(vec)-posplus>0
			shortvec=vec(1:posplus);
		else 
			%round to the nearest 1000
			temp=floor(length(vec)/1000)*1000;
			shortvec=vec(1:temp);
		end;

	else
		if length(vec)-pos>0 & length(vec)-pos<90
			shortvec=vec(1:pos);
		elseif length(vec)-posplus<90 & length(vec)-posplus>0
			shortvec=vec(1:posplus);
		else 
			%round to the nearest 1000
			temp=floor(length(vec)/1000)*1000;
			shortvec=vec(1:temp);
		end;
	end;
end;



if nargin==2,
	if isstr(len)
		rnd=eval(len(2:length(len)));
		temp=floor(length(vec)/rnd)*rnd;
		shortvec=vec(1:temp);
	else
		shortvec=vec(1:len);
	end;
end;