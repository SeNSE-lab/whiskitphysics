function [a,b,c,ds] = equidistlen3d(x,y,z,varargin)
%% function [a,b,ds] = equidistlen(x,y,z,{nNodes,TGL_plot})
% ---------------------------------------------------------------
% Resamples (x,y,z) using linear interpolation to make (x,y,z) points
% equidistant by a specified ds
% ---------------------------------------------------------------
% INPUTS:
%   x = x-coordinates
%   y = y-coordinates
%   varargin:
%       {1}: nodeLen - the length of each node
%       {2}: TGL_plot
% OUTPUTS:
%   a = x-coordinates of resampled (x,y,z) to nodeLen
%   b = y-coordinates of resampled (x,y,z) to nodeLen
%   c = z-coordinates of resampled (x,y,z) to nodeLen
%   ds = equidistant link length 
% ---------------------------------------------------------------
% NOTES:
%   + Requires: arclength.m
% ---------------------------------------------------------------
% Brian Quist 
% July 1, 2010 
% Matt Graff
% Jan 26, 2015

%% Setup
TGL_plot = 0;

%% Process inputs
nodeLen = 1;
if nargin >= 4, if ~isempty(varargin{1}), nodeLen = varargin{1}; end; end
if nargin >= 5, if ~isempty(varargin{2}), TGL_plot = varargin{2}; end; end

% Loop breaking
if TGL_plot < -1
    a = x; b = y; c=z; ds = nan; return
end

%% Parameterize the function
[s_total,s] = arclength3d(x,y,z);
s_inc = nodeLen;
s_target = 0:s_inc:s_total;
nNodes=length(s_target);

%% Interp ds
a = zeros(nNodes,1);
b = zeros(nNodes,1);
c= zeros(nNodes,1);
% -----
a(1) = x(1);
b(1) = y(1);
c(1) = z(1);
% -----
for ii = 2:length(s_target)
    if ii < length(s_target),
        id = find(s >= s_target(ii),1);
    else
        id = length(s);
    end
    if isempty(id), disp('ERROR: equidist!'); return; end
    % -----
    a(ii) = interp1(s(id-1:id),x(id-1:id),s_target(ii),'linear','extrap');
    b(ii) = interp1(s(id-1:id),y(id-1:id),s_target(ii),'linear','extrap');
    c(ii) = interp1(s(id-1:id),z(id-1:id),s_target(ii),'linear','extrap');
end

%% Run a second time to smooth out the fit
[a,b,c] = equidistlen3d(a,b,c,nodeLen,TGL_plot-1);

%% Output
[s_total,s,ds_total] = arclength3d(a,b,c); %#ok<ASGLU>
ds = ds_total(1);

%% Plot check
if TGL_plot > 0,
   figure; %#ok<UNRCH>
   subplot(1,2,1);
   plot3(x,y,z,'k.-'); hold on;
   plot3(a,b,c,'b.-','LineWidth',2); 
   subplot(1,2,2);
   stem(ds_total);
   text(0.05,0.98,['s-total: ',num2str(s_total)],'Units','normalized', ...
       'FontSize',9,'FontWeight','bold');
end