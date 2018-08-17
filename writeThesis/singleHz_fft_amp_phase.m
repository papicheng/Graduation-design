clc
close all
clear
openflag=0;%ѡ���ÿ������Ǳջ�
closeflag=1;
if openflag==1
    data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f151_Gain_2500_043353.txt');
    input=data(:,2);
    output=data(:,1);
    for i=1:100
        if input(i)>0
            break
        end
    end
    i=i-1;
    input=input(i:end);
    output=output(i:end);
    input=input(1:4000);
    output=output(501:4500);
    input=input-input(1);
    output=output-output(1);
    Fs = 4000;            % Sampling frequency
    T = 1/Fs;             % Sampling period
    L = 4000;             % Length of signal
    t = (0:L-1)*T;        % Time vector
    X=output;
    figure;
    plot(X)
    Y = fft(X);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    oo=P1(152);
    P1(152)=0;
    plot(f,P1)
    hold on;
    stem(152,oo)
    title('151Hz���������')
    xlabel('Ƶ��(Hz)')
    ylabel('��ֵ')
    set(gca,'XLim',[-5 200])
end
if closeflag==1
    data=load('G:\study\GraduationThesis\dataOfSine\X-Y-Table-�ٶȱջ�\X-Y-Table-X���ٶȱջ�SweepSine1-1000Hz\Axis1_RefVel_EncVel_SweepSine_f100_Gain_30_111320.txt');
    input=data(:,1);
    output=data(:,2);
    for i=1:100
        if input(i)>0
            break
        end
    end
    i=i-1;
    input=input(i:end);
    output=output(i:end);
    input=input(1:4000);
    output=output(501:4500);
    
    Fs = 4000;            % Sampling frequency
    T = 1/Fs;             % Sampling period
    L = 4000;             % Length of signal
    t = (0:L-1)*T;        % Time vector
    X=output;
    figure;
    plot(X)
    Y = fft(X);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    oo=P1(101);
    P1(101)=0;%Ƶ�ʵ���
    plot(f,P1)
    hold on;
    stem(101,oo)
    title('�ٶȻ�100Hz���������')
    xlabel('Ƶ��(Hz)')
    ylabel('��ֵ')
    set(gca,'XLim',[-5 200])
end
