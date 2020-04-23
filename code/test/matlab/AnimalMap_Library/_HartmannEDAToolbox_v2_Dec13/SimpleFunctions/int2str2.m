function[j]=int2str2(i,maxval)
% INT2STR2                      Convert integer to string with extra zeros
% function[j]=int2str2(i,[maxval=100]) 
%
% INT2STR2 is useful in the case that you have to load files of the form
% filename_001.tif, filename_013.tif In other words, you need to convert 1
% to the string 001, 13 to the string 013 and so on. 
% 
% The optional value maxval gives the maximum number of zeros to add on.
% Maxval defaults to 100. 
%
% Example 1:    Your files range between 1 and 23.    
%               INT2STR2(i,23) procudes 01, 02, ... 10, 11, 12 ... 23
%               Setting maxval to any number between 10 and 99 produces the
%               same results
%
% Example 2:    Your files range between 1 and 3790.    
%               INT2STR2(i,3790) procudes 0001, 0002, ... 0010, 0011 ... 0099, 0100
%               0101, 0102 ... 0999, 1000, 1001, 1002 ... 3790
%               Setting maxval to any number between 1000 and 9999 produces the
%               same results
         

if nargin==1
    maxval=100;
end;

desired_length = length(int2str(maxval));
actual_length = length(int2str(i));
number_to_add = desired_length - actual_length;

if number_to_add < 0, 
    number_to_add = 0;
end;

array_of_zeros = zeros(1,number_to_add);
zerostring = int2str(array_of_zeros);
foo=find(zerostring == ' ');
zerostring(foo)=[];
j = [zerostring, int2str(i)];