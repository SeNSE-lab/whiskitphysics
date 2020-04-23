function hdl = plotv3(varargin)
%plotv3 plots normalized unit vector with its direction specified by input
%arbitrary vector.
%
%   hdl = plotv3(v1, v2, v3) or plotv3([v1, v2, v3])
%   hdl = plotv3(v1, v2, v3, linespec) or plotv3([v1, v2, v3], linespec)
%
% By Yifu
% 2018/09/10


switch nargin
    case 1
        v1 = varargin{1}(1); v2 = varargin{1}(2); v3 = varargin{1}(3);
        linespec = 'k-';
    case 2
        v1 = varargin{1}(1); v2 = varargin{1}(2); v3 = varargin{1}(3);
        linespec = varargin{2};
    case 3
        v1 = varargin{1}; v2 = varargin{2}; v3 = varargin{3};
        linespec = 'k-';
    case 4
        v1 = varargin{1}; v2 = varargin{2}; v3 = varargin{3};
        linespec = varargin{4};
    otherwise
        error('Incorrect number of inputs.')
end
v = normalize([v1,v2,v3],'norm');
hdl = plot3([0,v(1)],[0,v(2)],[0,v(3)], linespec);

end

