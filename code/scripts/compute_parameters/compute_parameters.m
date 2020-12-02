%% function to generate the configuration data_avg of the rat whisker array. 
% =====================================================================
% INPUTS:
%   type = type of the model: 'average' or 'model'
%   pathout = directory to store data_avg
%   plotting = plot array if equal to 1
%
% OUTPUTS:
%  struct param with fields:
%       ID      = whisker identity
%       S       = arc length of the whisker
%       A       = curvature a (y = a*x^2)
%       x_bp    = base point x coordinate
%       y_bp    = base point y coordinate
%       z_bp    = base point z coordinate
%       EulerThetaRest   = angle of emergence about x axis
%       EulerPhiRest     = angle of emergence about y axis
%       EulerZetaRest    = angle of emergence about z axis
%       plt     = plot data_avg if available
%
%
% AUTHOR: Nadina Zweifel, 12/1/2020

function param = compute_parameters(type,pathout,plotting)

filename = 'new_ratmap_data.xlsx';
sheet = 'Average Rat';
[data_avg,txt] = xlsread(filename,sheet);

num_whiskers = length(data_avg(:,1)); % get number of whiskers
ID = txt(2:end,1); % get whisker labels

if(strcmp(type,'model'))
    
    % start column numbering at 0 instead of 1
    for i=1:length(ID)
        colnr = int8(str2double(ID{i,1}(end)))-1; 
        ID{i,1} = strrep(ID{i,1},ID{i,1}(end),int2str(colnr));
    end

    % compute model parameters
    [BPTheta,BPPhi,BPR] = compute_basepoints(ID);
    S = arc_length(BPTheta);
    A = curvature(BPTheta);
    [EulerThetaRest,EulerPhiRest,EulerZetaRest] = angle_of_emergence(BPTheta,BPPhi);
    color = 'r';
else
    
    % read average whisker data_avg
    S = data_avg(:,1);
    A = data_avg(:,2);
    EulerThetaRest = data_avg(:,3);
    EulerPhiRest = data_avg(:,4);
    EulerZetaRest = data_avg(:,5);
    BPR = data_avg(:,6);
    BPTheta = data_avg(:,7);
    BPPhi = data_avg(:,8);
    
    % start column numbering at 0 instead of 1
    for i=1:length(ID)
        colnr = int8(str2double(ID{i,1}(end)))-1; 
        ID{i,1} = strrep(ID{i,1},ID{i,1}(end),int2str(colnr));
    end
    color = 'b';
end

% convert spherical coordinates to cartesian
[x_bp,y_bp,z_bp] = sph2cart(BPTheta,BPPhi,BPR);

num_links = 20; % number of links per whisker

% inialize coordinate arrays (only for plotting)
RX = nan(num_whiskers,num_links);
RY = nan(num_whiskers,num_links);
RZ = nan(num_whiskers,num_links);
LX = nan(num_whiskers,num_links);
LY = nan(num_whiskers,num_links);
LZ = nan(num_whiskers,num_links);

Labels = cell(num_whiskers*2,1);
sideID = zeros(num_whiskers*2,1);
rowID = zeros(num_whiskers*2,1);
colID = zeros(num_whiskers*2,1);

for w = 1:length(ID)
    wn = ID{w};
    
    Labels{w,1} = ['R' wn];
    Labels{w+length(ID),1} = ['L' wn];
    
    sideID(w) = 1;
    
    switch wn(1)
        case 'A'
            rowID(w) = 1;
            rowID(w+length(ID)) = 1;
        case 'B'
            rowID(w) = 2;
            rowID(w+length(ID)) = 2;
        case 'C'
            rowID(w) = 3;
            rowID(w+length(ID)) = 3;
        case 'D'
            rowID(w) = 4;
            rowID(w+length(ID)) = 4;
        case 'E'
            rowID(w) = 5;
            rowID(w+length(ID)) = 5;
        otherwise
            disp('unvalid label');
    end
    
    colID(w) = str2num(wn(2));
    colID(w+length(ID)) = str2num(wn(2));
    
    dbase = compute_radius(S(w),wn);
        
    [x,y,z] = xyz_whisker(S(w),A(w),num_links);
    p = [x;y;z];
    
    Rx = rotMat(EulerZetaRest(w)*pi/180,[1 0 0]);
    Ry = rotMat(-EulerPhiRest(w)*pi/180,[0 1 0]);
    Rz = rotMat(EulerThetaRest(w)*pi/180-pi/2,[0 0 1]);
    
    xyz = [x_bp(w);y_bp(w);z_bp(w)] + Rz*Ry*Rx*p;    
    RX(w,:) = xyz(1,:);
    RY(w,:) = xyz(2,:);
    RZ(w,:) = xyz(3,:);
    LX(w,:) = -xyz(1,:);
    LY(w,:) = xyz(2,:);
    LZ(w,:) = xyz(3,:);
