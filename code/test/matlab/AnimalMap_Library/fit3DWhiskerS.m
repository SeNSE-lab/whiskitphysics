function [x, RotWH, fval, smoothWhisker, fittedWhisker] =...
    fit3DWhiskerS(rawWH,rawBP,Side,varargin)
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
%  2018/03/27

PURP = [104, 76, 150]/256;
BLUE = [135, 206, 250]/256;

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
% if rawBP(1,1) ~= rawWH(1,1)
%     rawWH = [rawBP,rawWH];
% end
% Make sure the points are ordered correctly
d = distancePoints3d(rawWH',rawBP');
[~,indxSort]=sortrows(d);
rawWH = rawWH(:,indxSort);

% Smooth
SMOOTH = 1;
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

%% Angles
% Toal length
S = sum(sqrt(sum((whisker_bp(:,2:end) - whisker_bp(:,1:end-1)).^2,1)));
% The cut-off index for the proximal whisker
proxIndx = int8(size(whisker_bp,2)*30/100);
% A line fitting for the proximal whisker
[vec, val] = eig(cov(whisker_bp(:,1:proxIndx)'));
[~, maxIndx] = max(diag(val));
v = (-1)^(vec(1,maxIndx)<0)*vec(:,maxIndx);
[th,ph,~] = cart2sph(v(1),v(2),v(3));
th = wrapTo2Pi(th+pi/2);
ph = wrapToPi(ph);
transWhisker = rotx(ph)*rotz(-th)*whisker_bp;
% plot3d(whisker_bp,'k-');hold on
% plot3d(transWhisker,'b-')
% plot3d([0,-2,0;0,0,0;2*vec(:,maxIndx)'],'r-')

% The initial guess of zeta is given by polor coordiantes of the reversly adjusted whisker.
[ze0,~] = cart2pol(transWhisker(1,end)-transWhisker(1,proxIndx),transWhisker(3,end)-transWhisker(3,proxIndx));
ze0 = -wrapToPi(ze0+pi/2);

%% Euler angles optimization
% Remark: phi is fixed to make this more robust. Generally it is found
% that phi value won't affect too much to the result.
[ze,fval]=fmincon(@(x)generateWhiskerCostFunc(x,th,ph,whisker_bp), ze0,[],[],[],[],-pi,pi,[],...
        optimset('MaxIter',2000,'TolFun',1e-6,'TolX',1e-6,'display','off'));
transWhisker = roty(-ze)*rotx(ph)*rotz(-th)*whisker_bp;


%% Curve fitting
angles = [th, ph, ze];
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
    hdl = plot3d(mirrorX(RotWH,1-Side),'.r');
    set(hdl, 'Color', PURP)
    hdl = plot3d(mirrorX(whisker,1-Side),'.g');
    set(hdl, 'Color', BLUE)
%     plot3d(mirrorX(transWhisker,1-Side),'-k');
%     plot3d(mirrorX(transFit,1-Side),'-r');
    grid on; axis image;
    h=plot3d(mirrorX(rawBP,1-Side),'.c');
    set(h,'MarkerSize',15);
    
    plot3d(mirrorX(RotWH(:,1),1-Side),'oc');
%     pause(0.5)
end
smoothWhisker = mirrorX(whisker,1-Side)';
fittedWhisker = mirrorX(RotWH,1-Side)';

end

%%
function cost = generateWhiskerCostFunc(ze,th,ph,whisker_bp)
% Generate guessed whisker
angles = [th, ph, ze];
transWhisker = degenerateWhisker(angles,whisker_bp);

proxIndx = int8(size(whisker_bp,2)*30/100);
% To constrain the whisker doesn't go too far up
cost0 = 0; upNum = 0;
for i = 1:size(transWhisker,2)
    if transWhisker(3,i) > 0, cost0 = cost0 + transWhisker(3,i)^2; end
    upNum = upNum + 1;
end
% Square distance between transWhisker and y-z plane
cost = transWhisker(1,:)*transWhisker(1,:)'/size(transWhisker,2)...
    +(transWhisker(1,1:proxIndx)*transWhisker(1,1:proxIndx)'...
    +transWhisker(3,1:proxIndx)*transWhisker(3,1:proxIndx)')/double(proxIndx)...
    +cost0;
cost = transWhisker(1,:)*transWhisker(1,:)'/size(transWhisker,2)...
    +cost0/upNum;
end

function transWhisker = degenerateWhisker(angles,whisker_bp)
% Input angles are in radians
% degenerate whisker
% The rotation order is
% (1) zeta around y-axis (note: EulerZeta is flipped in Part3 code)
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
% (1) zeta around y-axis (note: EulerZeta is flipped in Part3 code)
% (2) phi around -x-axis
% (3) theta around z-axis
zeta = angles(3);
phi = angles(2);
theta = angles(1);
RotWhisker = rotz(theta)*rotx(phi)'*roty(zeta)*transFit;

%************The sign for Zeta is fixed in Part3 of the code**************
% So, for the correct usage of the final data:
% (1) zeta around -y-axis 
% (2) phi around -x-axis
% (3) theta around z-axis


end



