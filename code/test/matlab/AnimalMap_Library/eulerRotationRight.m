function [ y ] = eulerRotationRight( x, theta, phi, zeta )
%eulerRotationRight A SPECIAL extrinsic Euler rotations in a right-handed 
% coordiante system.
%
%   y = eulerRotationRight(x,theta,phi,zeta) rotates a 3-by-N matrix
%   using pre-defined extrinsic Euler rotations to a position. This
%   function is especially used to rotate a whisker from original position
%   (usually [0;-1;0]) to its actual position, and return its position
%   coordiantes. The angles are given in radians.
% *** This euler rotation is intended for whiskers on the right side. ***
%
% Rotation order:
%       - 1st: rotate around (+)y-axis about Zeta
%       - 2nd: rotate around (-)x-axis about Phi
%       - 3rd: rotate around (+)z-axis about Theta
%

    y = rotz(theta)*rotx(phi)'*roty(zeta)*x;

end