end
X = [RX;LX];
Y = [RY;LY];
Z = [RZ;LZ];

param.ID = Labels;
param.side = sideID;
param.row = rowID;
param.col = colID;
param.S=[S;S];
param.A = [A;A];
param.x_bp = [x_bp;-x_bp];
param.y_bp = [y_bp;y_bp];
param.z_bp = [z_bp;z_bp];
param.EulerThetaRest = [EulerThetaRest;-EulerThetaRest];
param.EulerPhiRest = [EulerPhiRest;EulerPhiRest];
param.EulerZetaRest = [EulerZetaRest;-EulerZetaRest];

% compute angles between links
ax = get_angles(param.S,param.A,num_links);
param.ax = ax;

% group data_avg
geom = [param.S param.A];
bp_coor = [param.x_bp param.y_bp param.z_bp];
bp_angles = [param.EulerThetaRest param.EulerPhiRest param.EulerZetaRest]*pi/180;
wpos = [param.side param.row param.col];

% save to file
if(~strcmp(pathout,''))
    fid = fopen([pathout 'param_name.csv'], 'w') ;
    fprintf(fid, '%s\n', Labels{:,1}) ;
    fclose(fid) ;
    csvwrite([pathout 'param_side_row_col.csv'],wpos)
    csvwrite([pathout 'param_s_a.csv'],geom)
    csvwrite([pathout 'param_bp_pos.csv'],bp_coor)
    csvwrite([pathout 'param_bp_angles.csv'],bp_angles)
    csvwrite([pathout 'param_angles.csv'],ax);
end

% plot whiskers
if plotting
    figure(1)
    subplot(121)
    for w = 1:size(X,1)
        plot3(X(w,:),Y(w,:),Z(w,:),color,'Linewidth',2); hold on;
    end
    axis equal;
    grid on;
    xlabel('x [mm]')
    ylabel('y [mm]')
    zlabel('z [mm]')

    subplot(122)
    plt=plot(X(1,:),Y(1,:),color,'Linewidth',2);hold on;
    plot(X(num_whiskers+1,:),Y(num_whiskers+1,:),color,'Linewidth',2),hold on
    axis equal;
    xlabel('x [mm]')
    ylabel('y [mm]')
    hold on;
    text(-10,10,Labels{1},'HorizontalAlignment','center');
    text(10,10,Labels{num_whiskers+1},'HorizontalAlignment','center');
    param.plt = plt;
end

end

function [x,y,z] = sph2cart(theta,phi,r)

x = cos(theta*pi/180).*r;
y = sin(theta*pi/180).*r;
z = sin(phi*pi/180).*r;

end

function [x,y,z] = xyz_whisker(S,A,num_links)

s = linspace(0,S,num_links);
x = zeros(1,length(s));
y = zeros(1,length(s));
z = zeros(1,length(s));
for j = 1:num_links
    x(j) = x_from_a_and_s(A,s(j));
    z(j) = -A*x(j)^2;
end
        
end

function x = x_from_a_and_s(a,s)

x = (-1.4 + 133.7*a +1.27*s - 4334*a^2 - 7.3*a*s - 0.01*s*2 + ...
            62930*a^3 + 72.2*a^2*s - 0.2*a*s^2 - 407600*a^4 - ...
            565.2*a^3*s + 1.6*a^2*s^2 + 966000*a^5 + 1706*a^4*s - ...
            4.8*a^3*s^2);
