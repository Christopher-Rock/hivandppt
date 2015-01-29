function pop=smalltsti(pa,betam,betab,betaf,betas,c1,c2,gamma,delta,zetax,Theta)
    if any(zetax)
        prevxin=pa(:,1,1).*(1-zetax)+pa(:,:,2).*zetax;
    dz=delta*zetax;
    else
        prevxin=pa(:,1,1);
    end       
    m=prevxin(1);b=prevxin(2);f=prevxin(3);s=prevxin(4);
    pop=zeros(size(pa));
    lambdax=1-exp([
        betam*c1*f+betam*(1-c1)*s
        betam*c1*f+betam*(1-c1)*s+betab*b
        betaf*c2*m+betaf*(1-c2)*b
        betas*c2*m+betas*(1-c2)*b]);
    pop(:,1,1)   = (1-pa(:,1,1)).*lambdax+pa(:,1,1).*(1-gamma);
    if any(zetax)    
        pop(:,1,2)=(1-pa(:,1,2)).*lambdax+pa(:,1,2).*(1-gamma-dz);
        pop(:,1,3)=(1-pa(:,1,3)).*dz+pa(:,1,3).*(1-Theta);
    end
    0;
end
