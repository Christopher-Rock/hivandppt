if ~exist('steps','var'), steps=12;  end
if ~exist('reg','var'),     reg= 1;  end




if reg
    if reg==2 %#ok<ALIGN>
        c1=.96;c2=.94;Delta=3;zetax=[0;0;0;.5];Theta=1;pa1=[.07 .08 .09 .32];Gamma=1;
    elseif reg==1
        c1=.94;c2=.80;Delta=3;zetax=[0;0;0;.5];Theta=1;pa1=[.05 .06 .07 .3];Gamma=1;
    else warning, end
    gamma=Gamma/steps;
    delta=Delta/steps;
     beta= Beta/steps;
    pa=cat(3,pa1(:),pa1(:),zeros(4,1));
end
betam=beta(3);betab=beta(4);betaf=beta(2);betas=beta(1);
lng(@smalltsti,pa,0.001,betam,betab,betaf,betas,c1,c2,gamma,delta,zetax,Theta)
