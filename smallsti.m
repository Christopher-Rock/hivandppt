function [ratios,pop,rates,popint]=smallsti(rates,varargin)
%% Load input parameters
N=[rates.Nm; rates.Nf; rates.Ns];
dm=rates.dm;
df=rates.ds;
ds=rates.ds;
mum=rates.mum;
muf=rates.muf;
mus=rates.mus;
betam=rates.betam;
betaf=rates.betaf;
betas=rates.betas;
c=rates.c;
gamma=rates.gamma;
zeta=rates.zeta;
eff=rates.eff;
res=rates.res;
att=rates.att;
per=rates.per;
eta=rates.eta;
dnative=rates.dnative;
%% Set parameters
    % Populations m, f, s
    % At each time step,
    yintstart=10;
    yintlength=10;
    yobslength=2;
    steps=12;
    intstart=yintstart*steps;
    intlength=yintlength*steps;
    obslength=yobslength*steps;
    tmax=intstart+intlength+obslength;
    numgroups=ceil(steps*per);
    if mod(steps*per,1)
        warning('steps*per is not an integer. \nTime between visits increased.') %#ok<WNTAG>
    end
%% Adjust time-varying parameters
    betam=betam/steps;
    betaf=betaf/steps;
    betas=betas/steps;
    gamma=gamma/steps;
%% Prepare for migration
    if dnative
        mum=0;muf=0;mus=0;
    end
%% Prepare time-varying parameters
    epsilon=min(1-(eff-res*(0:1/steps:yintlength))*att,1);
    prot=eta/365*steps;
%% Baseline variable
    pop=zeros(3,tmax+1);pop(:,1)=0.02;
%% Baseline loop
    for t=2:tmax+1
        pop(:,t)=smalltsti(pop(:,t-1),dm,df,ds, ...
            mum,muf,mus,betam,betaf,betas,c,gamma,0);
    end
%% Set internal migration HIV levels
    if dnative
        mum=rates.mum;muf=rates.muf;mus=rates.mus;
        dm=pop(1,intstart);df=pop(2,intstart);ds=pop(3,intstart);
    end
%% Intervention variables
    popintout=zeros(3+numgroups,intlength+obslength+1,2);
    popintout(1:2,1,1)=pop(1:2,intstart);
    popintout(3:end,1,1)=pop(3,intstart);
    g=0;
%% Intervention loop
    for tint=2:intlength+1
        popintout(:,tint,:)=smalltsti(popintout(:,tint-1,:),dm,df,ds, ...
            mum,muf,mus,betam,betaf,betas,c,gamma,zeta);
        if g>0
            popintout(3+g,tint,1)=mus*ds+(popintout(3+g,tint)-mus*ds)*...
                (epsilon(tint-1)+(1-epsilon(tint-1))*(1-prot));
            popintout(3+g,tint,2)=1-epsilon(tint-1);
        end
        g=mod(tint-2,numgroups)+1;
        popintout(3+g,tint)=popintout(3+g,tint)*epsilon(tint-1);% Or,itself times CoveragePerVisit, since not everyone will turn up each six months
        %Define g0,g1,... and set popintout(3+gk,tint)=popintout(3+gk,tint)/2 or similar   
        %Do something with changes in groups, migration, etc.
    end
%% Post-intervenion observation loop
    for tint=intlength+2:intlength+obslength+1
        popintout(:,tint)=smalltsti(popintout(:,tint-1),dm,df,ds, ...
            mum,muf,mus,betam,betaf,betas,c,gamma,zeta);
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
% %% Result modification
%     ratios=pop(:,end);
end
    