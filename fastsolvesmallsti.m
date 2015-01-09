function rates=fastsolvesmallsti(X,Y,Z,B4)
    rates(1)=-(B4*X)/((Y + Z)*(X - 1));
    rates(2)=-(B4*Y)/(X*(Y - 1));
    rates(3)=-(B4*Z)/(X*(Z - 1));
 