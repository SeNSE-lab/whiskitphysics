function[cval] = SelectColor(col);

ColChoices = {...
    'ddred'    [0.5  0  0]
    'dred'     [0.8  0  0]
    'red'      [1 0 0]
    'lred'      [1, .4, .4]
    'llred'     [.9,.4,.2]
    'yellow'    [1,.8,0]
    'lorange'   [.9,.8,.6]
    'orange'    [1,.6,0]
    'dorange'   [1,.4,0]
    'lpink'     [1, .6, 1]
    'pink'     [1,0,1]
    'dpink'    [.9,0,1]
    'llpurple'   [.8,0,1]
    'lpurple'   [.7,.6,1]
    'purple'    [.7,.2,.8]
    'dpurple'   [.7,0,.6]
    'llblue'  [.3,1,1]
    'lblue'   [.2,.8,1]
    'blue'    [.3,.5,1]
    'dblue'   [.3,0,1]
    'ddblue'  [.2,0,.8] 
    'llgreen'  [.7,.8,.2]
    'lgreen'   [.3,1,0]
    'green'    [.3,.8,.2]
    'dgreen'   [0.2,.6,.3]
    'ddgreen'  [.1,.2,0]
    'black'  [0,0,0]};

a = find(strcmp(ColChoices(:,1),col));
if isempty(a)
    disp(['Your available color choices are: ']);
    for i = 1:length(ColChoices)
        disp(ColChoices{i});
    end;
    cval = [0,0,0];
else
    cval = ColChoices{a,2};
end;





















