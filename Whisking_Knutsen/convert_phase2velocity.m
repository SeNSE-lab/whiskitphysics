
function convert_phase2velocity(whisk_freq,time_stop,max_whiskers,angle_file)
    
    %% Inputs
    % retraction:   retraction angle in degrees
    % protraction:  protraction angle in degrees 
    % whisk_freq:   whisking frequency in Hz
    % time_stop:    duration of simulation in seconds
    
    fps = 1000;
    dt = 1/fps;
    
    % Load look-up data ranging from ~70+[-retraction,protraction]
    data = load(angle_file);
    EulerThetaPhase = mean(data.EulerThetas);
    EulerThetaMin = min(EulerThetaPhase);
    EulerThetaMax = max(EulerThetaPhase);
    
    % generating sinusoidal whisking trajectory
    t = 0:dt:time_stop;
    phase = cos(2*pi*whisk_freq*t + pi)*(EulerThetaMax-EulerThetaMin)/2 ...
            + (EulerThetaMax+EulerThetaMin)/2;

    %% Step 1: get orienation angles/matrix from each time step
    EulerThetasList = interp1(EulerThetaPhase, data.EulerThetas', phase,'spline')';
    EulerPhisList = interp1(EulerThetaPhase, data.EulerPhis', phase,'spline')';
    EulerZetasList = interp1(EulerThetaPhase, data.EulerZetas', phase,'spline')';
    
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
    % %%%%%%%%%%%%%%%%pure testing%%%%%%%%%%%%%%%%%%%%%%%%
    % % I don't know why yet but it seems that adding an extra zero array up
    % % front will correct the offset between simulation and reference
    % % trajectory. It is possible that the simulation engine simply ignores the
    % % first angular velocity input.
    % a_vel = [zeros(62,3), a_vel];
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    writematrix(a_vel, sprintf('../code/data/whisking_trajectory_sample_R%d_P%d.csv',[retraction,protraction]), 'Delimiter', ',');

    %% Step 4: 
    a_loc = [EulerThetasList(:,1), EulerPhisList(:,1), EulerZetasList(:,1);...
             -EulerThetasList(:,1), EulerPhisList(:,1), -EulerZetasList(:,1)]*pi/180;
    writematrix(a_loc, sprintf('../code/data/whisking_init_angle_sample_R%d_P%d.csv',[retraction,protraction]), 'Delimiter', ',');

end

function w = tensor2vector(W)
    w = zeros(1,3);
    w(1) = W(3,2);
    w(2) = W(1,3);
    w(3) = W(2,1);
end




