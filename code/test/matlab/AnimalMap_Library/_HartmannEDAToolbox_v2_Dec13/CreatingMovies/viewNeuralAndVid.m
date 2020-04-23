function viewNeuralAndVid(varargin);
% viewNeuralAndVid(dataTrace, v, startFrame, endFrame,[samplerate], [framerate]); will ask
% Assumes the neural trace is synced to the given frame numbers.  
%
% Eventually will want to add the  ability to plot 2 videos and neural at the same time. May want to add
% spike time indicator too. Default sampling and frame rates are 40000 and
% 300 respectively

% Nick Bush 12/19/13
%

dataTrace=varargin{1};
v=varargin{2};
startFrame=varargin{3};
endFrame=varargin{4};
sr=40000;
fr=300;
n=400;


if length(varargin)>=5
    n=varargin{5};
end
if length(varargin)>=6
    sr=varargin{5};
end
if length(varargin)==7
    fr=varargin{6};
end



if length(varargin)>7
    error('Too many input arguments');
end




h1=subplot(3,1,1);

xL1=1;
xL2=n*(sr/fr);

plot(neuralData);
h2=subplot(312);

hold on
yL=[min(neuralData(1:ceil(xL2))) max(neuralData(1:ceil(xL2)))];
plot(neuralData);
axx(xL1,xL2);
axy(yL(1),yL(2));

hold on
if isobject(v)
    for i=startFrame:endFrame
        if mod(i-startFrame+1,n)==0
            xL1=xL1+n*(sr/fr);
            xL2=xL2+n*(sr/fr);
        end
        yL=[min(neuralData(ceil(xL1):ceil(xL2))) max(neuralData(ceil(xL1):ceil(xL2)))];
        axy(yL(1),yL(2));
        axx(xL1,xL2);
        
        iter=iter+(sr/fr);
        frame=read(v1,i);
        frame=frame(:,:,1);
        %frame=histeq(frame);
        colormap('gray');
        h3=subplot(3,1,3);
        imagesc(frame);
        
        subplot(h1);
        vline(iter);
        subplot(h2);
        vline(iter);
        
        pause(.1);
        
        subplot(h1)
        rm(1);
        subplot(h2)
        rm(1);
        
    end
    
elseif isstruct(v)
    
    for i=startFrame:endFrame
        if mod(i-startFrame+1,n)==0
            xL1=xL1+n*(sr/fr);
            xL2=xL2+n*(sr/fr);
        end
        axx(xL1,xL2);
        
        
        iter=iter+(sr/fr);
        out = sr.seek(i);
        frame=v1.getframe();
        frame=frame(:,:,1);
        colormap('gray');
        frame=histeq(frame);
        h3=subplot(313);
        imagesc(frame)
        subplot(h1);
        vline(iter);
        subplot(h2);
        vline(iter);
        
        pause(.1);
        
        subplot(h1)
        rm(1);
        subplot(h2)
        rm(1);
    end
else
    disp('video not supported')
end