end

function R = rotMat(th,u)
    
    if(norm(u)~=1.)
        u = u/norm(u);
    end
    ux = u(1);
    uy = u(2);
    uz = u(3);
    
    R = [cos(th)+ux^2*(1-cos(th)) ux*uy*(1-cos(th))-uz*sin(th) ux*uz*(1-cos(th))+uy*sin(th);
        uy*uz*(1-cos(th))+uz*sin(th) cos(th)+uy^2*(1-cos(th)) uy*uz*(1-cos(th))-ux*sin(th);
        uz*ux*(1-cos(th))-uy*sin(th) uz*uy*(1-cos(th))+ux*sin(th) cos(th)+uz^2*(1-cos(th))
        ];

end

function [theta,phi,zeta] = protract(theta_new,ID)

dphi = [0.398 0.591 0.578 0.393 0.217];
dzeta = [-0.9 -0.284 0.243 0.449 0.744];

row_id = {'A','B','C','D','E'};
row_nr = {1,2,3,4,5};

ROW = containers.Map(row_id,row_nr);

phi = zeros(length(ID),1);
zeta = zeros(length(ID),1);
theta = ones(length(ID),1)*theta_new;

for i = 1:length(ID)
    w = ID{i}(1);
    idx = ROW(w);
    phi(i) = theta_new * dphi(idx);
    zeta(i) = theta_new * dzeta(idx);

end

end

function S = arc_length(BPTheta)

    S = exp(-0.0246*BPTheta+3.12);
    
end

function A = curvature(BPTheta)

    A = 0.000240*BPTheta + 0.0148;

end

function Amax = max_curvature(S)
    Amax = 0.0746*exp(-0.0506*S) + 0.00479;
end

function [th_w,phi_w,zeta_w] = angle_of_emergence(BPTheta,BPPhi)

    th_w = 0.598*BPTheta - 0.314*BPPhi + 67.4;
    phi_w = 1.04*BPPhi + 6.68;
    zeta_w = 0.876*BPTheta + 0.845*BPPhi + 37.9;
    
end

function tbp = get_BPTheta(c)
    tbp = (13.4*c-48.6);
end

function pbp = get_BPPhi(r)
    pbp = (1.49*r^2 -26.3*r+68.0);
end

function rbp = get_BPR(th,ph)
    rbp = 0.000511*th^2-0.0295*th-0.0162*ph+6.5;
end

function [BPTheta,BPPhi,BPR] = compute_basepoints(ID)

    num_links = max(size(ID));
    BPTheta = [];
    BPPhi = [];
    BPR = [];
    
    for i = 1:1:num_links
        wn = ID{i};
        switch wn(1)
            case 'A'
                r = 1;
            case 'B'
                r = 2;
            case 'C'
                r = 3;
            case 'D'
                r = 4;
            case 'E'
                r = 5;
            otherwise
                disp('unvalid label');
        end
        c = str2num(wn(2))+1;

        th = get_BPTheta(c);
        ph = get_BPPhi(r);
        BPTheta = [BPTheta; th];
        BPPhi = [BPPhi; ph];
        BPR = [BPR; get_BPR(th,ph)];
    end
    
end

function dbase = compute_radius(S,wn)
    switch wn(1)
        case 'A'
            r = 1;
        case 'B'
            r = 2;
        case 'C'
            r = 3;
        case 'D'
            r = 4;
        case 'E'
            r = 5;
        otherwise
            disp('unvalid label');
    end
    c = str2num(wn(2));
     
    dbase = 0.041 + 0.002*S + 0.011*r - 0.0039*c;
end


function all_angles = get_angles(s,a,numPts)
    
    all_angles = nan(length(s),numPts);
    for w = 1:length(s)
        [x,y] = acoeff2cart(a(w),s(w),numPts+1);
        angle = zeros(1,numPts);
        for l = 1:numPts
            dx = x(l+1) - x(l);
            dy = y(l+1) - y(l);

            if(l==1)
                angle(l) = 0;
            else
                angle(l) = atan2(dy,dx) - sum(angle(1:l-1));
            end
        end
        all_angles(w,1:numPts) = -angle;
    end
end