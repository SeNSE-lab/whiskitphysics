function K = whiskerCurvature2D(A, B, S)
%whiskerCurvature2D finds the normalized 2D whisker curvature by
%integrating the curvature of the fitted 2D whisker along the length, and
%divided by the length.
%
% By Yifu
% 2019/07/08

% MODEL:                y = A*x^3 + B*x^2
% Curvature:            k = abs(y'')/(1+(y')^2)^1.5
% N-curvature:          K = integrate(k, dx)/S


% A = 1; B = 1; S = 10; 
nPts = 100;
[x, ~] = acoeff2cart_poly3(A, B, S, nPts);

K = integral(@(x) abs(6*A*x+2*B)./(1+(3*A*x.^2+2*B*x).^2).^1.5, 0, max(x))/S;


end