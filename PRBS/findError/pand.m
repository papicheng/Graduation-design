function [u,delta,i]=pand(y,i,L)
u=y(i-1)+0.5*y(i-2)-0.5*y(i-4);
delta=3*std(y(i-4:i-1));
while (abs(u-y(i))<=delta)&&(i<L)
    i=i+1;
    u=y(i-1)+0.5*y(i-2)-0.5*y(i-4);
delta=3*std(y(i-4:i-1));
end