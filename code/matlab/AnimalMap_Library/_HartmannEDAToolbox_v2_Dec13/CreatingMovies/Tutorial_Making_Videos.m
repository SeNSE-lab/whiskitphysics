% Tutorial_Making_Videos
% A few lines of code you'll need to make awesome avi videos in MATLAB
% (Unless you're on a Mac, in which case, I don't know how to help you;
% MATLAB on Mac will spit out skewed videos.)
% Otherwise, just copy paste these lines of code in the appropriate places.

%% Regular Video Creation

% First, I make a flag that toggles whether or not you want to create a
% video because sometimes you want to run the code without saving the
% video.  All other video statements after this are contained in "if"
% statements.
vidflag = 1;

% Then you have to open the animation in MATLAB, name your video, and
% select a video compressor.  I chose this one because it gave a nice
% output; you'll want to use other software to compress the video more
% afterwards, though.
if vidflag
    anim = VideoWriter('My_Video_Name','Motion JPEG AVI');
    open(anim);
end

% Now you create your figure and size it how you want.
vid = figure;
set(vid,'Position',[left bottom width height],'color','w')

% Here you'll do some video setup, including something like finding the
% number of frames (say nframes)

% Loop through those frames
% I included the pause statement so that before I'm ready to write the
% video, I can click through it frame by frame to check for errors.
for ii = 1:nframes
    % More video setup here
    
    if vidflag
        frame = getframe(vid);
        writeVideo(anim,frame);
    else
        pause
    end
end

% IMPORTANT - Close the animation
% If you're writing the video and you error out, you still need to manually
% run this line or MATLAB will leave the animation open, and the next time
% you try running the video you may have problems.
if vidflag, close(anim); end

%% Other Tips and Troubleshooting

%% Rendering Error
% If the video is complex, sometimes the video you get out will be a weird
% combimation of a screenshot of your computer and the first frame of your
% film, not moving.
% I did some poking and found this solution worked for me.  Run this line
% right after creating your figure.
opengl('software')

%% Anti-Aliasing Software
% Looking closely, MATLAB draws diagonal lines as really fine staircases.
% If you don't want this in a particularly nice video, you can get code
% from the MATLAB Central File Exchange called "myaa" by Anders Brun that
% smooths out every frame of your video.
% I handled it by replacing the lines:
% frame = getframe(vid);
% writeVideo(anim,frame);
% with:
avid = myaa;
frame = getframe(avid);
writeVideo(anim,frame);
close(avid)

% Caveat: this slows down video production a LOT, so you probably don't
% want to use it all the time.  I put mine in a separate if statement with
% a flag saying if I want to do this or not.

%% Rotating in 3D
% If you want to rotate your figure in 3D for your video, there are a few
% things you need to do.
% 1) Rotate the figure in each frame using view(az,el); az for azimuth and
% el for elevation.  I'll have a line in the "for" statement looking like:
view(az(ii),el(ii))
% 2) Set your axes limits!  Otherwise, MATLAB will be constantly adjusting
% these
xlim([xmin xmax])
ylim([ymin ymax])
zlim([zmin zmax])
% 3) The magic line: A MATLAB command specifically for this case to prevent
% MATLAB from readjusting your axes at every view.
% This might also be fixed by "axes square", but that doesn't apply in
% every case.
% This line only needs to be run once for the figure.
axis vis3d