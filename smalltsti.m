function pop=smalltsti(pa,betam,betab,betaf,betas,c1,c2,gamma,deltalrnew,deltabnew,deltasnew,deltalrold,deltabold,deltasold)
    m=pa(1,1,1);b=pa(2,1,1);f=pa(3,1,1);s=pa(4,1,1);
    pop=zeros(size(pa));
    pop(1,1,1)=m*(1-gamma-deltalrnew)+((1-m-deltalrold)*(1-deltalrnew)+deltalrold).*(1-exp(betam*c1*f+betam*(1-c1)*s));
    pop(2,1,1)=b*(1-gamma-deltabnew)+((1-b-deltabold)*(1-deltabnew)+deltabold).*(1-exp(betam*c1*f+betam*(1-c1)*s+betab*b));
    pop(3,1,1)=f*(1-gamma-deltalrnew)+((1-f-deltalrold)*(1-deltalrnew)+deltalrold)*(1-exp(betaf*c2*m+betaf*(1-c2)*b));
    pop(4,1,1)=s*(1-gamma-deltasnew)+((1-s-deltasold)*(1-deltasnew)+deltasold)*(1-exp(betas*c2*m+betas*(1-c2)*b));
    0;
end
