function head_coords = EulerRotateWhisker(theta,phi,psi,transfer_whisker)
%Program : Rotate Whisker
%rotates the 2-D whisker into 3D head-coordinate space.  The rotation order
%is theta then phi then psi. For the opposite rotation order, see
%EulerRotateWhisker2
%Last updated: 2015 by Matt Graff
%
%   Inputs:
%       theta: theta euler angle
%       phi:   phi euler angle
%       psi:   psi euler angle
%       transfer_whisker: input coordinates that you wish to rotate
%
%   Outputs:
%       head_coords: rotated coordinates
%
%

% Comment: the Euler rotations are reversed here
% By Yifu 2017/11/08

npoints = size(transfer_whisker(:,1),1);
col3 = size(transfer_whisker, 2);
x_loc = transfer_whisker(:,1); y_loc = transfer_whisker(:,2); 
%
%if you have 2D data, then just add a column of zeroes
if col3 == 2;
    z_loc = zeros(npoints,1);
elseif col3 == 3
    z_loc = transfer_whisker(:,3);
end
%
%Calculate Euler angle matrices
clear A_matrix B_matrix C_matrix D_matrix
B_matrix = zeros(3,3); C_matrix = zeros(3,3); D_matrix = zeros(3,3);
%size(B_matrix)
%
%Calculate the B matrix
%x-rotation - psi
angle = psi*pi/180; c = cos(angle); s = sin(angle);
B_matrix(1,1) = 1; B_matrix(1,2) = 0; B_matrix(1,3) = 0;
B_matrix(2,1) = 0; B_matrix(2,2) = c; B_matrix(2,3) = s;
B_matrix(3,1) = 0; B_matrix(3,2) = -s; B_matrix(3,3) = c;
%
%Calculate the C matrix
%y-rotation - phi
angle = phi*pi/180; c = cos(angle); s = sin(angle);
C_matrix(1,1) = c; C_matrix(1,2) = 0; C_matrix(1,3) = -s;
C_matrix(2,1) = 0; C_matrix(2,2) = 1; C_matrix(2,3) = 0;
C_matrix(3,1) = s; C_matrix(3,2) = 0; C_matrix(3,3) = c;
%
%Calculate the D matrix
%z-rotation - theta
angle = theta*pi/180; c = cos(angle); s = sin(angle);
D_matrix(1,1) = c; D_matrix(1,2) = s; D_matrix(1,3) = 0;
D_matrix(2,1) = -s; D_matrix(2,2) = c; D_matrix(2,3) = 0;
D_matrix(3,1) = 0; D_matrix(3,2) = 0; D_matrix(3,3) = 1;
%
A_matrix = D_matrix*C_matrix*B_matrix;
head_coords = zeros(npoints,3);
for i = 1:npoints
    twoD_coords = zeros(3,1);
    twoD_coords(1,1) = x_loc(i);
    twoD_coords(2,1) = y_loc(i);
    twoD_coords(3,1) = z_loc(i);
    threeD_coords = zeros(3,1);
    threeD_coords = A_matrix*twoD_coords;
    head_coords(i,1) = threeD_coords(1,1);
    head_coords(i,2) = threeD_coords(2,1);
    head_coords(i,3) = threeD_coords(3,1);
end