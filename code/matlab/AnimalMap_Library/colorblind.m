function M = colorblind(n)
%MATLAB colormap nx3 array for colorblind people.
%
% By Yifu
% 2019/12/12

color1 = [248 163 120]/256;
color2 = [120 174 248]/256;

if n < 2
    error('Not enough assigend objects for color pannel.')
elseif n == 2
    M = [color1; color2];
else
    M = zeros(n,3);
    M(:,1) = linspace(color1(1), color2(1), n);
    M(:,2) = linspace(color1(2), color2(2), n);
    M(:,3) = linspace(color1(3), color2(3), n);
end


end