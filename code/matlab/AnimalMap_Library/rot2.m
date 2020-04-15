function [ R ] = rot2( t, varargin )
%ROTX It returns a rotation matrix representing the rotation by an angle.
%
%   R = rotx(theta) returns a 2D rotation matrix by theta radians.
%
%   R = rotx(theta,'rad') returns a 2D rotation matrix by theta radians.
%
%   R = rotx(theta,'deg') returns a 2D rotation matrix by theta degrees.
%
% By Yifu
% 2019/08/26

    if ~isempty(varargin) && strcmp(varargin{1},'deg')
        t = t *pi/180;
    elseif ~isempty(varargin) && ~strcmp(varargin,'rad')
        error('You need to specify if the input is in degree or radian, or leave it blank using radian by default.')
    end
    ct = cos(t);
    st = sin(t);
    R = [
        ct  -st
        st   ct
        ];
end