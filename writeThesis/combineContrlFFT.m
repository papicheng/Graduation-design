close all
N=1;
i=1;
ampout=0;
phout=0;
ampout1=0;
phout1=0;
for f=10:10:100
    sim('idealMode_pid_feedback_frontback.slx');%ÿһ��Ƶ�ʵ�����һ�·���ģ��
    X=X(1:4000);%���ڷ���ģ�����һ�£�����ʱ��1.5S,�����˲���ʱ�䣬����Ƶ��Ϊ2KHZ��Ϊ��FFT���㣬ֻ��2000���㣬����ȡ����ĵ㣬��Ϊ����һ�ι���ʱ��
    X=fft(X);
    L=length(X);
%     P2 = abs(X/L);
%     P1 = P2(1:L/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
    ampout(i)=abs(X(f*N+1))/L*2;
    phout(i)=angle(X(f*N+1));
    
    amprate(i)=ampout(i)/5000;
    amprate(i)=20*log10(amprate(i));
    
    X1=X1(1:4000);%���ڷ���ģ�����һ�£�����ʱ��1.5S,�����˲���ʱ�䣬����Ƶ��Ϊ2KHZ��Ϊ��FFT���㣬ֻ��2000���㣬����ȡ����ĵ㣬��Ϊ����һ�ι���ʱ��
    X1=fft(X1);
    L1=length(X1);
%     P2 = abs(X/L);
%     P1 = P2(1:L/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
    ampout1(i)=abs(X1(f*N+1))/L1*2;
    phout1(i)=angle(X1(f*N+1));
    amprate1(i)=ampout1(i)/(5000*f*0.000025*pi*2);
    amprate1(i)=20*log10(amprate1(i));
    i=i+1;
end
f=10:10:100;
figure
subplot(2,1,1)
semilogx(f,amprate);grid on;title('λ��')
ylabel('amplitude(dB)')
subplot(2,1,2)
semilogx(f,phout);grid on;
ylabel('phase(deg)')
xlabel('f(Hz)')
figure
subplot(2,1,1)

semilogx(f,amprate1);grid on;title('�ٶ�')
ylabel('amplitude(dB)')

subplot(2,1,2)
semilogx(f,phout1);grid on;
ylabel('phase(deg)')
xlabel('f(Hz)')