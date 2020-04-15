function M = Whiteley(n)
%northwestern MATLAB colormap nx3 array for northwestern purple.
%
% By Yifu
% 2018/08/20
%
% https://www.mccormick.northwestern.edu/marketing/logos-and-branding/color-usage-guidelines.html

if n < 6, error('Must be bigger than 5 colors.'); end

y = [255,255,0];
r = [255,60,0];
k = [0,0,0];
b = [0,0,128];
bl = [0,191,255];
w = [240,248,255];
c1 = interp1([1,25,50,60,80,100]/100*n,[y(1),r(1),k(1),b(1),bl(1),w(1)],1:n);
c2 = interp1([1,25,50,60,80,100],[y(2),r(2),k(2),b(2),bl(2),w(2)],1:n);
c3 = interp1([1,25,50,60,80,100],[y(3),r(3),k(3),b(3),bl(3),w(3)],1:n);
M = [c1',c2',c3']/256;


end