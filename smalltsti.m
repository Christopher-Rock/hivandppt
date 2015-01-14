function pop=smalltsti(pa,dm,df,ds,mum,muf,mus,betam,betaf,betas,c,gamma,zeta)
    m=pa(1,1,1);f=pa(2,1,1);s=pa(3:end,1,1);
    if zeta
        S=pa(3,1,1)*(1-zeta)+mean(pa(4:end,1,1))*zeta;
        sr=pa(4:end,1,2);
    else
        S=pa(3);
    end
    pop=zeros(size(pa));
    pop(1,1,1)=(m*(1-gamma)+(1-m).*(1-exp(betam*f+betam*(1-c)*S))).*(1-mum)+mum*dm;
    pop(2,1,1)=(f*(1-gamma)+(1-f)*(1-exp(betaf*m)))*(1-muf)+muf*df;
    pop(3:end,1,1)=(s*(1-gamma)+(1-s-sr)*(1-exp(betas*m)))*(1-mus)+mus*ds;
    0;
    if size(pa,3)==2
        pop(4:end,1,2)=sr*(1-theta);
    end
end