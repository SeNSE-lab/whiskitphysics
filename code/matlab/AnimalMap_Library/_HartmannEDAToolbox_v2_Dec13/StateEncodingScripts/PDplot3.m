function[V]=PDplot3(M,V,cmap,cdiv);
% function[V]=PDplot3(M,V,cmap = 0 or 1,cdiv = [percentdivisions]);

if cmap ==1
    cmap=colormap('jet');
%     cmap = cmap([1,20,40,50,64],:);
    cmap = cmap([3,20,40,50,55],:);
else
    for i = 1:5
        cmap(i,1:3) =[0,0,0];
    end;
end;
    
V=M(:);
[V,sf]= scale(V,0,1);
% dum = gcf;
% figure(20);hist(V);
% figure(dum);

[a,b,c]=size(M);
% test = M*sf;
% dum = gcf;
% figure(20);clf;hist(test(:));
% figure(dum);

counter = 0;
for i = 1:a
    for j = 1:b
        for k = 1:c
            if M(i,j,k) > 0
                h=plot3(i,j,k,'k*');ho;
                counter = counter + 1;
                Mval = M(i,j,k)*sf; lala(counter) = Mval;
                if Mval>0 & Mval<=cdiv(1)
                    colorval = cmap(1,:);
                elseif Mval>cdiv(1) & Mval<=cdiv(2)
                    colorval = cmap(2,:);
                elseif Mval>cdiv(2) & Mval<=cdiv(3)
                    colorval = cmap(3,:);
                elseif Mval>cdiv(3) & Mval<=cdiv(4)
                    colorval = cmap(4,:);
                elseif Mval>cdiv(4)
                    colorval = cmap(5,:);
                end
                set(h,'color',colorval);ln6;
            end;
        end;
    end;
end;