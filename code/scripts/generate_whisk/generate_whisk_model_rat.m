%% * function generate_whisk_average_rat(retr_degree,prot_degree,whisk_freq,time_stop)
% This function generates the angular velocity needed to simulate a whisk
% of [whisk_freq] Hz for [time_stop] seconds by protracting the whiskers by
% [prot_degree] degrees and retracting the whiskers by [retr_degree]
% degrees in reference of the mean angle of the total whisk amplitude. The
% generated trajectory is written to a CSV file which serves as input to
% the model WHISKiT Physics. The generated data is consistent with the
% average array from Belli et al, 2018. Note that the average array does
% not include a B5 whisker and therefore only consists of 60 whiskers
% total.
% Authors: Yifu Luo, Nadina Zweifel
% ========================================================================
% INPUTS:
    % retr_degree:  retr_degree angle in degrees
    % prot_degree:  prot_degree angle in degrees 
    % whisk_freq:   whisking frequency in Hz
    % time_stop:    duration of simulation in seconds
% OUTPUTS:
    % CSV file with whisker trajectories for simulation
    
function generate_whisk_model_rat(retr_degree,prot_degree,whisk_freq,time_stop)

    fps_target = 1000;
    dt_target = 1/fps_target;
    
    %% Collecting information    
%     filename = 'new_ratmap_data.xlsx';
%     sheet = 'Average Rat';
%     [data_avg,txt] = xlsread(filename,sheet);
% 
%     num_whiskers = length(data_avg(:,1)); % get number of whiskers
%     max_whiskers = num_whiskers * 2;
% 
%     % read average whisker data_avg
%     EulerThetaRest = data_avg(:,3);
%     EulerPhiRest = data_avg(:,4);
%     EulerZetaRest = data_avg(:,5);

    param = compute_parameters('model','../../data/whisker_param_model_rat/',0);
    
    EulerThetaRest = param.EulerThetaRest;
    EulerPhiRest = param.EulerPhiRest;
    EulerZetaRest = param.EulerZetaRest;
    
    num_whiskers = length(EulerThetaRest)/2; % get number of whiskers
    max_whiskers = num_whiskers * 2;

    % The whisker start at rest.
    % Azimuth span: -retr_degree~prot_degree
    
    rows = unique(param.row);
    nRow = zeros(max(rows), 1);
    for r = rows'
        nRow(r) = sum(param.row==r)/2;
    end
    % Elevation with azimuth
    dPhi = [0.398*ones(nRow(1),1);    %   A row:  0.398 +/- 0.005
            0.591*ones(nRow(2),1);    %   B row:  0.591 +/- 0.008
            0.578*ones(nRow(3),1);    %   C row:  0.578 +/- 0.000
            0.393*ones(nRow(4),1);    %   D row:  0.393 +/- 0.001
            0.217*ones(nRow(5),1)];   %   E row:  0.217 +/- 0.000
    
    % Torsion with azimuth
    dZeta = [-0.900*ones(nRow(1),1);   %   A row:  -0.900 +/- 0.026
            -0.284*ones(nRow(2),1);    %   B row:  -0.284 +/- 0.005
            0.243*ones(nRow(3),1);     %   C row:  0.243 +/- 0.000
            0.449*ones(nRow(4),1);     %   D row:  0.449 +/- 0.001
            0.744*ones(nRow(5),1)];    %   E row:  0.744 +/- 0.001
    
    %%  Compute whisk
    t = 0:dt_target:time_stop;
    nStep = length(t);
    prot_degrees = cos(2*pi*whisk_freq*t + pi)*(prot_degree+retr_degree)/2 ...
        + (prot_degree-retr_degree)/2; % sinusoidal trajectory
    EulerThetasList = zeros(num_whiskers, nStep);
    EulerPhisList = zeros(num_whiskers, nStep);
    EulerZetasList = zeros(num_whiskers, nStep);
    for i = 1:num_whiskers
        EulerThetasList(i, :) = EulerThetaRest(i)+prot_degrees;
        EulerPhisList(i, :) = EulerPhiRest(i)+prot_degrees*dPhi(i);
        EulerZetasList(i, :) = EulerZetaRest(i)+prot_degrees*dZeta(i);
    end
    
    %% Step 1: get orienation angles/matrix from each time step
    % create orientation matrix (both right and left)
    orientMat = cell(max_whiskers,nStep);
    for s = 1:nStep
        for i = 1:num_whiskers
            theta = EulerThetasList(i, s);
            phi = EulerPhisList(i, s);
            zeta = EulerZetasList(i, s);
            % Right
            orientMat{i, s} = rotz(theta, 'deg')*rotx(-phi, 'deg')*...
                              roty(-zeta, 'deg');
            % Left
            orientMat{i+num_whiskers, s} = rotz(-theta, 'deg')*rotx(-phi, 'deg')*...
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
            W{i, tt} = (orientMat{i, tt+1}-orientMat{i, tt-1})/2/dt_target*orientMat{i, tt}';
        end
    end
    % add first
    for i = 1:max_whiskers
        W{i, 1} = (orientMat{i, 2}-orientMat{i, 1})/dt_target*orientMat{i, 1}';
    end

    %% Step 3: convert tensor to vector
    % a_vel is a 62x(nStep*3) matrix with 31 whiskers on each side.
    % 1-5    6-11    12-18    19-25    26-31
    % A12345 B12345 C1234567 D1234567 E234567

    a_vel = cell2mat(cellfun(@tensor2vector, W, 'UniformOutput', false));
    csvwrite('../../data/whisker_param_model_rat/whisking_trajectory.csv', a_vel);

    %% Step 4: 
    a_loc = [EulerThetasList(:,1), EulerPhisList(:,1), EulerZetasList(:,1);...
             -EulerThetasList(:,1), EulerPhisList(:,1), -EulerZetasList(:,1)]*pi/180;
    csvwrite('../../data/whisker_param_model_rat/whisking_init_angle.csv', a_loc);
 
 end

function w = tensor2vector(W)
    w = zeros(1,3);
    w(1) = W(3,2);
    w(2) = W(1,3);
    w(3) = W(2,1);
end