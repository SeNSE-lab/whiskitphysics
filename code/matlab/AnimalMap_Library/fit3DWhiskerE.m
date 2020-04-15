function [x, RotWH, fval] = fit3DWhiskerE(rawWH,rawBP,Side,varargin)
%fit3DWhiskerYifu The puropse of this function is the find the parameters 
% that describe the whisker's shape and orientation from a 3d scan. 
% To do this the code runs two optimizations. The first aims to figure out
% the Euler angles, the second aims to find the curvature paramters
% specified by your fitType.
% 
%   [x,RotWH,error] = fit3DWhiskerYifu(rawWH,rawBP,Side)
%   [x,RotWH,error] = fit3DWhiskerYifu(rawWH,rawBP,Side,fitType)
%   
%   Inputs:
%       rawWH: the whisker coordinates of size 3xV
%       rawBP: the basepoint coordiante of zie 3x1
%       Side:  the whisker side information with 1 representing 'Right'
%       fitType: 'quadratic'(default), 'cubic', 'circle'
% 
%   Outputs:
%       x: the whisker parameters in the following order 
%          quadratic: [theta, phi, zeta, A coefficient, S arclength]
%          cubic:     [theta, phi, zeta, A coefficient, B coefficient, S arclength]
%          circle:    [theta, phi, zeta, R radius, S arclength]
%          output angles are in degrees.
%       RotWH: the fitted whisker
%       error: the error of the fit
%
%   Changes to previous version of Mike's (Almost everything, but things 
%   you need to notice):
%       (1) rewrite the Euler rotations order.
%       (2) change algorithm for fmincon to default (interior-point)
%       (3) previous optimization runs over all the parameters, current
%       version separates them, so you have more control over them and
%       makes the code more robust.
%
%
%  By Yifu
%  2018/02/26

%% error
if isempty(varargin)
    fitType = 'quadratic'; % Defalt
elseif strcmp(varargin{1},'quadratic') || strcmp(varargin{1},'cubic') ...
        || strcmp(varargin{1},'circle') || strcmp(varargin{1},'cubic3')
    fitType = varargin{1};
else
    error('You need to specify whether the fitType is "quadratic", "cubic" or "circle".')
end

%% Prepare whisker
% Make sure the points are ordered correctly
d = distancePoints3d(rawWH',rawBP');
[~,indxSort]=sortrows(d);
rawWH = rawWH(:,indxSort);

% Smooth
SMOOTH = 0;
if SMOOTH
    whisker(1,:) = smooth(rawWH(1,:));
    whisker(2,:) = smooth(rawWH(2,:));
    whisker(3,:) = smooth(rawWH(3,:));
else
    whisker(1,:) = rawWH(1,:);
    whisker(2,:) = rawWH(2,:);
    whisker(3,:) = rawWH(3,:);
end
[x,y,z]=equidistlen3d(whisker(1,:),whisker(2,:),whisker(3,:),0.2);
clear whisker
whisker(1,:) = x';
whisker(2,:) = y';
whisker(3,:) = z';

whisker_bp = whisker - repmat(whisker(:,1),1,size(whisker,2));

%% Initial Guess
S = 0;
for i = 1:size(whisker_bp,2)-1
    S = S + norm(whisker_bp(:,i+1)-whisker_bp(:,i));
end
midIndx = int8(size(whisker_bp,2)/3);
% The principle of this guessing process is to do reversed Euler rotations.
% theta and phi are given by the spherical coordiantes
[th0,ph0,~] = cart2sph(whisker_bp(1,midIndx),whisker_bp(2,midIndx),whisker_bp(3,midIndx));
th0 = wrapTo2Pi(th0+pi/2);
ph0 = wrapToPi(ph0);
transWhisker = rotx(ph0)*rotz(-th0)*[[0;0;0],whisker_bp(:,midIndx),whisker_bp(:,end)];
% plot3(whisker_bp(1,:),whisker_bp(2,:),whisker_bp(3,:),'Color','k');hold on
% plot3([0;whisker_bp(1,midIndx);whisker_bp(1,end)],[0;whisker_bp(2,midIndx);whisker_bp(2,end)],...
%     [0;whisker_bp(3,midIndx);whisker_bp(3,end)],'Color','r');
% plot3([0;transWhisker(1,2);transWhisker(1,3)],[0;transWhisker(2,2);transWhisker(2,3)],...
%     [0;transWhisker(3,2);transWhisker(3,3)],'Color','b')
% zeta is given by polor coordiantes of the reversly adjusted whisker.
[ze0,~] = cart2pol(transWhisker(1,3)-transWhisker(1,2),transWhisker(3,3)-transWhisker(3,2));
ze0 = -wrapToPi(ze0+pi/2);
% % transWhisker before optimization
% transWhisker = roty(-ze0)*rotx(ph0)*rotz(-th0)*whisker_bp;

