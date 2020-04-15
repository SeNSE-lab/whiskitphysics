function hv = plotvect(v,varargin)
% plots a 2D or 3D vector originating from origin
%
% input: v = 2D or 3D vector
%        varargin = color and line specifications

if nargin>1,
    specs = varargin{1};
else
    specs = '';
end

if length(v)==2
    hv = plot([0,v(1)],[0,v(2)],specs);
elseif length(v)==3
    hv = plot3([0,v(1)],[0,v(2)],[0,v(3)],specs);
else
    error('Not 2D or 3D vector')
end