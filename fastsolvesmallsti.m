function rates=fastsolvesmallsti(x,y,z,v,c)
c1=c(1);c2=c(2);c3=c(3);c4=c(4);
rates=[
   log((c1*x)/(x - 1) + 1)/(c2*y - z*(c2 - 1))
 log((y + c1*y - 1)/(y - 1))/(v - c3*v + c3*x)
 log((z + c1*z - 1)/(z - 1))/(v - c4*v + c4*x)
 ];