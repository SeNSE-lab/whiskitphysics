function [ y ] = mirrorX( x, varargin )
%mirrorX The purpose of this function is to mirror the point(s) by yz-plane. The
% input of this function should be points in column vector, i.e. a 3-by-N
% vector or matrix.
% 
%   y = mirrorX(x) mirror a 3-by-N matrix about the yz plane, i.e. 
%   flip the x value.
%
%   y = mirrorX(x, flag) mirror a a 3-by-N matrix if the flag is
%   true. Return the original 3-by-N matrix if the flag is false.
%
% By Yifu
% 2017/11/17
    

    flag = 1;
    mirror = 0;
    if ~isempty(varargin)
        if varargin{1}~=1 && varargin{1}~=0, error('2nd argument needs to be boolean.'); end
        flag = varargin{1};
    end
    
    if size(x,1) ~= 3
        mirror = 1;
        x = x';
    end
    y = [-1 0 0;0 1 0;0 0 1]^flag*x;
    
    if mirror, y = y'; end
    
end

