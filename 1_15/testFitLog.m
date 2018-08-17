x1=[32 24 18 13.5];

y1=[675 1050 1580 2487];


p=polyfit(log(x1),log(y1),1)  %多项式拟合，p为多项式系数，最后的1为要拟合成的阶数

x2=10:0.1:50;

y2=exp(polyval(p,log(x2)));
figure;
loglog(x1,y1,'*',x2,y2,'-')
grid on;zoom on;