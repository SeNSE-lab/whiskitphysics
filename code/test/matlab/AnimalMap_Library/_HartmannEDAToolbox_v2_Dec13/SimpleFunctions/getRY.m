function RY = getRY(theta)
% function getRY
%
% create 3x3 the rotation matrix for rotation around X axis
% input: theta = angle in radians to rotate around
% output: RX = resulting 3x3 rotation matrix

c = cos(theta);
s = sin(theta);

RY = [c  0  s;...
      0  1  0;...
     -s  0  c];