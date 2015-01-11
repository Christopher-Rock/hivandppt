function explorer
%% Set parameters
rates0=[0.064 0.09 0.185 0.1 0.8 0.8 0.4 0.2];
names={'b1' 'b2' 'b3' 'b4' 'c1' 'c2' 'c3' 'cvg'};
mods=[0.5 2];
modnames={'/2','*2'};
%% Calculate default
ratio0=smallsti(rates0);
%% Prepare figure
outfig=gcf;
clf;
xlabel('FSW effectiveness')
ylabel('Population-level effect')
zlabel('Delay of effect')
hold on;
tempfig=figure;
hold on;
colors={'b','g','r','c','m','y'};
%% Plot ratios for modified rates
for ii=1:8
    for jj=1:2
        rate=rates0;
        if mods(jj)<1
            rate(ii)=rate(ii).*mods(jj);
        else
            rate(ii)=1-(1-rate(ii))./mods(jj);
        end
        figure(tempfig);
        ratio=smallsti(rate);
        temp=[ratio0 ratio]';
        figure(outfig);
        plot3(temp(:,1),temp(:,2),temp(:,3),[colors{mod(ii-1,length(colors))+1} '-'])
        text(ratio(1),ratio(2),ratio(3),[names{ii} modnames{jj}])
    end
end