function [ R ] = rotx( t, varargin )
%ROTX It returns a rotation matrix representing the rotation around x-axis
% by an angle.
%
%   R = rotx(theta) returns a rotation matrix around x-axis by theta
%   radians.
%
%   R = rotx(theta,'rad') returns a rotation matrix around x-axis by 
%   theta radians.
%
%   R = rotx(theta,'deg') returns a rotation matrix around x-axis by 
%   theta degrees.
%
% By Yifu
% 2017/11/17

    if ~isempty(varargin) && strcmp(varargin{1},'deg')
        t = t *pi/180;
    elseif ~isempty(varargin) && ~strcmp(varargin,'rad')
        error('You need to specify if the input is in degree or radian, or leave it blank using radian by default.')
    end
    ct = cos(t);
    st = sin(t);
    R = [
        1   0    0
        0   ct  -st
        0   st   ct
        ];
end

