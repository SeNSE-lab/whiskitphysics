function[outmat, scalefactor]=scale2(inmat,lowval,upval,lowdist,updist);

% SCALE2  Scales each row of a matrix to specified value
%  function[scaled_mat,scalefactor]=scale(inmat,[lowval=0],[upval=1],[lowdist],[updist]);
%     OR
%  function[scaled_vector,scalefactor]=scale(inmat,inmat2,[lowerdist],[upperdist]);
%  
% SCALE2 scales each row of inmat between the values of lowval and
% upval.  If lowval and upval are omitted, inmat is scaled between 0 and 1
% and the function alerts you that this is what it is doing.

% scales each row of inmat to the range of values in the same row of
% inmat2

% input matrix -- unambiguous
% input vector -- unambiguous

% input matrix, vector -- should result in warning
% input matrix, matrix -- should result in warinng

% input matrix, lowval, upval -- should result in warning
% input matrix, lowdist, updist -- should result in warning
% input matrix, vector, vector -- unambiguous

% input matrix, lowval, upval, lowdist, updist -- unambiguous

% input matrix, vector, lowdist, updist -- unambiguous
% input matrix, matrix, lowdist,updist -- unambiguous 


% With two input arguments (both of which must be vectors), SCALE uses the
% minimum and maximum of 'vector2' as 'lower' and 'upper' to scale
% 'vector,' and it alerts you that this is what it is doing.  
%
% Hartmann EDA Toolbox v2, May 2010

[nrows,ncols] = size(inmat);

mat2val = 0;
mat2mat = 0;
mat2vec = 0;

if nargin == 1  % user input a matrix or a vector and just wants it scaled between 0 and 1
    lowval = 0; upval = 1;
    disp('Assuming input gives min and max of full distribution, scaling input between 0 and 1')
    mat2val = 1;
elseif nargin == 2  % user wants the first matrix (vector) scaled to the second matrix (vector)
   disp('Warning: assuming input gives min and max of full distribution')
   [a,b]=size(loval);
   if a == 1 | b == 1
       mat2vec = 1;
   elseif a>1 & b>1
       mat2mat = 1;
   end;
elseif nargin == 3
    if length(lowval)>1  % user input three matrices (or vectors), unambiguous
        updist = max(upval);
        lowdist = min(upval);
        upval = max(lowval);
        lowval = min(lowval);
    elseif length(lowval) == 1  % user input 1 matrix and two values
        disp('Assuming input gives min and max of full distribution, scaling input between desired values')
        lowval = lowval;
        upval = upval;
    end;
end;


outmat = zeros(size(inmat));
scalefactor = zeros(1,nrows);

for i =1:nrows
    data = inmat(i,:);
    datarange = max(data)-min(data);
    desiredrange = upval-lowval;
    
end;


if nargin==1,
    lowval=0;
    upval=1;
    disp('scaling between 0 and 1');
elseif nargin==2,
    disp('using min and max of second vector as desired scale');
    data2=lowval;
    lowval=min(data2);
    upval=max(data2);   
end;

datarange=max(data)-min(data);
desiredrange=upval-lowval;

% now data ranges between zero and max(data);
data=data-min(data);

data=data*(desiredrange/datarange);
scalefactor=(desiredrange/datarange);
dataret=data+lowval;


