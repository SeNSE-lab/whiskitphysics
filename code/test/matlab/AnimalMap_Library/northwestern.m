function M = northwestern(n)
%northwestern MATLAB colormap nx3 array for northwestern purple.
%
% By Yifu
% 2018/08/20
%
% https://www.mccormick.northwestern.edu/marketing/logos-and-branding/color-usage-guidelines.html

M = zeros(n,3);
M(:,1) = linspace(48, 204, n);
M(:,2) = linspace(16, 196, n);
M(:,3) = linspace(78, 223, n);
M = M./256;

% Northwestern purple
if n == 1, M = [078, 042, 132]/256; end

end