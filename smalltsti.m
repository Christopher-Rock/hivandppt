function pop=smalltsti(pa,dm,df,ds,mum,muf,mus,betamf,betams,betafm,betasm,gamma,pm,pf,zeta)
    m=pa(1);f=pa(2);s=pa(3:end);
    if zeta
        S=pa(3)*(1-zeta)+mean(pa(4:end))*zeta;
    else
        S=s;
    end
    pop=zeros(size(pa));
    pop(1)=(m*(1-gamma)+(1-m).*(1-(1-pm).^(betamf*f+betams*S))).*(1-mum)+mum*dm;
    pop(2)=(f*(1-gamma)+(1-f)*(1-(1-pf)^(betafm*m)))*(1-muf)+muf*df;
    pop(3:end)=(s*(1-gamma)+(1-s)*(1-(1-pf)^(betasm*m)))*(1-mus)+mus*ds;
end