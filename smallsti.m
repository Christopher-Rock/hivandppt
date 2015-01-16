function [ratios,pop,rates,popint]=smallsti(rates,varargin)
%% Load input parameters
c1=rates.c1;
c2=rates.c2;
gamma=rates.gamma;
zeta=rates.zeta;
eff=rates.eff;
res=rates.res;
att=rates.att;
per=rates.per;
theta=rates.theta;
%% Create vector input parameters
if isfield(rates,'desc')
    desc=rates.desc;
else
    run=rates.run;
end
equilib=[rates.w;rates.x;rates.y;rates.z];
N=[rates.sexratio*[1-rates.probb rates.probb] (1-rates.sexratio)*...
    [1-rates.probs rates.probs]]';
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
%% Calculate beta values
    [betam,betab,betaf,betas]=optimsmallsti(equilib,c1,c2,gamma);
%% Adjust step-dependent parameters
    betam=betam/steps;
    betaf=betaf/steps;
    betas=betas/steps;
    betab=betab/steps;
    gamma=gamma/steps;
    theta=min(1,theta/365*steps);
%% Prepare time-varying parameters
    delta=max((eff-res*(0:1/steps:yintlength))*att,0);
%% Baseline variable
    pop=zeros(4,tmax+1);pop(:,1)=equilib;
%% Baseline loop
    for t=2:tmax+1
        pop(:,t)=smalltsti(pop(:,t-1),betam,betab,betaf,betas,c1,c2,gamma,0);
    end
%% Intervention variables
    popintout=zeros(4+numgroups,intlength+obslength+1,2);
    popintout(1:3,1,1)=pop(1:3,intstart);
    popintout(4:end,1,1)=pop(4,intstart);
%% Intervention loop
    for tint=2:intlength+1
        popintout(:,tint,:)=smalltsti(popintout(:,tint-1,:),betam,betab,betaf,betas,c1,c2,gamma,zeta,theta);
        g=mod(tint-2,numgroups)+1;
        popintout(4+g,tint,1)=popintout(4+g,tint,1)*(1-delta(tint-1));
        popintout(4+g,tint,2)=delta(tint-1);
        %Do something with changes in groups, migration, etc.
    end
%% Post-intervenion observation loop
    for tint=intlength+2:intlength+obslength+1
        popintout(:,tint,:)=smalltsti(popintout(:,tint-1,:),betam,betab,betaf,betas,c1,c2,gamma,zeta,theta);
    end
%% Intervention output
    popint=zeros(4,intlength+obslength+1);
    popint(1:3,:)=popintout(1:3,:,1);
    popint(4,:)=mean(popintout(5:end,:,1))*zeta+popintout(4,:,1)*(1-zeta);
%% Model output
    ratios=zeros(3,1);
    ratios(1)=popint(4,intlength)./pop(4,intstart+intlength);
    ratios(2)=sum(popint(:,intlength)./pop(:,intstart+intlength).*N);
    ratios(3)=popint(4,1+steps)/popint(4,1)./ ...
        (pop(4,intstart+steps)/pop(4,intstart));
%% Model plot
    plot ((0:tmax)/steps,pop',(intstart:tmax)/steps,popint')
    holdnow=ishold(gcf);  hold on;
    plot(yintstart+yintlength*[1;1],[0 1],'k-')
    if ~holdnow, hold off; end
    ylim([0 0.4]);legend({'m','b','f','s','m_{int}','b_{int}','f_{int}','s_{int}'})
    if isfield(rates,'desc')
        title(['Infection levels for trial: ' desc])
    else
        title(sprintf('Infection levels for trial %d',run))
    end
    xlabel('Years')
    set(gca,'YGrid','on')
    shg;
% %% Result modification
%     ratios=pop(:,end);
end
    
