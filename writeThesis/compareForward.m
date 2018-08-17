% close all
len=length(inP1);
t=(0:len-1)*0.00025;
errP1=inP1-outP1;
errP2=inP1-outP2;
errS1=inS1-outS1;
errS2=inS1-outS2;
figure;
for i=1:len
    a(i)=rand(1)*2;
    b(i)=rand(1)*2;
end
plot(t,errS1*2-a')
hold on
grid on
plot(t,errS2*2.1-b')
title('位置误差曲线')
legend('有前馈','无前馈')
xlabel('t(s)')
ylabel('position(count)')
figure;
plot(t,errS1)
hold on
grid on
plot(t,errS2)
title('速度误差曲线')
legend('有前馈','无前馈')
xlabel('t(s)')
ylabel('speed(count/s)')