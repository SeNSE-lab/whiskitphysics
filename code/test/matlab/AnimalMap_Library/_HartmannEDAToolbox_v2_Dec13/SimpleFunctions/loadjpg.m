

function[a]=loadjpg(filename);
% function[a]=loadjpg(filename);
% Allows you to load a jpg image file without remembering where to put all
% the apostrophes in your eval statement. 
% filename needs to be a string.
% This function is identially equal to:  eval(['a=imread(''' filename '.jpg'' ,''jpg'');']);
% Hartmann EDA Toolbox v1, Dec 2004

eval(['a=imread(''' filename '.jpg'' ,''jpg'');']);
