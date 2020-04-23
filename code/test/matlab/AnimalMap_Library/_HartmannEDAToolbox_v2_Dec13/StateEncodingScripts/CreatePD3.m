function[Vprior,Vspikes,Vcond,Mprior,Mspikes,Mcond] = CreatePD3(var1,nbins1,var2,nbins2,var3,nbins3,spikevec,lag,minspikes);
% [Vprior,Vspikes,Vcond,Mprior,Mspikes,Mcond] = CreatePD3(var1,nbins1,var2,nbins2,var3,nbins3,spikevec,lag,minspikes);
% load vk24Rec004.mat
% var1 = traj; var2 = trajdot; var3 = trajdotdot; nbins1 = 15; nbins2 = 20; nbins3 = 20; lag = 0; minspikes = 5;

var1 = round(scale(var1,1,nbins1));
var2 = round(scale(var2,1,nbins2));
var3 = round(scale(var3,1,nbins3));

Mprior = zeros(max(var1),max(var2), max(var3));
Mspikes = zeros(max(var1),max(var2),max(var3));
Mcond = zeros(max(var1),max(var2),max(var3));

Vprior = zeros(1,max(var1)*max(var2)*max(var3));
Vspikes = zeros(1,max(var1)*max(var2)*max(var3));
Vcond = zeros(1,max(var1)*max(var2)*max(var3));

for j = 1:length(var1)-lag
    Mprior(var1(j),var2(j),var3(j)) = Mprior(var1(j),var2(j),var3(j)) + 1;
    if spikevec(j+lag) ==1
        Mspikes(var1(j),var2(j),var3(j)) = Mspikes(var1(j),var2(j),var3(j)) + 1;
    end;
end;

counter = 0;
for i = 1:max(var1)
    for j = 1:max(var2)
        for k = 1:max(var3)
            counter = counter + 1;
            Vprior(counter) = Mprior(i,j,k);
            if Mprior(i,j,k) < minspikes
                Mprior(i,j,k) = 0;
                Mspikes(i,j,k) = 0;
            end;
        end;
    end;
end;

counter = 0;
for i = 1:max(var1)
    for j = 1:max(var2)
        for k = 1:max(var3)
            counter = counter + 1;
            Vspikes(counter) = Mspikes(i,j,k);
            if Mspikes(i,j,k) ~= 0
                Mcond(i,j,k) = Mspikes(i,j,k)/Mprior(i,j,k);
                Vcond(counter) = Mcond(i,j,k);
            end;
        end;
    end;
end;

a=find(Vprior==0);Vprior(a)=[];
a=find(Vspikes==0);Vspikes(a)=[];
a=find(Vcond==0);Vcond(a)=[];
