clc
clear
close all

data=load('G:\study\GraduationThesis\dataOfSine\X-Y-Table-速度闭环\X-Y-Table-X轴速度闭环Prbs\Axis1_RefVel_EncVel_Prbs_Gain_20_112949.txt');
input=data(1:300,1);
output=data(1:300,2);

len=length(input);
x=1:len;
figure('color',[1 1 1])
[AX,H1,H2] = plotyy(x,input,x,output,'stairs','plot');
grid on;zoom on;
legend('输入','输出')
xlabel('采样点数')
ylabel(AX(1),'输入速度') ;
ylabel(AX(2),'输出速度');
title('速度环PRBS输入输出数据')
set(AX(1),'ylim',[-20.5,20.5])
set(AX(2),'ylim',[-20.5,20.5])