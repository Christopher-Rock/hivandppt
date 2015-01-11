function [ratios,rates,popint,pop]=smallsti(rates,v,step,N)
%% Set parameters
    % Populations m, f, s
    % At each time step, 
    tmax=270;
    intstart=240;
    numgroups=1/step;
%% Baseline variable
    pop=zeros(3,tmax);pop(:,1)=0.02;
%% Baseline loop
    for t=2:tmax
        pop(:,t)=smallstiloop(pop(:,t-1),v,rates);
    end
%% Intervention variables
    popintout=zeros(3+numgroups,tmax-intstart+1);
    popintout(1:2,1)=pop(1:2,intstart);
    popintout(3:end,1)=pop(3,intstart);
%% Intervention loop
    for tint=2:tmax-intstart+1
        popintout(:,tint)=smalltsti(popintout(:,tint-1),v,rates);
        g=mod(tint-intstart-1,numgroups)+1;
        popintout(3+g,tint)=0;% Or,itself times CoveragePerVisit, since not everyone will turn up each six months
        %Do something with changes in groups, migration, etc.
    end
%% Intervention output
    popint=zeros(3,tmax-intstart+1);
    popint(1:2,:)=popintout(1:2,:);
    popint(3,:)=mean(popintout(4:end,:))*rates(5)+popintout(3,:)*(1-rates(5));
%% Model output
    ratios=zeros(3,1);
    ratios(1)=popint(3,end)./pop(3,end);
    ratios(2)=sum(popint(:,end)./pop(:,end).*N);
    ratios(3)=popint(3,end)/popint(3,floor((tmax-intstart)/10))./ ...
        (pop(3,end)/pop(3,intstart+floor((tmax-intstart)/10)));
%% Model plot
    plot (1:tmax,pop',intstart:tmax,popint')
    ylim(0:1);legend({'m','f','s','m_int','f_int','s_int'})
    curtail=@(x) x(1:length(x)-1);
    xlabel(['[' curtail(sprintf('%5.3f,',rates)) ']'])
    shg;
    
    
    % rates to_m to_f to_s recover coverage
%     rates=[0.1 0.1 0.2 0.05 .60];