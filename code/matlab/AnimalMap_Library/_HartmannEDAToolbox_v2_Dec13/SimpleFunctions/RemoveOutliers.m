function [dataout,idxremoved,nremoved] = RemoveOutliers(data,factor);
%% Removes data points from the vector data that are more than factor*std
%  away from the mean.

dataout = data;
% get the mean and std of the vector data:
mu = nanmean(data);
sig = nanstd(data);

% find data values greater than factor*sig from the mean:
idxremoved = find(data < mu-factor*sig | data > mu+factor*sig);
 
% remove the outliers:
dataout(idxremoved) = NaN;
nremoved = length(idxremoved);