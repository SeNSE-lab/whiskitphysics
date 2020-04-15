function [ bpTheta, bpPhi, bpR ] = getBpAngles( basepoint, varargin )
%getBpAngles The purpose of this function if to find the basepoint angles of a
% basepoint, given the basepoint's cartesian coordinates.
%
%   [theta,phi,R] = getBpAgnles(x) transfer basepoing cartesian
%   coordinates into spherical coordinates, resulted in radians. 
%
%   [theta,phi,R,'deg'] = getBpAgnles(x) transfer basepoing cartesian
%   coordinates into spherical coordinates, resulted in degrees. 
%
% By Yifu
% 2017/11/30

    [bpTheta, bpPhi, bpR] = cart2sph(basepoint(1),basepoint(2),basepoint(3));
    bpTheta = wrapToPi(bpTheta);
    if ~isempty(varargin) && strcmp(varargin{1},'deg')
        bpTheta = rad2deg(bpTheta);
        bpPhi = rad2deg(bpPhi);
    end
end

