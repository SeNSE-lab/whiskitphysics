function void=trajectory(vec1,vec2,numpts,emode,speed);
% TRAJECTORY        animates the trajectory of vec1 vs. vec2.  
% 
% function void=trajectory(vec1,vec2,[numpts],[erasemode ('xor','none')],[speed (<1)]]); 
% default is numpts =3, erasemode 'none', speed = .05;
% MJH Fall 1997
%
% Hartmann EDA Toolbox v1, Dec 2004

dum=gcf; figure(dum); clf;

%% Be friendly to the user
if nargin<2
    disp('function [void]=trajectory(vec1,vec2,[numpts],[emode]);');
elseif nargin==2
    numpts=3; emode='none'; speed=0.05;
elseif nargin==3
    if isstr(numpts)    % user input emode instead of numpts or speed
        emode=numpts; numpts=3; speed=0.05;
    else                % user input numpts or speed and emode is yet undefined
        emode='none';
        if numpts<1 % user input speed instead of numpts
            speed=numpts; numpts=3;
        else % user really did input numpts
            speed = 0.05;
        end;
    end;
elseif nargin==4
    if isstr(numpts) % user input emode and speed, and numpts is as yet undefined
         speed=emode; emode=numpts; numpts=3;
    else % user input numpts and either emode and speed
        if isstr(emode)  % user input numpts and emode, but speed is yet undefined
            speed=0.05;
        else    % user input numpts and speed, but and emode is yet undefined
            speed=emode; emode='none';
        end;
    end;
end;

set(gcf,'BackingStore','off');
axis([min(vec1) max(vec1) min(vec2) max(vec2)]);
j=1:numpts; 
hold on;
nd= floor(length(vec1)/numpts); % there are nd segments of length
% numpts each in the run.
h=[]; oldh=[]; oldh2=[];
counter=0;
while j(1)<length(vec1)
    counter=counter+1;
    h=line(vec1(j),vec2(j),'Color','r','LineStyle','*','EraseMode',emode);
    drawnow;
    oldh2=oldh;oldh=h;
    if counter>=2, set(oldh2,'Color',[0 0 1],'LineStyle','-');end;
    j=j+numpts-1;
    if j(end)>length(vec1), j=j(1):length(vec1);end;
    if isempty(j), j=length(vec1); end;
    pause(speed);
end;

