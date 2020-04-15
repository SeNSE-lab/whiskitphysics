%  Hartmann EDA Toolbox v1, Dec 2004

fig1;clf;
i=0;

for plotnum=1:11
    
    
    subplot(3,4,plotnum)
    
    for j=0:.1:1
        for k=0:.1:1
            lowerleft=[j*10,k*10];
            upperright=[(j+.1)*10,(k+.1)*10];
            col=[i,j,k];
            rect(lowerleft,upperright,col);ho;
        end;        
    end;
    
    xlabel('j'); h=ylabel('k'); set(h,'Rotation',0); 
    axis('square'); axx(0,11);axy(0,11); 
    tempstring = ['i = ' num2str(i)];
    title(tempstring);
    i=i+0.1; 
    
    setxtick(0.5:2:11);
    setxlab([0,.2,.4,.6,.8,1]);
    setytick(0.5:2:11);
    setylab([0,.2,.4,.6,.8,1]);
    
end;