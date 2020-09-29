
% This function generates whisker angles in a whisking phase and
% generates a look-up table based on averaged EulerTheta angles for 
% WHISKiT Physics.
% Authors: Yifu Luo, Nadina Zweifel
% ========================================================================
% Inputs
    % retr_degree:  retraction angle in degrees
    % prot_degree:  protraction angle in degrees 
    % whisk_freq:   whisking frequency in Hz
    % time_stop:    duration of simulation in seconds
% Outputs:
    % CSV file with whisker trajectories for simulation
    
function compute_angles_model_rat(retr_degree,prot_degree,whisk_freq,time_stop)
    
    max_whiskers = 62;
    fps = 1000;
    dt = 1/fps;
   
    data = load('../code/data/param_bp_angles.csv');
    
    %% Collecting information
    % a_vel is a 62x(nStep*3) matrix with 31 whiskers on each side.
    % 1-5    6-11    12-18    20-25    26-31
    % A12345 B123456 C1234567 D1234567 E234567
    
    minimap = containers.Map();
    % for every whisker, put info into the container
    for col = 1:5
        this_name = ['A0', num2str(col)];
        this_index = 1:5;
        this_struct.EulerTheta = data(this_index(col), 1);
        this_struct.EulerPhi = data(this_index(col), 2);
        this_struct.EulerZeta = data(this_index(col), 3);
        minimap(this_name) = this_struct;
    end
    for col = 1:6
        this_name = ['B0', num2str(col)];
        this_index = 6:11;
        this_struct.EulerTheta = data(this_index(col), 1);
        this_struct.EulerPhi = data(this_index(col), 2);
        this_struct.EulerZeta = data(this_index(col), 3);
        minimap(this_name) = this_struct;
    end
    for col = 1:7
        this_name = ['C0', num2str(col)];
        this_index = 12:18;
        this_struct.EulerTheta = data(this_index(col), 1);
        this_struct.EulerPhi = data(this_index(col), 2);
        this_struct.EulerZeta = data(this_index(col), 3);
        minimap(this_name) = this_struct;
    end
    for col = 1:7
        this_name = ['D0', num2str(col)];
        this_index = 19:25;
        this_struct.EulerTheta = data(this_index(col), 1);
        this_struct.EulerPhi = data(this_index(col), 2);
        this_struct.EulerZeta = data(this_index(col), 3);
        minimap(this_name) = this_struct;
    end
    for col = 2:7
        this_name = ['E0', num2str(col)];
        this_index = [nan,26:31];
        this_struct.EulerTheta = data(this_index(col), 1);
        this_struct.EulerPhi = data(this_index(col), 2);
        this_struct.EulerZeta = data(this_index(col), 3);
        minimap(this_name) = this_struct;
    end

    % The whisker start at rest.
    % Azimuth span: -retr_degree~prot_degree
    
    timepoints = 101;
    k = keys(minimap)';
    EulerThetas = zeros(31, timepoints);
    EulerPhis = zeros(31, timepoints);
    EulerZetas = zeros(31, timepoints);
    
    % Elevation with azimuth
    dPhi = [0.12*ones(5,1);     %   A row:  0.12 +/- 0.17
            0.3*ones(6,1);      %   B row:  0.30 +/- 0.17
            0.3*ones(7,1);      %   C row:  0.30 +/- 0.13
            0.14*ones(7,1);     %   D row:  0.14 +/- 0.14
            -0.02*ones(6,1)];   %   E row:  -0.02 +/- 0.13
    % Torsion with azimuth
    dZeta = [-0.75*ones(5,1);   %   A row:  -0.75
            -0.25*ones(6,1);    %   B row:  -0.25
            0.20*ones(7,1);     %   C row:  0.20
            0.40*ones(7,1);     %   D row:  0.40
            0.73*ones(6,1)];    %   E row:  0.73
    % for 30 whiskers
    for i = 1:31
        EulerThetaRest = nanmean(minimap(k{i}).EulerTheta)*180/pi;
        EulerPhiRest = nanmean(minimap(k{i}).EulerPhi)*180/pi;
        EulerZetaRest = nanmean(minimap(k{i}).EulerZeta)*180/pi;

        EulerThetas(i, :) = linspace(EulerThetaRest-retr_degree, EulerThetaRest+prot_degree, timepoints);
        EulerPhis(i, :) = linspace(EulerPhiRest+retr_degree*dPhi(i), EulerPhiRest+prot_degree*dPhi(i), timepoints);
        EulerZetas(i, :) = linspace(EulerZetaRest-retr_degree*dZeta(i), EulerZetaRest+prot_degree*dZeta(i), timepoints);
    end
      
    % Load look-up data ranging from ~70+[-retraction,protraction]
    EulerThetaPhase = mean(EulerThetas);
    EulerThetaMin = min(EulerThetaPhase);
    EulerThetaMax = max(EulerThetaPhase);
    
    % generating sinusoidal whisking trajectory
    t = 0:dt:time_stop;
    phase = cos(2*pi*whisk_freq*t + pi)*(EulerThetaMax-EulerThetaMin)/2 ...
            + (EulerThetaMax+EulerThetaMin)/2;

    %% Step 1: get orienation angles/matrix from each time step
    EulerThetasList = interp1(EulerThetaPhase, EulerThetas', phase,'spline')';
    EulerPhisList = interp1(EulerThetaPhase, EulerPhis', phase,'spline')';
    EulerZetasList = interp1(EulerThetaPhase, EulerZetas', phase,'spline')';
    
   % create orientation matrix (both right and left)
    nStep = length(phase);
    orientMat = cell(max_whiskers,nStep);
    for s = 1:nStep
        for i = 1:(max_whiskers/2)
            theta = EulerThetasList(i, s);
            phi = EulerPhisList(i, s);
            zeta = EulerZetasList(i, s);
            % Right
            orientMat{i, s} = rotz(theta, 'deg')*rotx(-phi, 'deg')*...
                              roty(-zeta, 'deg');
            % Left
            orientMat{i+(max_whiskers/2), s} = rotz(-theta, 'deg')*rotx(-phi, 'deg')*...
                              roty(zeta, 'deg');
        end
    end


    %% Step 2: Get angular velocity tensor by 
    % d(Rsb)/dt = [w]*Rsb
    % [w] = dA/dt*A';
    % Differentiation is done by "symmetric difference quotrient", so that the
    % first order error is canceled.
    W = cell(max_whiskers, nStep-1);
    for tt = 2:nStep-1
        for i = 1:max_whiskers
            W{i, tt} = (orientMat{i, tt+1}-orientMat{i, tt-1})/2/dt*orientMat{i, tt}';
        end
    end
    % add first
    for i = 1:max_whiskers
        W{i, 1} = (orientMat{i, 2}-orientMat{i, 1})/dt*orientMat{i, 1}';
    end

    %% Step 3: convert tensor to vector
    % a_vel is a 62x(nStep*3) matrix with 31 whiskers on each side.
    % 1-5    6-11    12-18    19-25    26-31
    % A12345 B12345 C1234567 D1234567 E234567

    a_vel = cell2mat(cellfun(@tensor2vector, W, 'UniformOutput', false));
    writematrix(a_vel, '../code/data/whisking_trajectory_sample.csv', 'Delimiter', ',');

    %% Step 4: 
    a_loc = [EulerThetasList(:,1), EulerPhisList(:,1), EulerZetasList(:,1);...
             -EulerThetasList(:,1), EulerPhisList(:,1), -EulerZetasList(:,1)]*pi/180;
    writematrix(a_loc, '../code/data/whisking_init_angle_sample.csv', 'Delimiter', ',');
 
 end

function w = tensor2vector(W)
    w = zeros(1,3);
    w(1) = W(3,2);
    w(2) = W(1,3);
    w(3) = W(2,1);
end
