function [equilib,otherlevel]=splitsti(stilevel,phi)
    phiold=phi(2);
    phi=phi(1);
    otherlevel=1-(1-stilevel)./(1-phiold*stilevel);
    equilib=phi*stilevel;
end
