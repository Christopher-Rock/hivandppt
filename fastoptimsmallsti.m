function [betam,betab,betaf,betas]=fastoptimsmallsti(pop,c1,c2,gm)
    
    w=pop(1);
    x=pop(2);
    y=pop(3);
    z=pop(4);
    beta=zeros(4,1);
    beta(1)=log((1-w-gm*w)/(1-w))/(c1*y+(1-c1)*z);
    beta(2)=log((1-x-gm*x)/(1-x)/exp(beta(1)*(c1*y+(1-c1)*z)))/x;
    beta(3)=log((1-y-gm*y)/(1-y))/(c2*w+(1-c2)*x);
    beta(4)=log((1-z-gm*z)/(1-z))/(c2*w+(1-c2)*x);    
    temp=num2cell(beta);
    [betam,betab,betaf,betas]=deal(temp{:});

