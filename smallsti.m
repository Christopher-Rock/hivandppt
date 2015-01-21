function [ratios,popwith,rates,pop,proportional,oldproportional]=smallsti(rates,varargin)
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
if any(strcmp(varargin,'pretty'))
    pretty=1;
else
    pretty=0;
end
stilevel=[rates.w;rates.x;rates.y;rates.z];
equilib=stilevel*rates.fracsyphilis;
otherlevel=(stilevel-equilib)./(1-equilib);
N=[rates.sexratio*[1-rates.probb rates.probb] (1-rates.sexratio)*...
    [1-rates.probs rates.probs]]';
%% Set parameters
    % Populations m, f, s
    % At each time step,
    yintstart=10;
    yintlength=12;
    yobslength=2;
    steps=round(365.25/theta);
    intstart=yintstart*steps;
    intlength=yintlength*steps;
    obslength=yobslength*steps;
    tmax=intstart+intlength+obslength;
%% Adjust step-dependent parameters
    gamma=gamma/steps;
    zeta=zeta/steps;
%% Calculate beta values
    [betam,betab,betaf,betas]=fastoptimsmallsti(equilib,c1,c2,gamma);
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
    popwith=bsxfun(@plus,popint,otherlevel)-bsxfun(@times,popint,otherlevel);
    proportional=sum(bsxfun(@times,popwith,N./stilevel));
    oldproportional=sum(N.*stilevel);
    ratios=zeros(2,1);
    ratios(1)=1-min(proportional);
    ratios(2)=find(round(proportional,12)<=round(min(proportional)+(1-min(proportional))/2,12),1)/steps;
    rates.steps=steps;
    rates.intlength=intlength;
%% Model plot
    plot ((0:intstart+intlength)/steps,pop(:,1:intstart+intlength+1)',(intstart:intstart+intlength)/steps,popint(:,1:intlength+1)')
    holdnow=ishold(gcf);  hold on;
%     plot(yintstart+yintlength*[1;1],[0 1],'k-')
    set(gca,'ColorOrderIndex',1)
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
%% Pretty output
    if pretty
        disp('STI levels')
        disp([equilib stilevel otherlevel])
        disp('phi')
        disp(fracsyphilis)
        disp('S equations')
        lambda=zeros(4,1);
        lambda(1)=1-exp(betas*c2*m+betas*(1-c2)*b);
        disp([  1-popint(4,2)-deltas
            popint(4,2)
            deltas
            lambda(1)
            deltas/(1-deltas)
            gamma*steps
            steps  ]);
        disp('Remember to set Delta_t as 1/steps!')
        disp('delta equations')
        disp([ zeta;tau;eff;res;chi])
        disp('Remember to set rho_t as res t\Delta_t!')
        disp('lambda equations')
        disp([popint(1,2);popint(2,2);c2;betas])
        disp('beta equations')
        lambda(2)=1-exp(betaf*c2*m+betaf*(1-c2)*b);
        lambda(3)=1-exp(betam*c1*f+betam*(1-c1)*s);
        lambda(4)=1-exp(betam*c1*f+betam*(1-c1)*s+betab*b);
        disp([equilib lambda [betas;betaf;betam;betab]])
    end
end

