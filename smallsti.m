function [ratios,popwith,rates,prpl,popint,popintout,oldproportional]=smallsti(rates,varargin)
% SMALLSTI  Run simulation using structure imput
% First five arguments are used - DO NOT EDIT
% Outputs are USTI levels after combining UBSTIs and UVSTIs

%% Load input parameters
gamma=rates.gamma;
zeta=rates.zeta;
tau=rates.tau;
alpham=rates.alpham;
alphaf=rates.alphaf;
alphab=rates.alphab;
alphas=rates.alphas;
eff=rates.eff;
res=rates.res;
theta=rates.theta;
%% Evaluate implementational arguments
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
if isfield(rates,'probbmod')
    rates.probb=rates.probb*rates.probbmod;
    rates.probs=rates.probs*rates.probsmod;
end
if any(strcmp(desc,{'default','zeros'}))
    fors=1;
else
    fors=0;
end
%% Calculate intermediate variables
zetax=chi*zeta*[alpham;alphab;alphaf;alphas];
stilevelin=[rates.w;rates.x;rates.y;rates.z];
[equilib,otherlevel,stilevel]=splitsti(stilevelin,[rates.phi,rates.oldphi,rates.psifrac]);
N=[rates.sexratio*[1-rates.probb rates.probb] (1-rates.sexratio)*...
    [1-rates.probs rates.probs]]';
c2=1-rates.probb;
asm=rates.probs*(rates.ac*rates.csm+rates.ar*rates.rsm);
c1=1-asm/(asm+(1-rates.probs)*(rates.ac*rates.cfm+rates.ar*rates.rfm));
c1=1-(1-c1)*rates.c1frac;
c2=1-(1-c2)*rates.c2frac;
%% Load varargin parameters
if any(strcmp(varargin,'pretty'))
    pretty=1;
else
    pretty=0;
end
if any(strcmp(varargin,'quick'))
    quick=1;
    quickoutput=varargin{[false strcmp(varargin(1:end-1),'quick')]};
else
    quick=0;
end
if any(strcmp(varargin,'il'))
    useril=1;
    yintlength=varargin{[false strcmp(varargin(1:end-1),'il')]};
else
    useril=0;
end
%% Set time step parameters
    % Populations m, f, s
    % At each time step,
    yintstart=2;
    if ~useril
        yintlength=10;
    end
    yobslength=0;
    steps=round(365.25/theta); steps=120;
    intstart=yintstart*steps;
    intlength=yintlength*steps;
    obslength=yobslength*steps;
    tmax=intstart+intlength+obslength;
    for ii={ 
            },if(mod(now*24*60,1)*60<0.5), disp(ii);end;end
%% Adjust step-dependent parameters
    gamma=gamma/steps;
    Theta=1-0.5^(365.25/steps/theta);%
%% Calculate beta values
    [betam,betab,betaf,betas]=fastoptimsmallsti(equilib,c1,c2,gamma);
%% Prepare time-varying parameters
    delta=min(max(eff*(1-res*(0:1/steps:yintlength))*tau/steps,0),1);
    if tau/steps>1,
        warning('tau/steps=%4.2f',tau/steps), end %#ok<WNTAG>
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
%     popintout(:,1,2)=pop(1:4,intstart).*(1-zetax./rates.zeta*eff);
%     'HO HO HO'
%% Intervention loop
    for tint=2:intlength+1
        popintout(:,tint,:)=smalltsti(popintout(:,tint-1,:),betam,betab,betaf,betas, ...
            c1,c2,gamma,delta(tint-1),zetax,Theta);
