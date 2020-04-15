function [K, Kss] = whiskerCurvature2D_old(w)
%whiskerCurvature2D calculates the normalized curvature of a given whisker,
%defined by the sum of absolute turning angle(>0) averaged over full arc
%length.
%
%   K = whiskerCurvature2D(whisker) takes 2D whisker and returns the
%   normalized absolute curvature. Definition can be found in AnimalMap
%   paper draft.
%
%   Note: The whisker is processed to be 500-micron equal distance.
%
% By Yifu
% 2018/08/29

% Example input
% clear
% load '../Data/CAT_cubic_all.mat'
% w = WHPoints2D{1};
% clearvars -except w

if issorted(size(w)), w = w'; end

nodelen = 0.5;
[x, y] = equidistlen(w(:,1), w(:,2), nodelen);
w = [x, y];

s = whiskerLength(w);
seg = w(2:end,:) - w(1:end-1,:);
COS = (seg(1:end-1,1).*seg(2:end,1) + seg(1:end-1,2).*seg(2:end,2))/nodelen^2;
COS(COS>1) = 1; COS(COS<-1) = -1;
K = sum(acos(COS))/s;

if s > 10
    Kss = LineCurvature2D(w);
%     Kss = interp1(1:length(Ks),Ks,linspace(1,length(Ks),10),'pchip');
else
    Kss = NaN;
end
% K = sum(acos((seg(1:end-1,1).*seg(2:end,1) + seg(1:end-1,2).*seg(2:end,2))/nodelen^2))/s;

end