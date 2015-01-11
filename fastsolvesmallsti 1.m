function rates=fastsolvesmallsti(x,y,z,v,c)
c1=c(1);c2=c(2);c3=c(3);c4=c(4);
rates=[
       log((d1 + d4 - x - c1*d4*x)/(d4 - d4*x))/(c2*y - z*(c2 - 1))
       log(-(d2 + d5 - y - c1*d5*y)/(d5*(y - 1)))/(v - c3*v + c3*x)
       log(-(d3 + d6 - z - c1*d6*z)/(d6*(z - 1)))/(v - c4*v + c4*x)
 ];