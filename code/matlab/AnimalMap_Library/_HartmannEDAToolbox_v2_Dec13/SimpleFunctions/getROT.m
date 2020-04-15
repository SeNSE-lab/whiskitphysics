function ROT = getROT(theta,axis)
% function ROT = getROT(theta,axis)
% create 3x3 the rotation matrix for rotation around a specific axis
% input:  axis = 3d vector that defines the axis to be rotated around -
%                must be a unit vector!
%         theta = angle to rotate around (radians)
% output: RX = resulting 3x3 rotation matrix

% edits: 01/20/2012 - If non-unit vector for axis, outputs ID matrix
%                       Lucie Huet

TOL = 1e-15;

if abs(norm(axis)-1) > TOL
    warning('getROT:ZeroAxis','axis is not unit vector - setting output to ID matrix')
    ROT = [1 0 0;...
           0 1 0;...
           0 0 1];
else
    ROT = [cos(theta)+axis(1)^2*(1-cos(theta))                axis(1)*axis(2)*(1-cos(theta))-axis(3)*sin(theta) axis(1)*axis(3)*(1-cos(theta))+axis(2)*sin(theta);...
           axis(1)*axis(2)*(1-cos(theta))+axis(3)*sin(theta)  cos(theta)+axis(2)^2*(1-cos(theta))               axis(2)*axis(3)*(1-cos(theta))-axis(1)*sin(theta);...
           axis(1)*axis(3)*(1-cos(theta))-axis(2)*sin(theta)  axis(2)*axis(3)*(1-cos(theta))+axis(1)*sin(theta) cos(theta)+axis(3)^2*(1-cos(theta))];
end