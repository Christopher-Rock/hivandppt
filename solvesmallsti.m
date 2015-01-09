function rates=solvesmallsti (pop,b4)
    x=pop(1);
    y=pop(2);
    z=pop(3);
    syms b1 b2 b3 
    [rates(1),rates(2),rates(3)]=solve(x==(1-b4).*x+b1.*(1-x).*(y+z), ...
        y==(1-b4).*y+b2.*(1-y).*x,z==(1-b4).*z+b3.*(1-z).*x,b1,b2,b3);
    