function [x, transWhisker, fval] = fit3DPlane(rawWH,rawBP,Side)
%fit3DPlane The puropse of this function is the find the parameters 
% that describe the whisker's plane from a 3D scan. 
% To do this the code runs an optimization over 3 parameters: 
% Euler- [theta, phi, zeta]
% 
%   [x,transWhisker,fval] = fit3DPlane(rawWH,rawBP,Side)
%   
%   Inputs:
%       rawWH: the whisker coordinates of size 3xV
%       rawBP: the basepoint coordiante of zie 3x1
%       Side:  the whisker side information with 0 representing 'Left'
%       fitType: 'quadratic' as default
%       * In this version, cubic fit is not considered
% 
%   Outputs:
%       x: the whisker parameters in the following order 
%          [theta, phi, zeta, A coefficient, S arclength]
%          out put angles are in degrees.
%       RotWH: the fit whisker
%       fval: the distance error of the fit
%
%   Changes to previous version of Mike's:
%       (1) rewrite the Euler rotations order.
%       (2) change algorithm for fmincon to default (interior-point)
%       (3) disregard fitType
%
%  By Yifu
%  2017/11/16


%% Prepare whisker

whisker(1,:) = rawWH(1,:);
whisker(2,:) = rawWH(2,:);
whisker(3,:) = rawWH(3,:);
[x,y,z]=equidistlen3d(whisker(1,:),whisker(2,:),whisker(3,:),0.5);
clear whisker
whisker(1,:) = x';
whisker(2,:) = y';
whisker(3,:) = z';
whisker_bp = whisker - repmat(whisker(:,1),1,size(whisker,2));

%% Initial Guess
midIndx = int8(size(whisker_bp,2)/3);

% The principle of this guessing process is to do reversed Euler rotations.
% theta and phi are given by the spherical coordiantes
[th0,ph0,~] = cart2sph(whisker_bp(1,midIndx),whisker_bp(2,midIndx),whisker_bp(3,midIndx));
th0 = wrapTo2Pi(th0+pi/2);
ph0 = wrapToPi(ph0);
guessVec = rotx(ph0)*rotz(-th0)*[[0;0;0],whisker_bp(:,midIndx),whisker_bp(:,end)];
plot3(whisker_bp(1,:),whisker_bp(2,:),whisker_bp(3,:),'Color','k');hold on
plot3([0;whisker_bp(1,midIndx);whisker_bp(1,end)],[0;whisker_bp(2,midIndx);whisker_bp(2,end)],...
    [0;whisker_bp(3,midIndx);whisker_bp(3,end)],'Color','r');
plot3([0;guessVec(1,2);guessVec(1,3)],[0;guessVec(2,2);guessVec(2,3)],...
    [0;guessVec(3,2);guessVec(3,3)],'Color','b')
% zeta is given by polor coordiantes of the reversly adjusted whisker.
[ze0,~] = cart2pol(guessVec(1,3)-guessVec(1,2),guessVec(3,3)-guessVec(3,2));
ze0 = -wrapToPi(ze0+pi/2);

%     theta  zeta
ub = [2*pi   pi  ];
lb = [0     -pi  ];
x0 = [th0    ze0];

%% Fitting Optimization
[x,fval]=fmincon(@(x)generateWhiskerCostFunc(x,ph0,whisker_bp), x0,[],[],[],[],lb,ub,[],...
        optimset('MaxIter',2000,'TolFun',1e-6,'TolX',1e-6,'display','off'));
x = [x(1),ph0,x(2)];
transWhisker = degenerateWhisker(x,whisker_bp) + repmat(whisker(:,1),1,size(whisker,2));


%% In-function Plotting
% It plots a whisker in the space considering what side it is on.
PLOTTING = 1;
if PLOTTING
    plot3d(mirrorX(whisker,1-Side),'k');
    hold on;
    plot3d(mirrorX(transWhisker,1-Side),'.r');
    grid on; axis image;
    h=plot3d(mirrorX(rawBP,1-Side),'.c');
    set(h,'MarkerSize',15);
    pause(0.5)
end

%clear global
end
%%
function cost=generateWhiskerCostFunc(th_ze,ph,whisker_bp)
% Generate guessed whisker
angles = [th_ze(1),ph,th_ze(2)];
transWhisker = degenerateWhisker(angles,whisker_bp);
% Square distance between degenerated whisker and y-z plane
cost = mean(abs(transWhisker(1,:)));
end

%%
function transWhisker = degenerateWhisker(angles,whisker_bp)
% Input angles are in radians
% degenerate whisker
% The rotation order is
% (1) zeta around y-axis
% (2) phi around -x-axis
% (3) theta around z-axis
% It should be reveresed
zeta = angles(3);
phi = angles(2);
theta = angles(1);
transWhisker = (rotz(theta)*rotx(phi)'*roty(zeta))'*whisker_bp;
end





