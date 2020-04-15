function[void]=msd(vec);

% [void]=msd(vec);
% display mean, median, standard deviation, and mean + 1, 2, 3, and 4 times the std on the screen
% Hartmann EDA Toolbox v1, Dec 2004

d=mean(vec);
tempstring=['mean is ' num2str(d,3) ];disp(tempstring);

d=median(vec);
tempstring=['median is ' num2str(d,3) ];disp(tempstring);

d=std(vec);
tempstring=['std is ' num2str(d,3) ];disp(tempstring);

d=mean(vec)+std(vec);
tempstring=['mean plus 1 std is ' num2str(d,3) ];disp(tempstring);

d=mean(vec)+2*std(vec);
tempstring=['mean plus 2 std is ' num2str(d,3) ];disp(tempstring);

d=mean(vec)+3*std(vec);
tempstring=['mean plus 3 std is ' num2str(d,3) ];disp(tempstring);

d=mean(vec)+4*std(vec);
tempstring=['mean plus 4 std is ' num2str(d,3) ];disp(tempstring);


