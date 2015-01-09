function pop=smalltsti(pa,rates)
    m=pa(1);f=pa(2);s=pa(3:end);
    S=pa(3)*(1-rates(5))+mean(pa(4:end))*rates(5);
    pop=zeros(size(pa));
    pop(1)=m+rates(1).*(1-m).*(f+S);
    pop(2)=f+rates(2).*(1-f).*m;
    pop(3:end)=s+rates(3).*(1-s).*m;
    pop=pop-pa.*rates(4);
end