%         if(0)
%             if fors %#ok<UNRCH> scenarios 'l' 'o'
%                 popintout(4,tint,1:2)=(1-eff)*equilib(4);
%                 if tint==1,'abuse of eff',end
%             else
%                 popintout(2,tint,1:2)=(1-eff)*equilib(2);
%                 if tint==1,'abuse of eff',end
%             end
%         end
%         if tint/steps>=.1&(tint-1)/steps<.1&0
%             if fors
%                 popintout([1 2 3 ],tint,1)=equilib([1 2 3 ]);
% %                 popintout(4,tint,1:2)=equilib(4);
%                 delta=delta*0;
%                 'Intervention loop effect'
%             else
%                 popintout(4,tint,1:2)=equilib(4);
%                 popintout([1 3],tint,1)=equilib([1 3]);
% %                 popintout(2,tint,1:2)=equilib(2);
%                 delta=delta*0;
%                   'Intervention loop effect'
%             end
%         end
    end
%% Post-intervenion observation loop
    for tint=intlength+2:intlength+obslength+1
        popintout(:,tint,:)=smalltsti(popintout(:,tint-1,:),betam,betab,betaf,betas, ...
            c1,c2,gamma,0,zetax,Theta);
    end
%% Intervention output
popint=bsxfun(@times,popintout(:,:,1),1-zetax)+bsxfun(@times,popintout(:,:,2),zetax);
totint=sum(bsxfun(@times,popint,N),1);
%% Model output
    popwith=joinsti(popint,otherlevel);
    proportional=sum(bsxfun(@times,popwith,N./stilevel));
    proptargeted=sum(bsxfun(@times,popint,N./equilib));
    oldproportional=sum(N.*stilevel);
    ratios=zeros(2,1);
    ratios(1)=1-proptargeted(intlength);
    ratios(2)=1-proportional(intlength);
    prpl=proportional*sum(N.*equilib);
    rates.steps=steps;
    rates.intstart=intstart;
    rates.intlength=intlength;
%% Model plot
if(2)
    cc=parula(16);
    plot ((0:intstart+intlength)/steps,pop(:,1:intstart+intlength+1)')
    holdnow=ishold(gcf);  hold all;
    set(gca,'ColorOrderIndex',1)
    plot((intstart:intstart+intlength)/steps,[popintout(:,1:intlength+1,1)' popintout(4,1:intlength+1,2)'])%,'color',cc((1:8)+(rates.region-1)*8,:))
%     plot((0:intstart+intlength)/steps,totint([ones(1,intstart) 1:end]),'k-')
%     plot(yintstart+yintlength*[1;1],[0 1],'k-')
    if rates.region==1
        set(gca,'ColorOrderIndex',1)
    end
    if ~holdnow, hold off; end
    ylim([0 0.2]);legend([get(legend(gca),'String') {'m','b','f','s','m_{int}','b_{int}','f_{int}','s_{int}','t'}])
    if isfield(rates,'desc')
        title(['Infection levels for trial: ' desc])
    else
        title(sprintf('Infection levels for trial %d',run))
    end
    xlabel('Years')
    set(gca,'YGrid','on')
    shg;
    oldfig=get(gcf,'Number');
    try
        figure(oldfig-1+2*(oldfig==1))
    catch
        figure
    end
    if ~fors
        set(gca,'LineStyleOrder','--')
        set(gca,'ColorOrderIndex',1)
    else
        set(gca,'LineStyleOrder',':')
        set(gca,'ColorOrderIndex',1)
    end
    hold all
    plot((intstart:intstart+intlength)/steps,1-popint(:,1:intlength+1)'./pop(:,intstart:intstart+intlength)')
    % thisdiff=sum(bsxfun(@times,1-popint(:,1:intlength+1)'./pop(:,intstart:intstart+intlength)',N'),2);
    if fors
        thisprop=sum(bsxfun(@times,1-popint(1:3,1:intlength+1)'./pop(1:3,intstart:intstart+intlength)',N(1:3)'),2);
    else
        thisprop=sum(bsxfun(@times,1-popint([1 3 4],1:intlength+1)'./pop([1 3 4],intstart:intstart+intlength)',N([1 3 4])'),2);
    end
    plot((intstart:intstart+intlength)/steps,thisprop)
    legend({'m','b','f','s','T'})
    try
        figure(oldfig);
    end
end
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
    if quick
        ratios=eval(quickoutput);
    end
end

