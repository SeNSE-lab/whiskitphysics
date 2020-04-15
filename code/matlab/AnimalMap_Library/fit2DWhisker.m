function [parameter,GAMMA] = fit2DWhisker(whisker,fitType)
%fit2DWhisker fit 2D whisker. Adjust them by angle gamma, output parameter
%where minimum R^2 happens.
%
%   [parameter,GAMMA] = fit2DWhisker(whisker,fitType) takes whisker 2D
%   information and returns the rotated angle where the best fit happens
%   (least square distance) and the fitting parameter.
%
%   fitType = 'quadratic': A*x^2+B*x -> parameter = [A, B]
%
% By Yifu
% 2018/02/06

R2 = 0;
for gamma = linspace(-pi/2,pi/2,100)
    whiskerNow = rot2(gamma)*whisker;
    g = fittype(@(a,b,x) a*x.^2 + b*x,'coefficients', {'a','b'});
    [F0,G] = fit(whiskerNow(1,:)',whiskerNow(2,:)',g,'StartPoint',[0.01 0.01]);
    if G.rsquare > R2
        R2 = G.rsquare;
        parameter = [F0.a, F0.b];
        GAMMA = gamma;
    end
end

% Check plot
clf;
whiskerNow = rot2(GAMMA)*whisker;
plot(whiskerNow(1,:),whiskerNow(2,:),'b.');hold on
X = linspace(-5,30,200);
plot(X,parameter(1)*X.^2+parameter(2)*X,'r-');
plot(whisker(1,:),whisker(2,:),'k.');
axis equal
axis([-10 40 -20 50])




end

