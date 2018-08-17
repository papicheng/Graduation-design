%梯形输入信号

close all
% ezplot('100/(1+exp(-500*x))')
% grid on
x=-0.03:0.00025:0.03;
y=150000./(1+exp(-500.*x));
% hold on
figure
plot(x,y,'k')
set(gca,'xlim',[-0.03 0.03])
y1=fliplr(y);
out=[y,y1];
t=(0:length(out)-1)*0.00025;

plot(t,out,'k')
grid on
title('规划位置信号')
xlabel('t(s)')
ylabel('positon(um)')
input=[t',out'];

xerr=X3-X;
xerr=xerr*0.2;
t=(0:length(xerr)-1)*0.00025;
figure
plot(t,xerr,'k')
grid on
title('跟踪误差')
xlabel('t(s)')
ylabel('positon error(um)')

figure
plot(t,X2,'k')
grid on
title('输出加速度')
xlabel('t(s)')
ylabel('a(g)')