%     theta zeta
ub = [2*pi  pi  ];
lb = [0    -pi  ];
x0 = [th0   ze0];

%% Euler angles optimization
% Remark: phi is fixed to make this more robust. Generally it is dicovered
% that phi value won't affect too much to the result.
[angles,fval]=fmincon(@(x)generateWhiskerCostFunc(x,ph0,whisker_bp), x0,[],[],[],[],lb,ub,[],...
        optimset('MaxIter',2000,'TolFun',1e-6,'TolX',1e-6,'display','off'));
angles = [angles(1),ph0,angles(2)];
transWhisker = roty(-angles(3))*rotx(angles(2))*rotz(-angles(1))*whisker_bp;


%% Curve fitting
switch fitType
    case 'quadratic'
    g = fittype(@(a,x) a*x.^2,...
        'coefficients', {'a'});
    b = fit(-transWhisker(2,:)',-transWhisker(3,:)',g,'StartPoint',0.01);
    A = b.a;
    x = [angles   A  S];
    transFit = [zeros(1,size(transWhisker,2));transWhisker(2,:);...
        -A*(-transWhisker(2,:)).^2];
    case 'cubic'
    g = fittype(@(a,b,x) a*x.^3+b*x.^2,...
        'coefficients', {'a','b'});
    b = fit(-transWhisker(2,:)',-transWhisker(3,:)',g,'StartPoint',[0.01 0.01]);
    A = b.a;
    B = b.b;
    x = [angles   A   B   S];
    transFit = [zeros(1,size(transWhisker,2));transWhisker(2,:);...
        -A*(-transWhisker(2,:)).^3-B*(-transWhisker(2,:)).^2];
    case 'cubic3'
    g = fittype(@(a,x) a*x.^3,...
        'coefficients', {'a'});
    b = fit(-transWhisker(2,:)',-transWhisker(3,:)',g,'StartPoint',0.01);
    A = b.a;
    x = [angles   A  S];
    transFit = [zeros(1,size(transWhisker,2));transWhisker(2,:);...
        -A*(-transWhisker(2,:)).^3];
    case 'circle'
    g = fittype(@(R,x) -(R^2-x.^2).^(1/2)+R,...
        'coefficients', {'R'});
    b = fit(-transWhisker(2,:)',-transWhisker(3,:)',g,'Lower',1,'Upper',500,'StartPoint',100);
    R = b.R;
    x = [angles   R   S];
    error('Still working on this part.')
end


%% Final fitted whisker
RotWH = generateWhisker(x,transFit) + repmat(whisker(:,1),1,size(whisker,2));

%% In-function Plotting
% It plots a whisker in the space considering what side it is on.
PLOTTING = 1;
if PLOTTING
    plot3((-1)^(1-Side)*rawWH(1,:),rawWH(2,:),rawWH(3,:),'-','Color','k')
    hold on;
    plot3d(mirrorX(RotWH,1-Side),'.r');
    plot3d(mirrorX(whisker,1-Side),'.g');
    plot3d(mirrorX(transWhisker),'-k');
    plot3d(mirrorX(transFit),'-r');
    grid on; axis image;
    h=plot3d(mirrorX(rawBP,1-Side),'.c');
    set(h,'MarkerSize',15);
%     pause(0.5)
end
end

%%
function cost = generateWhiskerCostFunc(th_ze,ph,whisker_bp)
% Generate guessed whisker
angles = [th_ze(1),ph,th_ze(2)];
transWhisker = degenerateWhisker(angles,whisker_bp);

midIndx = int8(size(whisker_bp,2)/3);
% To constrain the whisker doesn't go too far up
cost0 = 0; upNum = 0;
for i = 1:size(transWhisker,2)
    if transWhisker(3,i) > 0, cost0 = cost0 + transWhisker(3,i)^2; end
    upNum = upNum + 1;
end
% Square distance between transWhisker and y-z plane
cost = transWhisker(1,:)*transWhisker(1,:)'/size(transWhisker,2)...
    +(transWhisker(1,1:midIndx)*transWhisker(1,1:midIndx)'...
    +transWhisker(3,1:midIndx)*transWhisker(3,1:midIndx)')/double(midIndx)...
    +cost0;
cost = transWhisker(1,:)*transWhisker(1,:)'/size(transWhisker,2)...
    +cost0/upNum;
end

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

function RotWhisker = generateWhisker(angles,transFit)
% Input angles are in radians
% Rotate whisker
% The rotation order is
% (1) zeta around y-axis
% (2) phi around -x-axis
% (3) theta around z-axis
zeta = angles(3);
phi = angles(2);
theta = angles(1);
RotWhisker = rotz(theta)*rotx(phi)'*roty(zeta)*transFit;
end



