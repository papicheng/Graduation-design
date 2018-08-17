%���������������
clc
clear
close all
openflag=1;
closeflag=1;
if openflag==1
    data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f2_Gain_200_042713.txt');
    
    input=data(:,2);
    output=data(:,1);
    output=output-output(1);
    len=length(input);
    x=1:len;
    figure('color',[1 1 1])
    [AX,H1,H2] = plotyy(x,input,x,output);
    grid on;zoom on;
    legend('����','���')
    xlabel('��������')
    ylabel(AX(1),'����DAC') ;
    ylabel(AX(2),'���������');
    title('����3Hz���������������')
    
    data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f30_Gain_400_043109.txt');
    
    input=data(1:4000,2);
    output=data(1:4000,1);
    output=output-output(1);
    len=length(input);
    x=1:len;
    figure('color',[1 1 1])
    [AX,H1,H2] = plotyy(x,input,x,output);
    grid on;zoom on;
    legend('����','���')
    xlabel('��������')
    ylabel(AX(1),'����DAC') ;
    ylabel(AX(2),'���������');
    title('����30Hz���������������')
    %---------------------------�ٶ�
    data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f30_Gain_400_043109.txt');
    
    input=data(1:4000,2);
    output=data(1:4001,1);
    output=diff(output);
%     output=output-output(1);
    len=length(input);
    x=1:len;
    figure('color',[1 1 1])
    [AX,H1,H2] = plotyy(x,input,x,output);
    grid on;zoom on;
    legend('����','���')
    xlabel('��������')
    ylabel(AX(1),'����DAC') ;
    ylabel(AX(2),'����ٶ�');
    title('����30Hz���������������')
    
    data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f200_Gain_1200_091847.txt');
    
    input=data(1:700,2);
    output=data(1:700,1);
    output=output-output(1);
    len=length(input);
    x=1:len;
    figure('color',[1 1 1])
    [AX,H1,H2] = plotyy(x,input,x,output);
    grid on;zoom on;
    legend('����','���')
    xlabel('��������')
    ylabel(AX(1),'����DAC') ;
    ylabel(AX(2),'���������');
    title('����200Hz���������������')
    
    
    data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f901_Gain_1200_092220.txt');
    
    input=data(1:300,2);
    output=data(1:300,1);
    output=output-output(1);
    len=length(input);
    x=1:len;
    figure('color',[1 1 1])
    [AX,H1,H2] = plotyy(x,input,x,output);
    grid on;zoom on;
    legend('����','���')
    xlabel('��������')
    ylabel(AX(1),'����DAC') ;
    ylabel(AX(2),'���������');
    title('����901Hz���������������')
end
if closeflag==1
    data=load('G:\study\GraduationThesis\dataOfSine\X-Y-Table-�ٶȱջ�\X-Y-Table-X���ٶȱջ�SweepSine1-1000Hz\Axis1_RefVel_EncVel_SweepSine_f100_Gain_30_111320.txt');
    
    input=data(1:300,1);
    output=data(1:300,2);
    output=output-output(1);
    len=length(input);
    x=1:len;
    figure('color',[1 1 1])
    [AX,H1,H2] = plotyy(x,input,x,output);
    grid on;zoom on;
    legend('����','���')
    xlabel('��������')
    ylabel(AX(1),'�����ٶ�') ;
    ylabel(AX(2),'����ٶ�');
    title('�ٶȱջ�100Hz���������������')
    
    data=load('G:\study\GraduationThesis\dataOfSine\X-Y-Table-�ٶȱջ�\X-Y-Table-X���ٶȱջ�SweepSine1-1000Hz\Axis1_RefVel_EncVel_SweepSine_f800_Gain_30_112257.txt');
    
    input=data(1:100,1);
    output=data(1:100,2);
    output=output-output(1);
    len=length(input);
    x=1:len;
    figure('color',[1 1 1])
    [AX,H1,H2] = plotyy(x,input,x,output);
    grid on;zoom on;
    legend('����','���')
    xlabel('��������')
    ylabel(AX(1),'�����ٶ�') ;
    ylabel(AX(2),'����ٶ�');
    title('�ٶȱջ�800Hz���������������')
end
