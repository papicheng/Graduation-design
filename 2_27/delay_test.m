%��������ᰵ����ģ����Ʋ�������Ƶ������

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
xlabel('Ƶ�ʣ�Hz��')
ylabel('��ֵ�ȣ�dB��');
title('�������ַ�Ƶͼ')
figure;
semilogx(f,xita);grid on;zoom on;
xlabel('Ƶ�ʣ�Hz��')
ylabel('��λ��㣩');
title('����������Ƶͼ')