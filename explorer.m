function explorer(inputs,run) %#ok<INUSD>
%% Select row of inputs to use
    if nargin==1
        run=1;
    end        
%% Set parameters
mods=[0.5 2];
modnames={'/2','*2'};
%% Calculate default
[~,pop]=smallsti(getrates(inputs,1));
popend0=pop(:,end);
%% Prepare figure
outfig=gcf;
clf;
xlabel('FSW effectiveness')
ylabel('Population-level effect')
zlabel('Delay of effect')
xlabel('m');ylabel('f');zlabel('s');
hold on;
tempfig=figure;
hold on;
set(tempfig,'Visible','off')
colors={'b','g','r','c','m','y'};
%% Plot ratios for modified rates
for ii=1:size(inputs,2)
    for jj=1:2
        input=inputs;
        if mods(jj)<1||input{run+1,ii}>1
            input{run+1,ii}=input{run+1,ii}.*mods(jj);
        else
            input{run+1,ii}=1-(1-input{run+1,ii})./mods(jj);
        end
        figure(tempfig);
        [~,pop]=smallsti(getrates(input,run));
        popend=pop(:,end);
        temp=[popend0 popend]';
        figure(outfig);
        plot3(temp(:,1),temp(:,2),temp(:,3),[colors{mod(ii-1,length(colors))+1} '-'])
        text(temp(2,1),temp(2,2),temp(2,3),[input{1,ii} modnames{jj}])
    end
end
%% Protect explorer window; delete other window
set(gcf,'NextPlot','new')
close(tempfig)