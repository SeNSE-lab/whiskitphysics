function [ R ] = roty( t, varargin )
%ROTY It returns a rotation matrix representing the rotation around y-axis
% by an angle.
%
%   R = roty(theta) returns a rotation matrix around y-axis by theta
%   radians.
%
%   R = roty(theta,'rad') returns a rotation matrix around y-axis by 
%   theta radians.
%
%   R = roty(theta,'deg') returns a rotation matrix around y-axis by 
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
        ct  0   st
        0   1   0
       -st  0   ct
        ];
end

