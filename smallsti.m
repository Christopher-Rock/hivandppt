function [ratios,rates,popint,pop]=smallsti(rates,varargin)
%% Load input parameters
N=[rates.Nm; rates.Nf; rates.Ns];
steps=rates.steps;
dm=rates.dm;
df=rates.ds;
ds=rates.ds;
mum=rates.mum;
muf=rates.muf;
mus=rates.mus;
betamf=rates.betamf;
betams=rates.betams;
betafm=rates.betafm;
betasm=rates.betasm;
gamma=rates.gamma;
pm=rates.pm;
pf=rates.pf;
zeta=rates.zeta;
%% Set parameters
    % Populations m, f, s
    % At each time step, 
    yintstart=10;
    yintlength=2;
    yobslength=2;
    intstart=yintstart*steps;
    intlength=yintlength*steps;
    obslength=yobslength*steps;
    tmax=intstart+intlength+obslength;
    numgroups=1*steps;
%% Baseline variable
    pop=zeros(3,tmax+1);pop(:,1)=0.02;
%% Baseline loop
    for t=2:tmax+1
        pop(:,t)=smalltsti(pop(:,t-1),dm,df,ds, ...
            mum,muf,mus,betamf,betams,betafm,betasm,gamma,pm,pf,0);
    end
%% Intervention variables
    popintout=zeros(3+numgroups,intlength+obslength+1);
    popintout(1:2,1)=pop(1:2,intstart);
    popintout(3:end,1)=pop(3,intstart);
%% Intervention loop
    for tint=2:intlength+1
        popintout(:,tint)=smalltsti(popintout(:,tint-1),dm,df,ds, ...
            mum,muf,mus,betamf,betams,betafm,betasm,gamma,pm,pf,zeta);
        g=mod(tint-intstart-1,numgroups)+1;
        popintout(3+g,tint)=0;% Or,itself times CoveragePerVisit, since not everyone will turn up each six months
        %Define g0,g1,... and set popintout(3+gk,tint)=popintout(3+gk,tint)/2 or similar   
        %Do something with changes in groups, migration, etc.
    end
%% Post-intervenion observation loop
    for tint=intlength+2:intlength+obslength+1
        popintout(:,tint)=smalltsti(popintout(:,tint-1),dm,df,ds, ...
            mum,muf,mus,betamf,betams,betafm,betasm,gamma,pm,pf,zeta);
    end
%% Intervention output
    popint=zeros(3,intlength+obslength+1);
    popint(1:2,:)=popintout(1:2,:);
    popint(3,:)=mean(popintout(4:end,:))*zeta+popintout(3,:)*(1-zeta);
%% Model output
    ratios=zeros(3,1);
    ratios(1)=popint(3,end)./pop(3,end);
    ratios(2)=sum(popint(:,end)./pop(:,end).*N);
    ratios(3)=popint(3,end)/popint(3,1+floor((tmax-intstart)/10))./ ...
        (pop(3,end)/pop(3,intstart+floor((tmax-intstart)/10)));
%% Model plot
    plot ((0:tmax)/steps,pop',(intstart:tmax)/steps,popint')
    ylim([0 0.4]);legend({'m','f','s','m_{int}','f_{int}','s_{int}'})
    title(sprintf('Infection levels for trial %d',rates.run))
    xlabel('Years')
    set(gca,'YGrid','on')
    shg;
end
    
    
    % rates to_m to_f to_s recover coverage
%     rates=[0.1 0.1 0.2 0.05 .60];