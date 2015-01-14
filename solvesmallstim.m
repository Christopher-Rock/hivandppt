function rates=solvesmallstim (pop,c,gm)
    x=pop(1);
    y=pop(2);
    z=pop(3);
    syms b1 b2 b3 
    [rates(1),rates(2),rates(3)]=solve( ...
        x==(1-gm).*x+(1-x).*(1-exp(b1.*c*y+b1*(1-c)*z)), ...
        y==(1-gm).*y+(1-y).*(1-exp(b2*x)), ...
        z==(1-gm).*z+(1-z).*(1-exp(b3*x)),b1,b2,b3);
    