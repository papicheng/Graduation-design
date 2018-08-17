close all
N=1;
i=1;
ampout=0;
phout=0;
ampout1=0;
phout1=0;
for f=10:10:100
    sim('idealMode_pid_feedback_frontback.slx');%每一个频率点运行一下仿真模块
    X=X(1:4000);%我在仿真模块改了一下，仿真时间1.5S,增加了采样时间，采样频率为2KHZ，为了FFT方便，只用2000个点，尽量取靠后的点，因为它有一段过渡时间
    X=fft(X);
    L=length(X);
%     P2 = abs(X/L);
%     P1 = P2(1:L/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
    ampout(i)=abs(X(f*N+1))/L*2;
    phout(i)=angle(X(f*N+1));
    
    amprate(i)=ampout(i)/5000;
    amprate(i)=20*log10(amprate(i));
    
    X1=X1(1:4000);%我在仿真模块改了一下，仿真时间1.5S,增加了采样时间，采样频率为2KHZ，为了FFT方便，只用2000个点，尽量取靠后的点，因为它有一段过渡时间
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
semilogx(f,amprate);grid on;title('位置')
ylabel('amplitude(dB)')
subplot(2,1,2)
semilogx(f,phout);grid on;
ylabel('phase(deg)')
xlabel('f(Hz)')
figure
subplot(2,1,1)

semilogx(f,amprate1);grid on;title('速度')
ylabel('amplitude(dB)')

subplot(2,1,2)
semilogx(f,phout1);grid on;
ylabel('phase(deg)')
xlabel('f(Hz)')