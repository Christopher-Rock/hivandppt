function Beta=slowoptimsmallsti(pop,c1,c2,gamma)
    f=@(Beta) sum((smalltsti(pop,Beta(1),Beta(2),Beta(3),Beta(4), ...
        c1,c2,gamma,0,0)-pop).^2);
    w=pop(1);x=pop(2);y=pop(3);z=pop(4);
    betain(1)=log((1-w-gamma*w)/(1-w))/(c1*y+(1-c1)*z);
    betain(2)=log((1-x-gamma*x)/(1-x)/exp(betain(1)*(c1*y+(1-c1)*z)))/x;
    betain(3)=log((1-y-gamma*y)/(1-y))/(c2*w+(1-c2)*x);
    betain(4)=log((1-z-gamma*z)/(1-z))/(c2*w+(1-c2)*x);   
    opts=optimoptions(@fminunc,'Algorithm','quasi-newton','Display','off','TolFun',1e-12,'TolX',1e-9);
    Beta=fminunc(f,betain,opts); % Suggested constant replacement for betain: [-0.6 -0.02 -1.2 -8]
0;
