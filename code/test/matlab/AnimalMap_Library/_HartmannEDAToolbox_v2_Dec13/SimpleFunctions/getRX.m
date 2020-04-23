function RX = getRX(theta)
% function getRX
%
% create the 3x3 rotation matrix for rotation around X axis
% input: theta = angle to rotate around (radians)
% output: RX = resulting 3x3 rotation matrix

c = cos(theta);
s = sin(theta);

RX = [1  0  0;...
      0  c -s;...
      0  s  c];