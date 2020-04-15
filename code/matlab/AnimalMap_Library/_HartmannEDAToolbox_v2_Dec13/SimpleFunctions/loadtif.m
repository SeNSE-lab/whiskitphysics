

function[a]=loadtif(filename)
% function[a]=loadtif(filename);
% Allows you to load a tif image file without remembering where to put all
% the apostrophes in your eval statement. 
% filename needs to be a string.
% This function is identially equal to:  eval(['a=imread(''' filename '.tif'' ,''tif'');']);
% Hartmann EDA Toolbox v1, Dec 2004

eval(['a=imread(''' filename '.tif'' ,''tif'');']);
