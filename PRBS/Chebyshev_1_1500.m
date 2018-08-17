Fs=4000;  %采样频率8000Hz
wp=1000*2/Fs; ws=1500*2/Fs;%将通带临界频率Fcp和阻带临界频率Fcs转换为归一化频率
Rp=0.01;Rs=40;%通带衰减和阻带衰减
Nn=128;%绘频谱图所用点数
[N,Wn]=cheb1ord(wp,ws,Rp,Rs);%求滤波器的最小阶数和临界频率（归一化频率）
[b,a]=cheby1(N,Rp,Wn); %求Butterworth数字滤波器传递函数的分子b和分母a
figure(1) %图形(一)
[H,f]=freqz(b,a,Nn,Fs) %绘制滤波器特性图
subplot(2,1,1),plot(f,20*log10(abs(H)))
xlabel('频率/Hz');ylabel('振幅/dB');grid on;
subplot(2,1,2),plot(f,180/pi*unwrap(angle(H)))
xlabel('频率/Hz');ylabel('相位/^o');grid on;
figure(2)%图形(二)
f1=1200;f2=600; %输入的两种频率成分
N=100;%输入信号的数据点数
dt=1/Fs;n=0:N-1;t=n*dt;%时间序列
x=sin(2*pi*f1*t)+0.5*cos(2*pi*f2*t);%输入信号
subplot(2,1,1),plot(t,x),title('输入信号')
y=filtfilt(b,a,x);%对输入信号进行滤波
subplot(2,1,2),plot(t,y)%绘制输出信号
ylim([-1.5 1.5])
title('输出信号'),xlabel('时间/s')