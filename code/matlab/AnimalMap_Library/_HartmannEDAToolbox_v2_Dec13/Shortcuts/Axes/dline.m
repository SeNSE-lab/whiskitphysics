function h = dline(varargin)
% function h = dline({sgn,myclr})
% Brian Quist
% June 19, 2010
if nargin >= 1 && ~isempty(varargin{1}),
    sgn = varargin{1};
else
    sgn = 1;
end
if nargin >= 2,
    myclr = varargin{1};
else
    myclr = 'r--';
end
% --------------------
ax = gca;
myx = get(gca,'XLim');
myy = get(gca,'YLim');
% --------------------
hold on;
h = plot(myx,sgn.*myx,myclr);