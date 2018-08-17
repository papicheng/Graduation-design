% data=xlsread('G:\study\GraduationThesis\dataOfSine\Axis1_DAC_ENC_SweepSine_29_Jan_2018_15_58_51.xlsx');%X轴开环
data=xlsread('G:\study\GraduationThesis\dissertationAndMore\论文绘图\X开环凑到2000Hz频率幅值相位.xlsx');
f=data(:,1);
amp=data(:,2);
pha=data(:,3);
% i=1;
% while f(i)<=150
%     i=i+1;
% end
% f_de=f(i:end);
% pha_de=pha(i:end);
% pha_de=pha_de+180;
numall=[1.047603136876463e+04,1.448982289723173e+07,3.226031751283106e+11,4.319233261619231e+14,2.468698878125949e+18,3.117787478804216e+21,5.665787831115787e+24,6.440644252326774e+27,8.797489224327780e+29];
denall=[1,1432.68106750884,32695815.2778334,39658831335.7506,266653970427955,2.77396164283908e+17,6.27333211446067e+20,5.52665386002603e+23,8.20782455558356e+25,6.39948232647450e+26,2.49320314947804e+27];
zpk(tf(numall,denall))
hh=freqs(numall,denall,2*pi*f);
hh_abs=abs(hh);
hh_abs_log=20*log10(hh_abs);
fh2=angle(hh)/pi*180;
xita=-0.43*f;
pha_de=pha-xita;
figure;
% mag_ratelog=20*log10(amp);
mag_ratelog=amp;
subplot(2,1,1)
semilogx(f,mag_ratelog);grid on;zoom on;hold on;
semilogx(f,hh_abs_log);
title('辨识和实测结果对比');
ylabel('amplitude(dB)');
legend('实测','辨识')
subplot(2,1,2)
semilogx(f,pha_de);grid on;zoom on;hold on;
len=length(fh2);
for i=1:len
    if fh2(i)>0
        fh2(i)=fh2(i)-360;
    end
end
semilogx(f,fh2);
ylabel('phase(deg)');
xlabel('f(Hz)');
% h=freqs(1.118e04,[1 8.013 32.1],2*pi*f);
% h_abs=abs(h);
% h_abs_log=20*log10(h_abs);
% f2=angle(h)/pi*180;
% amp2_log=mag_ratelog-h_abs_log;
% amp2=10.^(amp2_log/20);
% pha2=pha_de-f2;
% figure;
% subplot(2,1,1)
% semilogx(f,amp2_log);grid on;zoom on;
% subplot(2,1,2)
% semilogx(f,pha2);grid on;zoom on;
% result2(:,1)=f;
% result2(:,2)=amp2;
% result2(:,3)=pha2;
% 
% % num3=[0.7127 86.7 7.123e06 4.834e08 1.73e13];
% % den3=[1 200.2 1.053e07 9.939e08 2.583e13];
num1=1.118e04;
den1=[1 8.013 32.1];
num3=[0.851670908767285,1158.75867498791,8653485.93797918,11044783600.0690,22160120966527.2,2.54101217132068e+16,3.47137207637375e+18];
den3=[1,1.187602565346756e+03,1.095461167010685e+07,1.132796885612471e+10,2.869488561040501e+13,2.549344855538124e+16,3.621274603295020e+18];
h3=freqs(num3,den3,2*pi*f);
h_abs3=abs(h3);
h_abs_log3=20*log10(h_abs3);
f3=angle(h3)/pi*180;
amp3_log=amp2_log-h_abs_log3;
amp3=10.^(amp3_log/20);
pha3=pha2-f3;
figure;
subplot(2,1,1)
semilogx(f,amp3_log);grid on;zoom on;
subplot(2,1,2)
semilogx(f,pha3);grid on;zoom on;
% result3(:,1)=f;
% result3(:,2)=amp3;
% result3(:,3)=pha3;
%最后2阶
num4=[1.100229217172846,24.831668651512500,2.266813415976057e+07];
den4=[1,2.370655021620816e+02,2.144821604397867e+07];
G1=tf(num1,den1);
G2=tf(num3,den3);
G3=tf(num4,den4);
Ga=G1*G2*G3

%200Hz以前 原始数据和辨识的二阶环节进行对比
data=xlsread('G:\study\GraduationThesis\dataOfSine\Axis1_DAC_ENC_SweepSine_29_Jan_2018_15_58_51.xlsx');%X轴开环
f=data(:,1);
amp=data(:,2);
amp=20*log10(amp);
pha=data(:,3);
delayxita=-0.43*f;
figure
semilogx(f,pha);
grid on
hold on
semilogx(f,pha-delayxita)
title('去纯滞后环节的相频图')
xlabel('f(Hz)')
ylabel('phase(deg)')
legend('原始数据','处理后数据')
set(gca,'ylim',[-620,0])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dpha=pha-delayxita;
h=freqs(1.118e04,[1 8.013 32.1],2*pi*f);
h_abs=abs(h);
h_abs_log=20*log10(h_abs);
f2=angle(h)/pi*180;
amp2_log=amp-h_abs_log;
% amp2=10.^(amp2_log/20);
pha2=dpha-f2;
figure;
subplot(2,1,1)
semilogx(f,amp2_log);grid on;zoom on;
title('去理想二阶模型')
ylabel('amplitude（dB）')
subplot(2,1,2)
semilogx(f,pha2);grid on;zoom on;
ylabel('phase(deg)')
xlabel('f(Hz)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h1=freqs([0.9067,210,9.034e6,1.106e9,2.187e13],[1,258.2,1.054e7,1.323e9,2.575e13],2*pi*f);
h_abs1=abs(h1);
h_abs_log1=20*log10(h_abs1);
f21=angle(h1)/pi*180;
amp2_log1=amp2_log-h_abs_log1;
% amp2=10.^(amp2_log/20);
pha22=pha2-f21;
figure;
subplot(2,1,1)
semilogx(f,amp2_log1);grid on;zoom on;
title('去四阶谐振模型')
ylabel('amplitude（dB）')
subplot(2,1,2)
semilogx(f,pha22);grid on;zoom on;
ylabel('phase(deg)')
xlabel('f(Hz)')








i=1;
while f(i)<200
    i=i+1;
end
f200=f(1:i);
amp200=amp(1:i);
pha200=pha_de(1:i);
num1=1.118e04;
den1=[1 8.013 32.1];
hh=freqs(num1,den1,2*pi*f200);
hh_abs=abs(hh);
hh_abs_log=20*log10(hh_abs);
fh2=angle(hh)/pi*180;

figure
subplot(2,1,1)
semilogx(f200,20*log10(amp200));
hold on
grid on
semilogx(f200,hh_abs_log);
legend('原始数据','理想二阶')
ylabel('幅值比（dB）')
title('辨识出的二阶系统')
set(gca,'xlim',[1 200])

subplot(2,1,2)
semilogx(f200,pha200);

hold on
grid on
semilogx(f200,fh2);
set(gca,'xlim',[1 200])
xlabel('频率（Hz）')
ylabel('相位差（deg）')



