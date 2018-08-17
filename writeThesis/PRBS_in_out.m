clc
clear
close all

data=load('G:\study\GraduationThesis\dataOfSine\X-Y-Table-�ٶȱջ�\X-Y-Table-X���ٶȱջ�Prbs\Axis1_RefVel_EncVel_Prbs_Gain_20_112949.txt');
input=data(1:300,1);
output=data(1:300,2);

len=length(input);
x=1:len;
figure('color',[1 1 1])
[AX,H1,H2] = plotyy(x,input,x,output,'stairs','plot');
grid on;zoom on;
legend('����','���')
xlabel('��������')
ylabel(AX(1),'�����ٶ�') ;
ylabel(AX(2),'����ٶ�');
title('�ٶȻ�PRBS�����������')
set(AX(1),'ylim',[-20.5,20.5])
set(AX(2),'ylim',[-20.5,20.5])