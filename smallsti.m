function [ratios,popint,rates,pop]=smallsti(rates,varargin)
%% Load input parameters
c1=rates.c1;
c2=rates.c2;
gamma=rates.gamma;
zeta=rates.zeta;
alphalr=rates.alphalr;
alphab=rates.alphab;
eff=rates.eff;
res=rates.res;
theta=rates.theta;
%% Create vector input parameters
if isfield(rates,'desc')
    desc=rates.desc;
else
    run=rates.run;
end
if rates.region==1
    chi=rates.chiu;
else
    chi=rates.chir;
end
equilib=[rates.w;rates.x;rates.y;rates.z];
N=[rates.sexratio*[1-rates.probb rates.probb] (1-rates.sexratio)*...
    [1-rates.probs rates.probs]]';
%% Set parameters
    % Populations m, f, s
    % At each time step,
    yintstart=10;
    yintlength=12;
    yobslength=2;
    steps=round(365/theta);
    intstart=yintstart*steps;
    intlength=yintlength*steps;
    obslength=yobslength*steps;
    tmax=intstart+intlength+obslength;
%% Adjust step-dependent parameters
    gamma=gamma/steps;
    zeta=zeta/steps;
%% Calculate beta values
    [betam,betab,betaf,betas]=optimsmallsti(equilib,c1,c2,gamma);
%% Prepare time-varying parameters
    deltalr=max(eff*(1-res*(0:1/steps:yintlength))*alphalr*zeta*chi,0);
    deltab=max(eff*(1-res*(0:1/steps:yintlength))*alphab*zeta*chi,0);
    deltas=max(eff*(1-res*(0:1/steps:yintlength))*zeta*chi,0);
%% Baseline variable
    pop=zeros(4,tmax+1);pop(:,1)=equilib;
%% Baseline loop
    for t=2:tmax+1
        pop(:,t)=smalltsti(pop(:,t-1),betam,betab,betaf,betas, ...
            c1,c2,gamma,0,0,0,0,0,0);
    end
%% Intervention variables
    popint=zeros(4,intlength+obslength+1);
    popint(:,1,1)=pop(1:4,intstart);
%% First step of intervention 
    popint(:,2)=smalltsti(popint(:,1),betam,betab,betaf,betas, ...
        c1,c2,gamma,deltalr(1),deltab(1),deltas(1),0,0,0);
%% Intervention loop
    for tint=3:intlength+1
        popint(:,tint,:)=smalltsti(popint(:,tint-1,:),betam,betab,betaf,betas, ...
            c1,c2,gamma,deltalr(tint-1),deltab(tint-1),deltas(tint-1), ...
            deltalr(tint-2),deltab(tint-2),deltas(tint-2));
    end
%% First step of post-inervention observation
    popint(:,intlength+2)=smalltsti(popint(:,tint-1),betam,betab,betaf,betas, ...
        c1,c2,gamma,0,0,0,deltalr(end),deltab(end),deltas(end));
%% Post-intervenion observation loop
    for tint=intlength+3:intlength+obslength+1
        popint(:,tint,:)=smalltsti(popint(:,tint-1,:),betam,betab,betaf,betas, ...
            c1,c2,gamma,0,0,0,0,0,0);
    end
%% Intervention output (commented)
%     popint=zeros(4,intlength+obslength+1);
%     popint(1:3,:)=popintout(1:3,:,1);
%     popint(4,:)=mean(popintout(5:end,:,1))*zeta+popintout(4,:,1)*(1-zeta);
%% Model output
    ratios=zeros(3,1);
    ratios(1)=popint(4,intlength)./pop(4,intstart+intlength);
    ratios(2)=sum(popint(:,intlength)./pop(:,intstart+intlength).*N);
    ratios(3)=popint(4,1+steps)/popint(4,1)./ ...
        (pop(4,intstart+steps)/pop(4,intstart));
    rates.steps=steps;
    rates.intlength=intlength;
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

