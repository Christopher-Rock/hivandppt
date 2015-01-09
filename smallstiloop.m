function pop=smallstiloop(pa,rates)
    m=pa(1);f=pa(2);s=pa(3);
    pop=zeros(3,1);
    pop(1)=m+rates(1).*(1-m).*(f+s);
    pop(2)=f+rates(2).*(1-f).*m;
    pop(3)=s+rates(3).*(1-s).*m;
    pop=pop-pa.*rates(4);
end