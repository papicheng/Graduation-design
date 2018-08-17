%根据雷罗岚的论文，绘制采样保持频率特性

close all
clear

T=0.00025;
f=1:1000;
w=2*pi*f;
G_jw=(1-exp(-T*(1j*w)))./(T*1j*w);
amp=abs(G_jw);
xita=angle(G_jw)*180/pi;
figure;
semilogx(f,20*log10(amp));grid on;zoom on;
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
title('采样保持幅频图')
figure;
semilogx(f,xita);grid on;zoom on;
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('采样保持相频图')