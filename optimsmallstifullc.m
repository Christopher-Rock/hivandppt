function [betam,betab,betaf,betas]=optimsmallstifullc(pop,N,pcf,prf,pcs,prs,pcb,prb,ac,ar,gm)
    pcm=pcf*N(3)*2+pcs*N(4)*2;
    prm=prf*N(3)*2+prs*N(4)*2;
    c1=N(1)*2;
    c2=pcf*N(3)*2/pcm;
    r2=prf*N(3)*2/prm;
    w=pop(1);
    x=pop(2);
    y=pop(3);
    z=pop(4);
    mc=c1*pop(3)+(1-c1)*pop(4);
    mr=mc;
    fc=c2*pop(1)+(1-c2)*pop(2);
    fr=r2*pop(1)+(1-r2)*pop(2);    
    f=@(beta) ...
        ((1-gm).*w+(1-w).*(1-(1-fc*(1-beta(1)^ac))^pcm*(1-fr*(1-beta(1)^ar))^prm)-w)^2 %+ ...
%          ((1-gm).*x+(1-x).*(1-fc*(1-beta(1)^ac))^pcm*(1-fr*(1-beta(1)^ar))^prm*...
%                    (1-pop(2)*(1-beta(2)^ac))^pcb*(1-pop(2)*(1-beta(2)^ar))^prb-x)^2 + ...
%          ((1-gm).*y+(1-y).*(1-mc*(1-beta(3)^ac))^pcf*(1-mr*(1-beta(3)^ar))^prf-y)^2 + ...
%         ((1-gm).*z+(1-z).*(1-mc*(1-beta(4)^ac))^pcs*(1-mr*(1-beta(4)^ar))^prs-z)^2;
    
    betain(1)=log((1-w-gm*w)/(1-w))/(c1*y+(1-c1)*z);
    betain(2)=log((1-x-gm*x)/(1-x)/exp(betain(1)*(c1*y+(1-c1)*z)))/x;
    betain(3)=log((1-y-gm*y)/(1-y))/(c2*w+(1-c2)*x);
    betain(4)=log((1-z-gm*z)/(1-z))/(c2*w+(1-c2)*x);    
betain=[0.005 0.005 0.005 0.005];       
    opts=optimoptions(@fminunc,'Algorithm','quasi-newton','Display','final-detailed','TolFun',1e-12,'TolX',1e-9);

    beta=fminunc(f,betain,opts); % suggested constant replacement for betain: [-0.6 -0.02 -1.2 -8]
    temp=num2cell(beta);
    [betam,betab,betaf,betas]=deal(temp{:});


    0;
