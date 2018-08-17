Fs=4000;  %����Ƶ��8000Hz
wp=1000*2/Fs; ws=1500*2/Fs;%��ͨ���ٽ�Ƶ��Fcp������ٽ�Ƶ��Fcsת��Ϊ��һ��Ƶ��
Rp=0.01;Rs=40;%ͨ��˥�������˥��
Nn=128;%��Ƶ��ͼ���õ���
[N,Wn]=cheb1ord(wp,ws,Rp,Rs);%���˲�������С�������ٽ�Ƶ�ʣ���һ��Ƶ�ʣ�
[b,a]=cheby1(N,Rp,Wn); %��Butterworth�����˲������ݺ����ķ���b�ͷ�ĸa
figure(1) %ͼ��(һ)
[H,f]=freqz(b,a,Nn,Fs) %�����˲�������ͼ
subplot(2,1,1),plot(f,20*log10(abs(H)))
xlabel('Ƶ��/Hz');ylabel('���/dB');grid on;
subplot(2,1,2),plot(f,180/pi*unwrap(angle(H)))
xlabel('Ƶ��/Hz');ylabel('��λ/^o');grid on;
figure(2)%ͼ��(��)
f1=1200;f2=600; %���������Ƶ�ʳɷ�
N=100;%�����źŵ����ݵ���
dt=1/Fs;n=0:N-1;t=n*dt;%ʱ������
x=sin(2*pi*f1*t)+0.5*cos(2*pi*f2*t);%�����ź�
subplot(2,1,1),plot(t,x),title('�����ź�')
y=filtfilt(b,a,x);%�������źŽ����˲�
subplot(2,1,2),plot(t,y)%��������ź�
ylim([-1.5 1.5])
title('����ź�'),xlabel('ʱ��/s')