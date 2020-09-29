function [ R ] = rotz( t, varargin )
%ROTZ It returns a rotation matrix representing the rotation around z-axis
% by an angle.
%
%   R = rotz(theta) returns a rotation matrix around z-axis by theta
%   radians.
%
%   R = rotz(theta,'rad') returns a rotation matrix around z-axis by 
%   theta radians.
%
%   R = rotz(theta,'deg') returns a rotation matrix around z-axis by 
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
        ct  -st  0
        st   ct  0
        0    0   1
        ];
end

