data=0;sine=0;M=0;t=0;p=0;
data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f10_Gain_200_042819.txt');
data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f96_Gain_1000_043303.txt');
polyfit
sine=data(:,2);
p=data(:,1);
sineLen=length(sine);
t=(0:sineLen-1)*0.00025;
M=[t',sine];

v_measure=diff(p);
v_measure=v_measure(1:end-1);

v_id=diff(simout);
v_id=v_id(2:end);
len=length(v_id);
% v_id=v_id(2:end);
figure
plot(v_measure)
hold on 
grid on
plot(v_id)
legend('测量的速度','辨识的速度')
title('96Hz正弦输入的情况')
xlabel('采样点数')
ylabel('速度')
set(gca,'xlim',[3400 4000])

corrcoef(v_measure(1:len),v_id(1:len))
MSE=sum((v_measure(1:len)-v_id(1:len)).^2)/len