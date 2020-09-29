% This script geneartes whisker angles in a whisking phase
% This sceipt also generates a look-up table based on averaged EulerTheta
% angles. ~70+[-60,60] = [10, 130]

clear; close all
data = load('RAT_cubic_all.mat');
%% Collecting information
whisker_num = length(data.AnimalNum);
minimap = containers.Map();
% for every whisker, put info into the container
for wh = 1:whisker_num
    this_name = data.Names(wh,3:end);
    % if the whisker never appeared in the container
    if data.quality(wh) == 1
        if ~isKey(minimap, this_name)
            % add a new struct to the container
            first_struct.num = 1;
            first_struct.S2D = data.S2D(wh);
            first_struct.S3D = data.S3D(wh);
            first_struct.K2D = data.K2D(wh);
            first_struct.BPTheta = data.BPTheta(wh);
            first_struct.BPPhi = data.BPPhi(wh);
            first_struct.BPR = data.BPR(wh);
            first_struct.EulerTheta = data.EulerTheta(wh);
            first_struct.EulerPhi = data.EulerPhi(wh);
            first_struct.EulerZeta = data.EulerZeta(wh);
            minimap(this_name) = first_struct;
        else % if the container has the whisker
            this_struct = minimap(this_name);
            % add new information to that struct
            this_struct.num = this_struct.num + 1;
            this_struct.S2D = [this_struct.S2D; data.S2D(wh)];
            this_struct.S3D = [this_struct.S2D; data.S3D(wh)];
            this_struct.K2D = [this_struct.K2D; data.K2D(wh)];
            this_struct.BPTheta = [this_struct.BPTheta; data.BPTheta(wh)];
            this_struct.BPPhi = [this_struct.BPPhi; data.BPPhi(wh)];
            this_struct.BPR = [this_struct.BPR; data.BPR(wh)];
            this_struct.EulerTheta = [this_struct.EulerTheta; data.EulerTheta(wh)];
            this_struct.EulerPhi = [this_struct.EulerPhi; data.EulerPhi(wh)];
            this_struct.EulerZeta = [this_struct.EulerZeta; data.EulerZeta(wh)];
            % add information to the struct
            minimap(this_name) = this_struct;
        end
    end
end

% The whisker start at rest.
% Azimuth span: -60~60
%
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
for i = 1:30
    EulerThetaRest = nanmean(minimap(k{i}).EulerTheta);
    EulerPhiRest = nanmean(minimap(k{i}).EulerPhi);
    EulerZetaRest = nanmean(minimap(k{i}).EulerZeta);
        
    EulerThetas(i, :) = linspace(EulerThetaRest-60, EulerThetaRest+60, timepoints);
    EulerPhis(i, :) = linspace(EulerPhiRest+60*dPhi(i), EulerPhiRest+60*dPhi(i), timepoints);
    EulerZetas(i, :) = linspace(EulerZetaRest-60*dZeta(i), EulerZetaRest+60*dZeta(i), timepoints);
end
save('angles_in_whisking_[-60,60]', 'EulerThetas','EulerPhis','EulerZetas');

%%
SAVE_VID = 0;
if SAVE_VID == 1
    figure('Color','w'); hold on;
    whiskers = data.WHPoints2Dfit(data.AnimalNum == 3);
    % for each time step
    for t = 1:timepoints
        % for every whisker
        for i = 1:30
            theta = nanmean(minimap(k{i}).BPTheta);
            phi = nanmean(minimap(k{i}).BPPhi);
            r = nanmean(minimap(k{i}).BPR);
            x = r*cosd(phi)*cosd(theta);
            y = r*cosd(phi)*sind(theta);
            z = r*sind(phi);
            plot3([x,-x], [y,y], [z,z], 'ko');
            hold on
            if ~isempty(whiskers{i})
                whiskerL = [zeros(1,100); -whiskers{i}];
                whiskerR = [zeros(1,100); -whiskers{30+i}];
                whiskerR = rotateWhisker(whiskerR, ...
                                         EulerThetas(i,t),...
                                         EulerPhis(i,t),...
                                         EulerZetas(i,t));
                whiskerL = mirrorX(rotateWhisker(whiskerL, ...
                                         EulerThetas(i,t),...
                                         EulerPhis(i,t),...
                                         EulerZetas(i,t)));

                plot3d(whiskerR+[x;y;z], 'k-');
                plot3d(whiskerL+[-x;y;z], 'k-');
            end
        end
        axis equal
        xlim([-50, 50]); ylim([-40, 20]); zlim([-40,40]);
        view(158, 38);
%         view(0, 0);
        drawnow
        mov(t) = getframe(gcf);
        hold off
    end
    axis equal

    v = VideoWriter('whisking');
    open(v);
    writeVideo(v, mov);
    close(v);
end



function wh_new = rotateWhisker(wh, theta, phi, zeta)
    wh_new = rotz(theta, 'deg')*...
             rotx(-phi, 'deg')*...
             roty(-zeta, 'deg')*wh;
end




