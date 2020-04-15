function [handle,no,xo] =  chist(y,x,col)
%CHIST                              Color Histogram
%   function [handle,no,xo] = chist(y,x,[color])
%
%   This function is identical to Matlab's HIST function except that  it
%   allows you to plot histograms in color, and returns a handle to the
%   graphic so you can change facecolor and edgecolor if desired.
%   Hartmann EDA Toolbox v1, Dec 2004
%
%   N = HIST(Y) bins the elements of Y into 10 equally spaced containers and returns the number
%   of elements in each container.  If Y is a matrix, HIST works down the
%   columns.
%
%   N = HIST(Y,M), where M is a scalar, uses M bins.
%
%   N = HIST(Y,X), where X is a vector, returns the distribution of Y
%   among bins with centers specified by X.  Note: Use HISTC if it is
%   more natural to specify bin edges instead.
%
%   [N,X] = HIST(...) also returns the position of the bin centers in X.
%
%   HIST(...) without output arguments produces a histogram bar plot of
%   the results.
%
%   See also HISTC.

%   J.N. Little 2-06-86
%   Revised 10-29-87, 12-29-88 LS
%   Revised 8-13-91 by cmt, 2-3-92 by ls.
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.16 $  $Date: 1998/05/22 15:51:00 $

if nargin == 0
    error('Requires one or two input arguments.')
end
if nargin == 1
    x = 10;
    col='k';
end
if nargin==2,
    if isstr(x)
        col=x;
        x=10;
    else 
        col = 'k';
    end;
end;

if min(size(y))==1, y = y(:); end
if isstr(x) | isstr(y)
    error('Input arguments must be numeric.')
end

[m,n] = size(y);
if isempty(y),
    if length(x) == 1,
        x = 1:x;
    end
    nn = zeros(size(x)); % No elements to count
else
    if length(x) == 1
        miny = min(min(y));
        maxy = max(max(y));
        if miny == maxy,
            miny = miny - floor(x/2) - 0.5; 
            maxy = maxy + ceil(x/2) - 0.5;
        end
        binwidth = (maxy - miny) ./ x;
        xx = miny + binwidth*(0:x);
        xx(length(xx)) = maxy;
        x = xx(1:length(xx)-1) + binwidth/2;
    else
        xx = x(:)';
        miny = min(min(y));
        maxy = max(max(y));
        binwidth = [diff(xx) 0];
        xx = [xx(1)-binwidth(1)/2 xx+binwidth/2];
        xx(1) = min(xx(1),miny);
        xx(end) = max(xx(end),maxy);
    end
    nbin = length(xx);
    % Shift bins so the internal is ( ] instead of [ ).
    xx = full(real(xx)); y = full(real(y)); % For compatibility
    bins = xx + max(eps,eps*abs(xx));
    nn = histc(y,[-inf bins],1);
    
    % Combine first bin with 2nd bin and last bin with next to last bin
    nn(2,:) = nn(2,:)+nn(1,:);
    nn(end-1,:) = nn(end-1,:)+nn(end,:);
    nn = nn(2:end-1,:);
end

if nargout == 0 | nargout==1,
    handle=bar(x,nn,'hist');
    set(handle,'FaceColor',col);
    set(handle,'EdgeColor','k');
else
    if min(size(y))==1, % Return row vectors if possible.
        handle=bar(x,nn,'hist');
        set(handle,'FaceColor',col);
        set(handle,'EdgeColor','k');
        no = nn';
        xo = x;
    else
        handle=bar(x,nn,'hist');
        set(handle,'FaceColor',col);
        set(handle,'EdgeColor','k');
        no = nn;
        xo = x';
    end
end