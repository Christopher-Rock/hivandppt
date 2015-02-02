function [ratios,popwith,rates,prpl,popint,popintout,oldproportional]=smallsti(rates,varargin)
% SMALLSTI  Run simulation using structure imput
% First five arguments are used - DO NOT EDIT

%% Load input parameters
gamma=rates.gamma;
zeta=rates.zeta;
tau=rates.tau;
alphalr=rates.alphalr;
alphab=rates.alphab;
alphas=rates.alphas;
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
zetax=chi*zeta*[alphalr;alphab;alphalr;alphas];
stilevel=[rates.w;rates.x;rates.y;rates.z];
equilib=stilevel*rates.phi;
otherlevel=stilevel*rates.psi;
F=(rates.phi+rates.psi-1)/rates.phi/rates.psi./stilevel;
N=[rates.sexratio*[1-rates.probb rates.probb] (1-rates.sexratio)*...
    [1-rates.probs rates.probs]]';
c2=rates.probb;
asm=rates.probs*(rates.ac*rates.csm+rates.ar*rates.rsm)*N(3);
c1=1-asm/(asm+(1-rates.probs)*(rates.ac*rates.cfm+rates.ar*rates.rfm)*N(3));
%% Load varargin parameters
if any(strcmp(varargin,'pretty'))
    pretty=1;
else
    pretty=0;
end
if any(strcmp(varargin,'quick'))
    quickvalue=1;
    quickoutput=varargin{[false strcmp(varargin(1:end-1),'quick')]};
else
    quickvalue=0;
end
%% Set parameters
    % Populations m, f, s
    % At each time step,
    yintstart=2;
    yintlength=10;
    yobslength=0;
    steps=round(365.25/theta); steps=36;
    intstart=yintstart*steps;
    intlength=yintlength*steps;
    obslength=yobslength*steps;
    tmax=intstart+intlength+obslength;
%% Adjust step-dependent parameters
    gamma=gamma/steps;
    Theta=1-0.5^(365.25/steps/theta);%
%% Calculate beta values
    [betam,betab,betaf,betas]=fastoptimsmallsti(equilib,c1,c2,gamma);
%% Prepare time-varying parameters
    delta=max(eff*(1-res*(0:1/steps:yintlength))*tau/steps,0);
%% Baseline variable
    pop=zeros(4,tmax+1);pop(:,1)=equilib;
%% Baseline loop
    for t=2:tmax+1
        pop(:,t)=smalltsti(pop(:,t-1),betam,betab,betaf,betas, ...
            c1,c2,gamma,0,0);
    end
%% Intervention variables
    popintout=zeros(4,intlength+obslength+1,3);
    popintout(:,1,1)=pop(1:4,intstart);
    popintout(:,1,2)=pop(1:4,intstart);
%% Intervention loop
    for tint=2:intlength+1
        popintout(:,tint,:)=smalltsti(popintout(:,tint-1,:),betam,betab,betaf,betas, ...
            c1,c2,gamma,delta(tint-1),zetax,Theta);
    end
%% Post-intervenion observation loop
    for tint=intlength+2:intlength+obslength+1
        popintout(:,tint,:)=smalltsti(popintout(:,tint-1,:),betam,betab,betaf,betas, ...
            c1,c2,gamma,0,zetax,Theta);
    end
%% Intervention output
popint=bsxfun(@times,popintout(:,:,1),1-zetax)+bsxfun(@times,popintout(:,:,2),zetax);
%% Model output
    popwith=bsxfun(@plus,popint,otherlevel)-bsxfun(@times,popint,otherlevel.*F);
    proportional=sum(bsxfun(@times,popwith,N./stilevel));
    oldproportional=sum(N.*stilevel);
    ratios=zeros(2,1);
    ratios(1)=1-proportional(3*steps);
    ratios(2)=1-proportional(10*steps);
    prpl=proportional*sum(N.*equilib);
    rates.steps=steps;
    rates.intlength=intlength;
%% Model plot
    cc=parula(16);
    plot ((0:intstart+intlength)/steps,pop(:,1:intstart+intlength+1)')
    holdnow=ishold(gcf);  hold all;
    plot((intstart:intstart+intlength)/steps,popint(:,1:intlength+1)')%,'color',cc((1:8)+(rates.region-1)*8,:))

%     plot(yintstart+yintlength*[1;1],[0 1],'k-')
    if rates.region==1
        set(gca,'ColorOrderIndex',1)
    end
    if ~holdnow, hold off; end
    ylim([0 0.2]);legend([get(legend(gca),'String') {'m','b','f','s','m_{int}','b_{int}','f_{int}','s_{int}'}])
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
        disp([stilevel equilib otherlevel])
        disp('phi')
        disp(rates.phi)
        disp('S equations')
        lambda=zeros(4,1);
        pa=popint(:,2);
        m=pa(1,1,1);b=pa(2,1,1);f=pa(3,1,1);s=pa(4,1,1);
        lambda(1)=1-exp(betas*c2*m+betas*(1-c2)*b);
        disp([
            popint(4,2)
            delta(2)*zetax(4);
            lambda(1)
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
%% Quick value output
    if quickvalue
        ratios=eval(quickoutput);
    end
end

