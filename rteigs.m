function eigs=rteigs(p)
    steps=12;
    pop=[gv(p,'w')
        gv(p,'x')
        gv(p,'y')
        gv(p,'z')];
    gamma=gv(p,'gamma')/steps;
       c2=1-gv(p,'probb');
      asm=gv(p,'probs')*(gv(p,'ac')*gv(p,'csm')+gv(p,'ar')*gv(p,'rsm'));
       c1=1-asm/(asm+(1-gv(p,'probs'))*(gv(p,'ac')*gv(p,'cfm')+gv(p,'ar')*gv(p,'rfm')));
     zeta=gv(p,'alphas')*gv(p,'zeta');
thetaDivEps=gv(p,'theta');
        d=gv(p,'tau')/steps;
    eigs=findequilib(pop,gamma,c1,c2,zeta,thetaDivEps,d);
end
function val=gv(p,str)
    val=p{2,strcmp(p(1,:),str)};
end
