function pop=smalltsti(pa,betam,betaf,betas,c,gamma,zeta,theta)
    m=pa(1,1,1);f=pa(2,1,1);s=pa(3:end,1,1);
    if zeta
        S=pa(3,1,1)*(1-zeta)+mean(pa(4:end,1,1))*zeta;
        sr=pa(3:end,1,2);
    else
        S=pa(3);
        sr=0;
    end
    pop=zeros(size(pa));
    pop(1,1,1)=m*(1-gamma)+(1-m).*(1-exp(betam*f+betam*(1-c)*S));
    pop(2,1,1)=f*(1-gamma)+(1-f)*(1-exp(betaf*m));
    pop(3:end,1,1)=s*(1-gamma)+(1-s-sr)*(1-exp(betas*m));
    0;
    if size(pa,3)==2
        pop(3:end,1,2)=sr*(1-theta);
    end
end