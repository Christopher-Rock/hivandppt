function [betam,betab,betaf,betas]=optimsmallsti(pop,c1,c2,gm)
    
    w=pop(1);
    x=pop(2);
    y=pop(3);
    z=pop(4);
    f=@(beta) ...
        ((1-gm).*w+(1-w).*(1-exp(beta(1).*c1*y+beta(1)*(1-c1)*z))-w)^2 + ...
        ((1-gm).*x+(1-x).*(1-exp(beta(1).*c1*y+beta(1)*(1-c1)*z+beta(2)*x))-x)^2 + ...
        ((1-gm).*y+(1-y).*(1-exp(beta(3)*c2*w+beta(3)*(1-c2)*x))-y)^2 + ...
        ((1-gm).*z+(1-z).*(1-exp(beta(4)*c2*w+beta(4)*(1-c2)*x))-z)^2;
    
    betain(1)=log((1-w-gm*w)/(1-w))/(c1*y+(1-c1)*z);
    betain(2)=log((1-x-gm*x)/(1-x)/exp(betain(1)*(c1*y+(1-c1)*z)))/x;
    betain(3)=log((1-y-gm*y)/(1-y))/(c2*w+(1-c2)*x);
    betain(4)=log((1-z-gm*z)/(1-z))/(c2*w+(1-c2)*x);    
       
    opts=optimoptions(@fminunc,'Algorithm','quasi-newton','Display','off','TolFun',1e-12,'TolX',1e-9);

    beta=fminunc(f,betain,opts); % suggested constant replacement for betain: [-0.6 -0.02 -1.2 -8]
    temp=num2cell(beta);
    [betam,betab,betaf,betas]=deal(temp{:});


    0;
