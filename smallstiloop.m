function pop=smallstiloop(pa,v,rates)
    m=pa(1);f=pa(2);s=pa(3);
    pop=zeros(3,1);
    pop(1)=m+(1-m).*(1-exp(rates(1).*(rates(5)*f+(1-rates(5))*s)));
    pop(2)=f+(1-f).*(1-exp(rates(2).*(rates(6)*m+(1-rates(6))*v)));
    pop(3)=s+(1-s).*(1-exp(rates(3).*(rates(7)*m+(1-rates(7))*v)));
    pop=pop-pa.*rates(4);
end