function rates=solvesmallsti (pop,v,c)
    x=pop(1);
    y=pop(2);
    z=pop(3);
    syms b1 b2 b3 
    [rates(1),rates(2),rates(3)]=solve( ...
        x==(1-c(1)).*x+(1-x).*(1-exp(b1.*(c(2)*y+(1-c(2))*z))), ...
        y==(1-c(1)).*y+(1-y).*(1-exp(b2.*(c(3)*x+(1-c(3))*v))), ...
        z==(1-c(1)).*z+(1-z).*(1-exp(b3.*(c(4)*x+(1-c(4))*v))),b1,b2,b3);
    