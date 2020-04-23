function RZ = getRZ(theta)
% function getRZ
%
% create 3x3 the rotation matrix for rotation around X axis
% input: theta = angle in radiams to rotate around
% output: RX = resulting 3x3 rotation matrix

c = cos(theta);
s = sin(theta);

RZ = [c -s  0;...
      s  c  0;...
      0  0  1];