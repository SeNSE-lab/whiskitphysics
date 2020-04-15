function[dataret,scalefactor]=scalepn(data,lowval,upval);

% SCALEPN             Scales the data to specified values
%  function[scaled_vector,scalefactor]=scale(vector,[lower=0],[upper=1]);
%     OR
%  function[scaled_vector,scalefactor]=scale(vector,vector2);
%  
% SCALE scales the input argument 'vector' between the values of 'lower'
% and 'upper.' If 'lower' and 'upper' are omitted, the function SCALE scales
% 'vector' between 0 and 1, and it alerts you that this is what it is
% doing.
%  
% With two input arguments (both of which must be vectors), SCALE uses the
% minimum and maximum of 'vector2' as 'lower' and 'upper' to scale
% 'vector,' and it alerts you that this is what it is doing.  
%
% Hartmann EDA Toolbox v1, Dec 2004

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

dataret = data*(desiredrange./datarange);
scalefactor = desiredrange./datarange;