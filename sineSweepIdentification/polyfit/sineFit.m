x = [2 10 5 4] ;
xdata = sort(rand(1,100)) ;
ydata = x(1)*sin(x(2)*xdata+x(3))+x(4) ;
options = optimset('MaxFunEvals',1000000); %改写一个参数，用于下面函数lsqcurvefit的设置
%否则，lsqcurvefit可能在求出最优解前停止计算。
x_est = lsqcurvefit(@(x,xdata) myfun(x,xdata),[2 2 2 2],xdata,ydata);
plot(xdata,ydata,'b-') ;
hold on
plot(xdata,myfun(x_est,xdata),'g-') ;
legend({'观测值','拟合值'}) ;
options = optimset('MaxFunEvals',1000000);