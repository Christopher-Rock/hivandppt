tmax=40;
x=ones(10,tmax);
onepop=ones(1,tmax);
jt=zeros(1,tmax);
for t=2:tmax
x(:,t)=x(1:10,t-1).*.95;
x(mod(t-1,10)+1,t)=1;
onepop(t)=0.1+onepop(t-1)*0.95.*(1-0.1/jt(t-1));
jt(t)=.1+jt(t-1).*0.95;
end
[mean(x);onepop]
