x = [2 10 5 4] ;
xdata = sort(rand(1,100)) ;
ydata = x(1)*sin(x(2)*xdata+x(3))+x(4) ;
options = optimset('MaxFunEvals',1000000); %��дһ���������������溯��lsqcurvefit������
%����lsqcurvefit������������Ž�ǰֹͣ���㡣
x_est = lsqcurvefit(@(x,xdata) myfun(x,xdata),[2 2 2 2],xdata,ydata);
plot(xdata,ydata,'b-') ;
hold on
plot(xdata,myfun(x_est,xdata),'g-') ;
legend({'�۲�ֵ','���ֵ'}) ;
options = optimset('MaxFunEvals',1000000);