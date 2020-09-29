
function convert_phase2velocity(whisk_freq,time_stop,max_whiskers,angle_file,tracking)
    
    %% Inputs
    % retraction:   retraction angle in degrees
    % protraction:  protraction angle in degrees 
    % whisk_freq:   whisking frequency in Hz
    % time_stop:    duration of simulation in seconds
    % tracking:     filename of tracking data (default: sinusoidal whisk)
    
    if nargin > 6
      tracking_file = tracking;
    else
      tracking_file = '';
    end
    

    fps = 1000;
    dt = 1/fps;
    nStep = time_stop * fps;
    steps_per_whisk = floor(fps / whisk_freq);
    num_cycles = ceil(time_stop * fps / steps_per_whisk);
    
    
    % Load look-up data ranging from ~70+[-retraction,protraction]
    data = load(angle_file);
    EulerThetaPhase = mean(data.EulerThetas);
    EulerThetaMin = min(EulerThetaPhase);
    EulerThetaMax = max(EulerThetaPhase);
    
    if(strcmp(tracking_file,''))
        t = 0:dt:(dt*steps_per_whisk);
        % generating sinusoidal whisking trajectory
        phase = cos(2*pi*whisk_freq*t + pi)*(EulerThetaMax-EulerThetaMin)/2 ...
                + (EulerThetaMax-EulerThetaMin)/2;
    else
        % loading tracking data
        phase = load(tracking);
        phase = phase.phase;
    end
    


    %% Step 1: get orienation angles/matrix from each time step
%     EulerThetaList = phase;
    EulerThetasList = repmat(interp1(EulerThetaPhase, data.EulerThetas', phase)',1,num_cycles);
    EulerPhisList = repmat(interp1(EulerThetaPhase, data.EulerPhis', phase)',1,num_cycles);
    EulerZetasList = repmat(interp1(EulerThetaPhase, data.EulerZetas', phase)',1,num_cycles);
    
%     EulerThetasList = repmat(data.EulerThetas,1,num_cycles);
%     EulerPhisList = repmat(data.EulerPhis,1,num_cycles);
%     EulerZetasList = repmat(data.EulerZetas,1,num_cycles);
    
    % create orientation matrix (both right and left)
    orientMat = cell(max_whiskers,nStep);
    for s = 1:nStep
        for i = 1:max_whiskers/2
            theta = EulerThetasList(i, s);
            phi = EulerPhisList(i, s);
            zeta = EulerZetasList(i, s);
            % Right
            orientMat{i, s} = rotz(theta, 'deg')*rotx(-phi, 'deg')*...
                              roty(-zeta, 'deg');
            % Left
            orientMat{i+max_whiskers/2, s} = rotz(-theta, 'deg')*rotx(-phi, 'deg')*...
                              roty(zeta, 'deg');
        end
        
%     % create orientation matrix (both right and left)
%     nStep = length(phase);
%     orientMat = cell(max_whiskers,nStep);
%     for s = 1:nStep
%         for i = 1:max_whiskers/2
%             theta = EulerThetasList(i, s);
%             phi = EulerPhisList(i, s);
%             zeta = EulerZetasList(i, s);
%             % Right
%             orientMat{i, s} = rotz(theta, 'deg')*rotx(-phi, 'deg')*...
%                               roty(-zeta, 'deg');
%             % Left
%             orientMat{i+max_whiskers/2, s} = rotz(-theta, 'deg')*rotx(-phi, 'deg')*...
%                               roty(zeta, 'deg');
%         end
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
    % a_vel is a max_whiskersx(nStep*3) matrix with max_whiskers/2 whiskers on each side.
    % 1-5    6-10    11-17    18-24    25-max_whiskers/2
    % A12345 B12345 C1234567 D1234567 E234567

    a_vel = cell2mat(cellfun(@tensor2vector, W, 'UniformOutput', false));
    % %%%%%%%%%%%%%%%%pure testing%%%%%%%%%%%%%%%%%%%%%%%%
    % % I don't know why yet but it seems that adding an extra zero array up
    % % front will correct the offset between simulation and reference
    % % trajectory. It is possible that the simulation engine simply ignores the
    % % first angular velocity input.
    % a_vel = [zeros(max_whiskers,3), a_vel];
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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




