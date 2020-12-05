clear all

%% Collecting information
data = load('RAT_cubic_all.mat');
whisker_num = length(data.AnimalNum);
minimap = containers.Map();

filename = 'new_ratmap_data.xlsx';
sheet = 'Average Rat';
[d_,txt] = xlsread(filename,sheet);

num_whiskers = length(d_(:,1)); % get number of whiskers
ID = txt(2:end,1); % get whisker labels

% for every whisker, put info into the container
for wh = 1:whisker_num
    this_name = data.Names(wh,3:end);
    
    % if the whisker never appeared in the container
    if data.quality(wh) == 1 && any(strcmp(ID,this_name([1 3])))
        if ~isKey(minimap, this_name)
            % add a new struct to the container
            first_struct.num = 1;
            first_struct.S2D = data.S2D(wh);
            first_struct.A2D = data.A2D(wh);
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
            this_struct.A2D = [this_struct.A2D; data.A2D(wh)];
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


k = keys(minimap)';

param = compute_parameters('average','',0);

EulerThetaRest = zeros(num_whiskers,1);
EulerPhiRest = zeros(num_whiskers,1);
EulerZetaRest = zeros(num_whiskers,1);

S = zeros(num_whiskers,1);
A = zeros(num_whiskers,1);
BPTheta = zeros(num_whiskers,1);
BPPhi = zeros(num_whiskers,1);
BPR = zeros(num_whiskers,1);

for i = 1:num_whiskers
    EulerThetaRest(i) = nanmean(minimap(k{i}).EulerTheta);
    EulerPhiRest(i) = nanmean(minimap(k{i}).EulerPhi);
    EulerZetaRest(i) = nanmean(minimap(k{i}).EulerZeta);
    
    S(i) = nanmean(minimap(k{i}).S2D);
    A(i) = nanmean(minimap(k{i}).A2D);
    
    BPTheta(i) = nanmean(minimap(k{i}).BPTheta);
    BPPhi(i) = nanmean(minimap(k{i}).BPPhi);
    BPR(i) = nanmean(minimap(k{i}).BPR);
end

