function[d]= pow2n(run)

% POW2N            Find power of 2 nearest to a value 
% d= pow2n(run)
%
% If the input argument run is a number, POW2N finds the  power of two that
% is nearest to, but smaller than, that number. 
% 
% If the input argument run is a vector, POW2N finds the power fo two that
% is nearest to, but smaller than, the length of that vector. 
%
% This is very useful when you want to shorten a vector to the nearest
% power of 2 to do an fft. 
% 
% Examples: pow2n(31) = 16
%           pow2n(33) = 32
%           If data is a vector of length 70000
%             pow2n(data) = 65536
            

if length(run)>2,
    nearest= pow2(floor(log2(length(run))));
    near= floor(log2(length(run)));
    d=nearest;
    tempstring=['Nearest power of two is ' int2str(near) ',  ' int2str(nearest)];
    disp(tempstring);
else,
    nearest= pow2(floor(log2((run))));
    near= floor(log2((run)));
    d=nearest;
    tempstring=['Nearest power of two is ' int2str(near) ',  ' int2str(nearest)];
    disp(tempstring);
end;