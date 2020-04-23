function [d] =cdiff(vec)

% function [d] =cdiff(vec)
% Calculate the derivative of the vector vec using the central difference
% approximation.   This has the advantage that there are the same number
% of points in the vector and its derivative, instead of one fewer as is
% the case when you use the Matlab function diff.
% MJH May 1999
% Hartmann EDA Toolbox v1, Dec 2004

forward=vec(3:end)-vec(2:end-1);
backward=vec(2:end-1)-vec(1:end-2);
d=(forward+backward)/2;

firstpt=vec(2)-vec(1);
lastpt=vec(end)-vec(end-1);
firstpt=firstpt(:)';
d=d(:)';
lastpt=lastpt(:)';
d=[firstpt,d,lastpt];