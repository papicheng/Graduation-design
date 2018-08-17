%画出输入输出数据
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
    legend('输入','输出')
    xlabel('采样点数')
    ylabel(AX(1),'输入DAC') ;
    ylabel(AX(2),'输出脉冲数');
    title('开环3Hz正弦输入输出数据')
    
    data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f30_Gain_400_043109.txt');
    
    input=data(1:4000,2);
    output=data(1:4000,1);
    output=output-output(1);
    len=length(input);
    x=1:len;
    figure('color',[1 1 1])
    [AX,H1,H2] = plotyy(x,input,x,output);
    grid on;zoom on;
    legend('输入','输出')
    xlabel('采样点数')
    ylabel(AX(1),'输入DAC') ;
    ylabel(AX(2),'输出脉冲数');
    title('开环30Hz正弦输入输出数据')
    %---------------------------速度
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
    legend('输入','输出')
    xlabel('采样点数')
    ylabel(AX(1),'输入DAC') ;
    ylabel(AX(2),'输出速度');
    title('开环30Hz正弦输入输出数据')
    
    data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f200_Gain_1200_091847.txt');
    
    input=data(1:700,2);
    output=data(1:700,1);
    output=output-output(1);
    len=length(input);
    x=1:len;
    figure('color',[1 1 1])
    [AX,H1,H2] = plotyy(x,input,x,output);
    grid on;zoom on;
    legend('输入','输出')
    xlabel('采样点数')
    ylabel(AX(1),'输入DAC') ;
    ylabel(AX(2),'输出脉冲数');
    title('开环200Hz正弦输入输出数据')
    
    
    data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f901_Gain_1200_092220.txt');
    
    input=data(1:300,2);
    output=data(1:300,1);
    output=output-output(1);
    len=length(input);
    x=1:len;
    figure('color',[1 1 1])
    [AX,H1,H2] = plotyy(x,input,x,output);
    grid on;zoom on;
    legend('输入','输出')
    xlabel('采样点数')
    ylabel(AX(1),'输入DAC') ;
    ylabel(AX(2),'输出脉冲数');
    title('开环901Hz正弦输入输出数据')
end
if closeflag==1
    data=load('G:\study\GraduationThesis\dataOfSine\X-Y-Table-速度闭环\X-Y-Table-X轴速度闭环SweepSine1-1000Hz\Axis1_RefVel_EncVel_SweepSine_f100_Gain_30_111320.txt');
    
    input=data(1:300,1);
    output=data(1:300,2);
    output=output-output(1);
    len=length(input);
    x=1:len;
    figure('color',[1 1 1])
    [AX,H1,H2] = plotyy(x,input,x,output);
    grid on;zoom on;
    legend('输入','输出')
    xlabel('采样点数')
    ylabel(AX(1),'输入速度') ;
    ylabel(AX(2),'输出速度');
    title('速度闭环100Hz正弦输入输出数据')
    
    data=load('G:\study\GraduationThesis\dataOfSine\X-Y-Table-速度闭环\X-Y-Table-X轴速度闭环SweepSine1-1000Hz\Axis1_RefVel_EncVel_SweepSine_f800_Gain_30_112257.txt');
    
    input=data(1:100,1);
    output=data(1:100,2);
    output=output-output(1);
    len=length(input);
    x=1:len;
    figure('color',[1 1 1])
    [AX,H1,H2] = plotyy(x,input,x,output);
    grid on;zoom on;
    legend('输入','输出')
    xlabel('采样点数')
    ylabel(AX(1),'输入速度') ;
    ylabel(AX(2),'输出速度');
    title('速度闭环800Hz正弦输入输出数据')
end
