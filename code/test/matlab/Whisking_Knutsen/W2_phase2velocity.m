clear
%% Input requirements
% timestep; Min and Max EulerTheta used; normalized phase from experiments
fps = 100;
dt = 1/fps;
whisk_freq = 8;
EulerThetaMin = 70; % Read from the video data
EulerThetaMax = 130; % Should also read from the video data

%%Example input: sinus whisking%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t = 0:dt:7/3;
% phase = cos(2*pi*whisk_freq*t + pi)/2 + 0.5;
%%Example input: from Kevin%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = 0:dt:700/fps;
phase = load('trajectory_from_Kevin/phase.mat');
phase = phase.phase;


% Load look-up data ranging from ~70+[-60,60] = [10, 130]
data = load('angles_in_whisking_[-60,60].mat');
EulerThetaPhase = mean(data.EulerThetas);


%% Step 1: get orienation angles/matrix from each time step
EulerThetaList = phase;
EulerThetasList = interp1(EulerThetaPhase, data.EulerThetas', phase)';
EulerPhisList = interp1(EulerThetaPhase, data.EulerPhis', phase)';
EulerZetasList = interp1(EulerThetaPhase, data.EulerZetas', phase)';

% create orientation matrix (both right and left)
nStep = length(phase);
orientMat = cell(62,nStep);
for s = 1:nStep
    for i = 1:31
        theta = EulerThetasList(i, s);
        phi = EulerPhisList(i, s);
        zeta = EulerZetasList(i, s);
        % Right
        orientMat{i, s} = rotz(theta, 'deg')*rotx(-phi, 'deg')*...
                          roty(-zeta, 'deg');
        % Left
        orientMat{i+31, s} = rotz(-theta, 'deg')*rotx(-phi, 'deg')*...
                          roty(zeta, 'deg');
    end
end

%% Step 2: Get angular velocity tensor by 
% d(Rsb)/dt = [w]*Rsb
% [w] = dA/dt*A';
% Differentiation is done by "symmetric difference quotrient", so that the
% first order error is canceled.
W = cell(62, nStep-2);
for tt = 2:nStep-1
    for i = 1:62
        W{i, tt-1} = (orientMat{i, tt+1}-orientMat{i, tt-1})/2/dt*orientMat{i, tt}';
    end
end

%% Step 3: convert tensor to vector
% a_vel is a 60x(nStep*3) matrix with 30 whiskers on each side.
% 1-5    6-10   11-17    19-24    25-30
% A12345 B12345 C1234567 D1234567 E234567

a_vel = cell2mat(cellfun(@tensor2vector, W, 'UniformOutput', false));
writematrix(a_vel, '../../../data/whisking_trajectory_sample.csv', 'Delimiter', ',');

%% Step 4: 
a_loc = [EulerThetasList(:,1), EulerPhisList(:,1), EulerZetasList(:,1);...
         -EulerThetasList(:,1), EulerPhisList(:,1), -EulerZetasList(:,1)]*pi/180;
writematrix(a_loc, '../../../data/whisking_init_angle_sample.csv', 'Delimiter', ',');

function w = tensor2vector(W)
    w = zeros(1,3);
    w(1) = W(3,2);
    w(2) = W(1,3);
    w(3) = W(2,1);
end




