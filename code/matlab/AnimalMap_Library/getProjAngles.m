function [ projTheta, projPhi, projPsi, axis ] = getProjAngles( theta, phi ,zeta, varargin )
%getProjAngles The purpose of this function if to find the projection 
% angles of a whisker, in radians, given the ZXY extrinsic Euler rotations 
% that can acquire such a whisker.
%
%   [projTheta,projPhi,projPsi,axis] = getProjAngles(theta,phi,zeta)
%   converts the result axis of a set of Euler rotations to corresponding
%   projection angles, resulted in radians, as well as the resulted axis 
%   of emergence of a whisker.
%
%   [projTheta,projPhi,projPsi,axis,'deg'] = getProjAngles(theta,phi,zeta)
%   converts the result axis of a set of Euler rotations to corresponding
%   projection angles, resulted in degrees, as well as the resulted axis 
%   of emergence of a whisker.
%
% The Euler rotation order is defined as:
%   - 1st: rotate around (+)y-axis about Zeta
%   - 2nd: rotate around (-)x-axis about Phi
%   - 3rd: rotate around (+)z-axis about Theta
% The information is contained in the function eulerRotationRight.m
%
%
% By Yifu
% 2017/11/30

    axis = eulerRotationRight([0;-1;0],theta,phi,zeta);
    [projTheta,~,~] = cart2sph(axis(1),axis(2),axis(3));
    projTheta = wrapTo2Pi(projTheta + pi/2);
    projPhi = atan2(axis(3),axis(1));
    projPsi = atan2(axis(3),axis(2));
    if isempty(varargin) && strcmp(varargin{1},'deg')
        projTheta = rad2deg(projTheta);
        projPhi = rad2deg(projPhi);
        projPsi = rad2deg(projPsi);
    end

end

