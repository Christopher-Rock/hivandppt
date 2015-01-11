function pop=smalltstic(pa,v,b,c)
    m=pa(1);f=pa(2);s=pa(3:end);
    S=pa(3)*(1-c(5))+mean(pa(4:end))*c(5);
    pop=zeros(size(pa));
    pop(1)=m+b(1).*(1-m).*(c(2)*f+(1-c(2))*S);
    pop(2)=f+b(2).*(1-f).*(c(3)*m+(1-c(3))*v);
    pop(3:end)=s+b(3).*(1-s).*(c(4)*m+(1-c(4))*v);
    pop=pop-pa.*c(1);
end