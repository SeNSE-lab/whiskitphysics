function[Vprior,Vspikes,Vcond,Mprior,Mspikes,Mcond] = CreatePD2(var1,nbins1,var2,nbins2,spikevec,lag,minspikes);
%  [Vprior,Vspikes,Vcond,Mprior,Mspikes,Mcond] = CreatePD2(var1,nbins1,var2,nbins2,spikevec,lag,minspikes);
var1 = round(scale(var1,1,nbins1));
var2 = round(scale(var2,1,nbins2));

Mprior = zeros(max(var1),max(var2));
Mspikes = zeros(max(var1),max(var2));
Mcond = zeros(max(var1),max(var2));

Vprior = zeros(1,max(var1)*max(var2));
Vspikes = zeros(1,max(var1)*max(var2));
Vcond = zeros(1,max(var1)*max(var2));

for j = 1:length(var1)-lag
    Mprior(var1(j),var2(j)) = Mprior(var1(j),var2(j)) + 1;
    if spikevec(j+lag) ==1
        Mspikes(var1(j),var2(j)) = Mspikes(var1(j),var2(j)) + 1;
    end;
end;

counter = 0;
for j = 1:max(var1)
    for k = 1:max(var2)
        counter = counter + 1;
        Vprior(counter) = Mprior(j,k);
        if Mprior(j,k) < minspikes
            Mprior(j,k) = 0;
            Mspikes(j,k) = 0;
        end;
    end;
end;

counter = 0;
for j = 1:max(var1)
    for k = 1:max(var2)
        counter = counter + 1;
        Vspikes(counter) = Mspikes(j,k);
        Vcond(counter) = Mspikes(j,k);
        if Mspikes(j,k) ~= 0
            Mcond(j,k) = Mspikes(j,k)/Mprior(j,k);
            Vcond(counter) = Mcond(j,k);
        end;
    end;
end;

Mprior = Mprior'; Mcond = Mcond'; Mspikes = Mspikes';
Vprior(find(Vprior == 0)) = [];Vspikes(find(Vspikes == 0)) = [];Vcond(find(Vcond == 0)) = [];
 