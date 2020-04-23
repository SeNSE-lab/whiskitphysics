

function[a]=loadimage(filename);
% function[a]=loadimage(filename);
% Allows you to load a tif image file without remembering where to put all
% the apostrophes in your eval statement. 
% filename needs to be a string.
% This function is identially equal to:  eval(['a=imread(''' filename '.tif'' ,''tif'');']);
% Hartmann EDA Toolbox v1, Dec 2004

disp('WARNING:  this function is obsolete and should be replaced with loadtif');
eval(['a=imread(''' filename '.tif'' ,''tif'');']);
