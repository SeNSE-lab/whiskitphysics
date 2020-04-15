function [Err,AllErr,N,P] = fit_3D_data(XData, YData, ZData, geometry, visualization, sod,varargin)
%
% [Err, N, P] = fit_3D_data(XData, YData, ZData, geometry, visualization, sod)
%
% Orthogonal Linear Regression in 3D-space  
% by using Principal Components Analysis
%
% This is a wrapper function to some pieces of the code from 
% the Statistics Toolbox demo titled "Fitting an Orthogonal 
% Regression Using Principal Components Analysis" 
% (http://www.mathworks.com/products/statistics/
%  demos.html?file=/products/demos/shipping/stats/orthoregdemo.html),
% which is Copyright by the MathWorks, Inc.
%
% Input parameters:
%  - XData: input data block -- x: axis
%  - YData: input data block -- y: axis
%  - ZData: input data block -- z: axis
%  - geometry: type of approximation ('line','plane') 
%  - visualization: figure ('on','off') -- default is 'on'
%  - sod: show orthogonal distances ('on','off') -- default is 'on'
% Return parameters:
%  - Err: error of approximation - sum of orthogonal distances 
%  - N: normal vector for plane, direction vector for line
%  - P: point on plane or line in 3D space
%
% Ivo Petras, Igor Podlubny, May 2006
% (ivo.petras@tuke.sk, igor.podlubny@tuke.sk)
%
% Example:
%
% >> XD = [4.8 6.7 6.2 6.2 4.1 1.9 2.0]';
% >> YD = [13.4 9.9 5.8 6.1 6.7 10.6 11.5]';
% >> ZD = [13.7 13.1 11.3 11.8 12.5 16.2 18.5]';
% >> fit_3D_data(XD,YD,ZD,'line','on','on');
% >> fit_3D_data(XD,YD,ZD,'plane','on','off');
%
% Note: Written for Matlab 7.0 (R14) with Statistics Toolbox
%
% We sincerely thank Peter Perkins, the author of the demo,
% and John D'Errico for their comments.
%
if nargin<6 , visualization='on'; sod='on';
end
%
X(:,1) = XData(:,1);
X(:,2) = YData(:,1);
X(:,3) = ZData(:,1);
%
[coeff,score] = pca(X);
normal = coeff(:,3);
[n,p] = size(X);
meanX = mean(X,1);
Xfit = repmat(meanX,n,1) + score(:,1:2)*coeff(:,1:2)';
%
error = abs((X - repmat(meanX,n,1))*normal);
Err = sum(error.^2);
AllErr = error;
%
switch lower(geometry)
     case {'plane'}
     N=normal;
     P=meanX;
     switch lower(visualization)
     case {'on'}
        [xgrid,ygrid] = meshgrid(linspace(min(X(:,1)),max(X(:,1)),5), ...
                         linspace(min(X(:,2)),max(X(:,2)),5));
        zgrid = (1/normal(3)) .* (meanX*normal - (xgrid.*normal(1) + ygrid.*normal(2)));
        h = mesh(xgrid,ygrid,zgrid,'EdgeColor','none','FaceColor',varargin{1},'FaceAlpha',.5);
        hold on
        above = (X-repmat(meanX,n,1))*normal > 0;
        below = ~above;
        nabove = sum(above);
        X1 = [X(above,1) Xfit(above,1) nan*ones(nabove,1)];
        X2 = [X(above,2) Xfit(above,2) nan*ones(nabove,1)];
        X3 = [X(above,3) Xfit(above,3) nan*ones(nabove,1)];
        switch lower(sod)
            case {'off'}
%                 plot3(X(above,1),X(above,2),X(above,3),'cyan*'); 
            case {'on'}    
%                 plot3(X1',X2',X3','cyan-', X(above,1),X(above,2),X(above,3),'cyano');
        end   
        nbelow = sum(below);
        X1 = [X(below,1) Xfit(below,1) nan*ones(nbelow,1)];
        X2 = [X(below,2) Xfit(below,2) nan*ones(nbelow,1)];
        X3 = [X(below,3) Xfit(below,3) nan*ones(nbelow,1)];
        switch lower(sod)
            case {'off'}
%                 plot3(X(below,1),X(below,2),X(below,3),'blue*');
            case {'on'}    
%                 plot3(X1',X2',X3','blue-', X(below,1),X(below,2),X(below,3),'blueo');
        end        
     case{'off'}
        %disp('No visualization.')
     otherwise
        disp('Wrong input parameter.')
     end
%
     case {'line'}
        dirVect = coeff(:,1);
        Xfit1 = repmat(meanX,n,1) + score(:,1)*coeff(:,1)';
        t = [min(score(:,1))-.2, max(score(:,1))+.2];
        endpts = [meanX + t(1)*dirVect'; meanX + t(2)*dirVect'];
        N=dirVect;
        P=meanX;
     switch lower(visualization)
     case {'on'}
        plot3(endpts(:,1),endpts(:,2),endpts(:,3),'black-');
        X1 = [X(:,1) Xfit1(:,1) nan*ones(n,1)];
        X2 = [X(:,2) Xfit1(:,2) nan*ones(n,1)];
        X3 = [X(:,3) Xfit1(:,3) nan*ones(n,1)];
        hold on
        switch lower(sod)
            case {'off'}
%                 plot3(X(:,1),X(:,2),X(:,3),'blue*');
            case {'on'}    
                plot3(X1',X2',X3','cyan-', X(:,1),X(:,2),X(:,3),'blueo');
        end
        grid;
     case{'off'}
        %disp('No visualization.')
     otherwise
        disp('Wrong input parameter.')
     end
     otherwise
        disp('Unknown object.') 
        close all;
end
%