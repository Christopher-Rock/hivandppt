function [equilib,otherlevel,stilevel]=splitsti(stilevel,phi)
    psifrac=phi(3);
    oldphi=phi(2);
    phi=phi(1);
    otherlevel=(1-(1-stilevel)./(1-phi*stilevel));
    equilib=phi*stilevel;
    stilevel=joinsti(equilib,otherlevel);
end
