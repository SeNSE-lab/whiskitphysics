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
    
function generate_whisk_average_rat(retr_degree,prot_degree,whisk_freq,time_stop)

    fps = 1000;
    dt = 1/fps;
    
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

    param = compute_parameters('average','',0);
    
    EulerThetaRest = param.EulerThetaRest;
    EulerPhiRest = param.EulerPhiRest;
    EulerZetaRest = param.EulerZetaRest;
    
    num_whiskers = length(EulerThetaRest)/2; % get number of whiskers
    max_whiskers = num_whiskers * 2;

    % The whisker start at rest.
    % Azimuth span: -retr_degree~prot_degree
    
    timepoints = floor(fps / whisk_freq);
    
    EulerThetas = zeros(num_whiskers, timepoints);
    EulerPhis = zeros(num_whiskers, timepoints);
    EulerZetas = zeros(num_whiskers, timepoints);
    
    % Elevation with azimuth
    dPhi = [0.12*ones(5,1);     %   A row:  0.12 +/- 0.17
            0.3*ones(6,1);      %   B row:  0.num_whiskers +/- 0.17
            0.3*ones(7,1);      %   C row:  0.num_whiskers +/- 0.13
            0.14*ones(7,1);     %   D row:  0.14 +/- 0.14
            -0.02*ones(6,1)];   %   E row:  -0.02 +/- 0.13
    
    % Torsion with azimuth
    dZeta = [-0.75*ones(5,1);   %   A row:  -0.75
            -0.25*ones(6,1);    %   B row:  -0.25
            0.20*ones(7,1);     %   C row:  0.20
            0.40*ones(7,1);     %   D row:  0.40
            0.73*ones(6,1)];    %   E row:  0.73
    
    % for num_whiskers whiskers
    for i = 1:num_whiskers
        EulerThetas(i, :) = linspace(EulerThetaRest(i)-retr_degree, EulerThetaRest(i)+prot_degree, timepoints);
        EulerPhis(i, :) = linspace(EulerPhiRest(i)+retr_degree*dPhi(i), EulerPhiRest(i)+prot_degree*dPhi(i), timepoints);
        EulerZetas(i, :) = linspace(EulerZetaRest(i)-retr_degree*dZeta(i), EulerZetaRest(i)+prot_degree*dZeta(i), timepoints);
    end

    %%  Compute whisk
    % Load look-up data ranging from ~70+[-retr_degree,prot_degree]
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
    writematrix(a_vel, '../../data/whisker_param_average_rat/whisking_trajectory.csv', 'Delimiter', ',');

    %% Step 4: 
    a_loc = [EulerThetasList(:,1), EulerPhisList(:,1), EulerZetasList(:,1);...
             -EulerThetasList(:,1), EulerPhisList(:,1), -EulerZetasList(:,1)]*pi/180;
    writematrix(a_loc, '../../data/whisker_param_average_rat/whisking_init_angle.csv', 'Delimiter', ',');
    
    t = datestr(datetime('now'));
    logfile = 'whisk_average_log.txt';
    fid = fopen(logfile, 'a') ;
    fprintf(fid, '\nDate\t\tTime\t\tRetr. (deg)\t\tProtr. (deg)\tFreq. (Hz)\tDuration(s)\n');
    fprintf(fid, '%s\t%.3f\t\t\t%.3f\t\t\t%.3f\t\t%.3f\n', t,retr_degree,prot_degree,whisk_freq,time_stop) ;
    fclose(fid) ;
 
 end

function w = tensor2vector(W)
    w = zeros(1,3);
    w(1) = W(3,2);
    w(2) = W(1,3);
    w(3) = W(2,1);
end
