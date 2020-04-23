function final_figure(handle,ht,wd,x_label,y_label,box)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Chris Schroeder-- adapted from Brian Quist
%Version 1.0 (2/15/2012)
%
% final_figure(handle,ht,wd,x_label,y_label,box)
%
%This function formats a final figure in standard paper format.
%
% INPUTS
%     handle = figure handle
%     ht = desired height of the figure (in cm)
%     wd = desired width of the figure (in cm)
%     x_label = x axis label (input as string)
%     y_label = y axis label (input as string)
%     box = 'on' or 'off' depending on whether you want to plot axes boxes
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ht = ht/2.54; %cm --> inches
wd = wd/2.54; %cm --> inches
set(handle,'Units','inches','Position',[1 1 wd ht],'PaperPosition',[1 1 wd ht],'Color','w');
clear ht wd

%% Format axis
axsz = 7;%8;
axft = 'arial';
set(gca,'FontSize',axsz,'FontName',axft,'Box',box);

xlabel(x_label,'FontSize',8);
ylabel(y_label,'FontSize',8);

% xlabel(x_label,'FontSize',10);
% ylabel(y_label,'FontSize',10);

