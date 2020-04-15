function b = overlap(varargin)
%OVERLAP The purpose of this function is to overlap several vectors in a
%specific way.
%
%   M = OVERLAP(V1, V2, V3, ...) takes an arbitrary number of vectors and
%   combine them into a big vector, whose elements are picked from rach of
%   the vector one by one, and repeatedly until one of the vector runs out.
%   Then the rest are attached to the result.
%
%   Example:
%   Input:  overlap([1,2],[3,4,5],[6;7])
%   Output: 1  3  6  2  4  7  5
%
% By Yifu
% 2017/12/14


    % Check isvector
    if ~all(cellfun(@isvector,varargin))
        error('Input cannot contain non-vector matrix!');
    end
    
    % Initialization
    n = nargin;
    s = zeros(1,n);
    V = cell(1,n);
    for i = 1:n
        s(i) = max(size(varargin{i}));
        V{i} = reshape(varargin{i},1,s(i)); 
    end
    % Overlap begins
    p = 1; 
    while all(p <= s)
        temp = [];
        for i = 1:n, temp = [temp,V{i}(p)]; end
        b((1:n)+n*(p-1)) = temp;
        p = p + 1;
    end
    % attech rest matrix
    for i = 1:n
        b = [b, V{i}(p:end)];
    end
    
end

