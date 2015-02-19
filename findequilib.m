function out=findequilib(pop,gamma,c1,c2,zeta,thetaDivEps,d)
    td=thetaDivEps/365.25*d;
    g1=gamma;g2=d;
    [b3,b4,b2,b1]=optimsmallsti(pop,c2,c1,g1);
    b1=-b1;b2=-b2;b3=-b3;b4=-b4;
 [b1,b2,b3,b4];
S=[-g1                 0                       0      c1*b1    (1-c1)*b1;
    0                  -g1-g2                  0      c1*b1    (1-c1)*b1;
    0                  0                       -g1    c1*b2    (1-c1)*b2;
    (1-c2)*(1-zeta)*b3 (1-c2)*zeta*(1-td)*b3   c2*b3  -g1      0;
    (1-c2)*(1-zeta)*b3 (1-c2)*zeta*(1-td)*b3   c2*b3  0        -g1+b4];
[~,D]=eig(S);
out=(diag(D));
% syms
% solve(
% A=[-g1-g2 0 c2*b1 (1-c2)*b1;0 -g1 c2*b2 (1-c2)*b2;(1-c1)*b3 c1*b3 -g1 0;(1-c1)*b3 c1*b3 0 -g1+b4]
% [~,D]=eig(A);
% out=diag(D);
