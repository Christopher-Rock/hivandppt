function pop=smalltsti(pa,betam,betab,betaf,betas,c1,c2,gamma,zeta,theta)
    m=pa(1,1,1);b=pa(2,1,1);f=pa(3,1,1);s=pa(4:end,1,1);
    if zeta
        S=pa(4,1,1)*(1-zeta)+mean(pa(5:end,1,1))*zeta;
        sr=pa(4:end,1,2);
    else
        S=pa(4);
        sr=0;
    end
    pop=zeros(size(pa));
    pop(1,1,1)=m*(1-gamma)+(1-m).*(1-exp(betam*f+betam*(1-c1)*S));
    pop(2,1,1)=b*(1-gamma)+(1-b).*(1-exp(betam*f+betam*(1-c1)*S+betab*b));
    pop(3,1,1)=f*(1-gamma)+(1-f)*(1-exp(betaf*c2*m+betaf*(1-c2)*b));
    pop(4:end,1,1)=s*(1-gamma)+(1-s-sr)*(1-exp(betas*c2*m+betas*(1-c2)*b));
    0;
    if size(pa,3)==2
        pop(4:end,1,2)=sr*(1-theta);
    end
end