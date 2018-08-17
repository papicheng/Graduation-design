%递阶辨识
%一下程序是分节运行的
data=xlsread('G:\study\GraduationThesis\dataOfSine\Axis1_DAC_ENC_SweepSine_29_Jan_2018_15_58_51.xlsx');%X轴开环
f=data(:,1);
amp_log=20*log10(data(:,2));
ang_deg=data(:,3);
f=1:1000;
T=0.00025;
w=2*pi*f;

%采样保持特性
G_jw=(1-exp(-T*(1j*w)))./(T*1j*w);
amp_delay=abs(G_jw);
amp_delay_log=20*log10(amp_delay);
xita_delay=angle(G_jw)*180/pi;
%采样保持特性
G_jw1=(1-exp(-T*(1j*w)))./(1j*w);
amp_delay1=abs(G_jw1);
amp_delay_log1=20*log10(amp_delay1);
xita_delay1=angle(G_jw1)*180/pi;
figure;
subplot(2,1,1)
semilogx(f,amp_delay_log);grid on;hold on;
semilogx(f,amp_delay_log1)
legend('T','NT')
subplot(2,1,2)
semilogx(f,xita_delay);grid on;hold on;
semilogx(f,xita_delay1)



%去除采样保持特性
amp_log_deDelay=amp_log-amp_delay_log;
ang_deg_deDelay=ang_deg-xita_delay;
%未处理数据
figure;
subplot(2,1,1);
semilogx(f,amp_log);grid on;hold on;
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
title('FFT得到的幅频图')
subplot(2,1,2);
semilogx(f,ang_deg);grid on;hold on;
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('FFT得到的相频图')
% 
figure;
subplot(2,1,1);
semilogx(f,amp_log);grid on;zoom on;hold on;
semilogx(f,amp_log_deDelay);
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
title('去采样保持特性幅频图')
legend('原始数据','处理后数据')
subplot(2,1,2);
semilogx(f,ang_deg);grid on;zoom on;hold on;
semilogx(f,ang_deg_deDelay);
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('去采样保持特性相频图')
legend('原始数据','处理后数据')

%相频纯滞后校正
len=length(amp_log);
expDelay=ang_deg_deDelay(51:end)+180;
expF=f(51:end);

ang_deg_deDelay_deExp=ang_deg_deDelay+0.3783*f;

figure;
semilogx(f,ang_deg_deDelay);grid on;zoom on;hold on;
semilogx(f,ang_deg_deDelay_deExp);
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('去纯滞后环节的相频图')
legend('原始数据','处理后数据')

getIdeal_f=f(2:55);%2-200hz
getIdeal_amp=power(10,(amp_log_deDelay(2:55)/20));
getIdeal_ang=ang_deg_deDelay_deExp(2:55);
getIdeal_ang(32:end)=-179;
a=getIdeal_f;b=getIdeal_amp;c=getIdeal_ang;
%理想模型
idealMode_num=1.181353832476971e+04;
idealMode_den=[1,5.252912405834365,2.324631074506078e-09];
% figure;
% bode(idealMode_num,idealMode_den);grid on;zoom on;

% G_jw_ideal=idealMode_num./((1j*w).^2+5.252912405834365.*1j.*w+2.324631074506078e-09);
G_jw_ideal=1.118e04./((1j*w).^2+8.013.*1j.*w+32.1);
ideal_logamp=20*log10(abs(G_jw_ideal));
ideal_ang=angle(G_jw_ideal)/pi*180;
figure;
subplot(2,1,1)
semilogx(f,amp_log_deDelay);grid on;zoom on;hold on;
semilogx(f,ideal_logamp);
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
title('幅频图')
legend('完全处理数据','理想二阶模型')
subplot(2,1,2)
semilogx(f,ang_deg_deDelay_deExp);grid on;zoom on;hold on;
semilogx(f,ideal_ang);
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('相频图')
legend('完全处理数据','理想二阶模型')

%去除理想模型
% ang_deg_deDelay_deExp(1)=-98.34;ang_deg_deDelay_deExp(2)=-141.3;
logamp_deIdeal=amp_log_deDelay-ideal_logamp;
amp_deIdeal=power(10,(logamp_deIdeal/20));
ang_deIdeal=ang_deg_deDelay_deExp-ideal_ang;
figure;
subplot(2,1,1)
semilogx(f,logamp_deIdeal);grid on;zoom on;hold on;
amp_log_deDelay1=amp_log_deDelay;
amp_log_deDelay1(1)=46.84;
logamp_deIdeal1=amp_log_deDelay1-ideal_logamp;
semilogx(f,logamp_deIdeal1);
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
legend('未处理数据','低频修正数据')
title('去理想模型的幅频图')
subplot(2,1,2)
semilogx(f,ang_deIdeal);grid on;zoom on;hold on;
ang_deg_deDelay_deExp1=ang_deg_deDelay_deExp;
ang_deg_deDelay_deExp1(1:8)=ideal_ang(1:8);
ang_deIdeal1=ang_deg_deDelay_deExp1-ideal_ang;
semilogx(f,ang_deIdeal1);
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('去理想模型的相频图')

%去1-400HZ
% denum1_amp=amp_deIdeal(1:82);
% denum1_ang=ang_deIdeal(1:82);
% denum1_f=f(1:82);
%去310-521HZ
% denum1_amp=amp_deIdeal(73:94);
% denum1_ang=ang_deIdeal(73:94);
% denum1_f=f(73:94);
amp_deIdeal1=power(10,(logamp_deIdeal1/20));
% denum1_amp=amp_deIdeal(1:94);
% denum1_ang=ang_deIdeal(1:94);
% denum1_f=f(1:94);
denum1_amp=amp_deIdeal1;
denum1_ang=ang_deIdeal1;
denum1_f=f;


num1=[0.906664566197237,2.099667423362517e+02,9.034404568335121e+06,1.105868472252670e+09,2.186597854144275e+13];
den1=[1,2.581865295536808e+02,1.054341949561985e+07,1.322911161087511e+09,2.574601974931121e+13];
G_jw1=(0.906664566197237.*(1j.*w).^4+2.099667423362517e+02.*(1j.*w).^3+9.034404568335121e+06.*(1j.*w).^2+1.105868472252670e+09.*(1j.*w)+2.186597854144275e+13)./...
    ((1j.*w).^4+2.581865295536808e+02.*(1j.*w).^3+1.054341949561985e+07.*(1j.*w).^2+1.322911161087511e+09.*(1j.*w)+2.574601974931121e+13);
logamp1=20*log10(abs(G_jw1));
ang1=angle(G_jw1)/pi*180;

num1_6=[1.118087959562797,8.184543177247131e+03,2.089293910120685e+07,8.248223759909747e+10,1.186534841382474e+14,2.023387772816832e+17,2.089288323733947e+20];
den1_6=[1,9.486886859422950e+03,2.063524557501642e+07,1.014181927631760e+11,1.216950984343032e+14,2.538537025913004e+17,2.120825875380282e+20];
G_jw1_6=(1.118087959562797.*(1j.*w).^6+8.184543177247131e+03.*(1j.*w).^5+2.089293910120685e+07.*(1j.*w).^4+8.248223759909747e+10.*(1j.*w).^3+1.186534841382474e+14.*(1j.*w).^2+2.023387772816832e+17.*(1j.*w)+2.089288323733947e+20)./...
    (1.*(1j.*w).^6+9.486886859422950e+03.*(1j.*w).^5+2.063524557501642e+07.*(1j.*w).^4+1.014181927631760e+11.*(1j.*w).^3+1.216950984343032e+14.*(1j.*w).^2+2.538537025913004e+17.*(1j.*w)+2.120825875380282e+20);
logamp1_6=20*log10(abs(G_jw1_6));
ang1_6=angle(G_jw1_6)/pi*180;
figure;
subplot(2,1,1)
semilogx(f,logamp_deIdeal1);grid on;hold on;
semilogx(f,logamp1);
semilogx(f,logamp1_6);
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
legend('原始数据','4阶谐振','6阶谐振')
title('幅频图')
subplot(2,1,2)
semilogx(f,ang_deIdeal1);grid on;hold on;
semilogx(f,ang1);
semilogx(f,ang1_6);xlabel('频率（Hz）')
ylabel('相位差（°）');
title('相频图')


%n=4
num_4=[0.906664566197237,2.099667423362517e+02,9.034404568335121e+06,1.105868472252670e+09,2.186597854144275e+13];
den_4=[1,2.581865295536808e+02,1.054341949561985e+07,1.322911161087511e+09,2.574601974931121e+13];
figure;bode(num_4,den_4);grid on;
hold on;
bode(num1_6,den1_6);
legend('4阶','6阶')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%去除 n=6
logamp2_6=logamp_deIdeal1-logamp1_6;
ang2_6=ang_deIdeal1-ang1_6;
f=data(:,1);
w=2*pi*f;
smoothed_log2_6=[logamp2_6(1:67);logamp2_6(95:end)];
smoothed_log2_6(1:67)=0;
smoothed_ang2_6=[ang2_6(1:67);ang2_6(95:end)];
smoothed_ang2_6(1:31)=0;
smoothed_f2_6=[f(1:67);f(95:end)];
smoothed_amp2_6=power(10,(smoothed_log2_6/20));


figure;
subplot(2,1,1)
semilogx(f,logamp2_6);grid on;zoom on;hold on;
semilogx(smoothed_f2_6,smoothed_log2_6);
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
legend('处理前','处理后')
title('去第一段6阶谐振的幅频图')
subplot(2,1,2)
semilogx(f,ang2_6);grid on;zoom on;hold on;
semilogx(smoothed_f2_6,smoothed_ang2_6);
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('去第一段6阶谐振的相频图')

%最后一个二阶模型
num6_2=[1.072130036820220,44.712210975087714,2.205813173980496e+07];
den6_2=[1,1.643197434672051e+02,2.146813445136048e+07];

G_jw6_2=(1.072130036820220.*(1j.*w).^2+44.712210975087714.*(1j.*w)+2.205813173980496e+07)./...
    (1.*(1j.*w).^2+1.643197434672051e+02.*(1j.*w)+2.146813445136048e+07);
logamp6_2=20*log10(abs(G_jw6_2));
ang6_2=angle(G_jw6_2)/pi*180;
figure;
subplot(2,1,1)
semilogx(smoothed_f2_6,smoothed_log2_6);grid on;hold on;
semilogx(f,logamp6_2)
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
legend('原始数据','辨识结果')
title('幅频图')
subplot(2,1,2)
semilogx(smoothed_f2_6,smoothed_ang2_6);grid on;hold on;
semilogx(f,ang6_2)
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('相频图')
%最终效果
ff=0.1:0.01:2000;
w=2*pi*ff;
G_jw_ideal=1.118e04./((1j*w).^2+8.013.*1j.*w+32.1);

G_jw1_6=(1.118087959562797.*(1j.*w).^6+8.184543177247131e+03.*(1j.*w).^5+2.089293910120685e+07.*(1j.*w).^4+8.248223759909747e+10.*(1j.*w).^3+1.186534841382474e+14.*(1j.*w).^2+2.023387772816832e+17.*(1j.*w)+2.089288323733947e+20)./...
    (1.*(1j.*w).^6+9.486886859422950e+03.*(1j.*w).^5+2.063524557501642e+07.*(1j.*w).^4+1.014181927631760e+11.*(1j.*w).^3+1.216950984343032e+14.*(1j.*w).^2+2.538537025913004e+17.*(1j.*w)+2.120825875380282e+20);

G_jw6_2=(1.072130036820220.*(1j.*w).^2+44.712210975087714.*(1j.*w)+2.205813173980496e+07)./...
    (1.*(1j.*w).^2+1.643197434672051e+02.*(1j.*w)+2.146813445136048e+07);
Gw6=G_jw1_6.*G_jw6_2.*G_jw_ideal;
logamp6=20*log10(abs(Gw6));
ang6=angle(Gw6)/pi*180;
lon=length(ang6);
for i=1:lon
    if ang6(i)>0
        ang6(i)=ang6(i)-360;
    end
end

figure;
subplot(2,1,1)
semilogx(f,amp_log);grid on; hold on;
semilogx(ff,logamp6);
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
legend('测量结果','辨识结果')
title('幅频图')
subplot(2,1,2)
semilogx(f,ang_deg_deDelay_deExp);grid on;hold on;
semilogx(ff,ang6);
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('相频图')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%去除  n=4
logamp2=logamp_deIdeal1-logamp1;
ang2=ang_deIdeal1-ang1;
smoothed_log2=[logamp2(1:54);logamp2(93:end)];
smoothed_ang2=[ang2(1:54);ang2(93:end)];
smoothed_f2=[f(1:54);f(93:end)];

figure;
subplot(2,1,1)
semilogx(f,logamp2);grid on;zoom on;hold on;
semilogx(smoothed_f2,smoothed_log2);
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
legend('处理前','处理后')
title('去第一段4阶谐振的幅频图')
subplot(2,1,2)
semilogx(f,ang2);grid on;zoom on;hold on;
semilogx(smoothed_f2,smoothed_ang2);
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('去第一段4阶谐振的相频图')

smoothed_amp2=power(10,(smoothed_log2/20));
%最后一段2阶谐振
num4_2=[1.185381652824216,28.854826080530785,2.439423798159570e+07];
den4_2=[1,2.034300880700634e+02,2.142097586407810e+07];
G_jw4_2=(1.185381652824216.*(1j.*w).^2+28.854826080530785.*(1j.*w)+2.439423798159570e+07)./...
    (1.*(1j.*w).^2+2.034300880700634e+02.*(1j.*w)+2.142097586407810e+07);
logamp4_2=20*log10(abs(G_jw4_2));
ang4_2=angle(G_jw4_2)/pi*180;

figure;
subplot(2,1,1)
semilogx(smoothed_f2,smoothed_log2);grid on;hold on;
semilogx(f,logamp4_2)
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
legend('原始数据','辨识结果')
title('幅频图')
subplot(2,1,2)
semilogx(smoothed_f2,smoothed_ang2);grid on;hold on;
semilogx(f,ang4_2)
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('相频图')
%最终效果
ff=1:0.5:1000;
w=2*pi*ff;
G_jw_ideal=1.118e04./((1j*w).^2+8.013.*1j.*w+32.1);

G_jw1=(0.906664566197237.*(1j.*w).^4+2.099667423362517e+02.*(1j.*w).^3+9.034404568335121e+06.*(1j.*w).^2+1.105868472252670e+09.*(1j.*w)+2.186597854144275e+13)./...
    ((1j.*w).^4+2.581865295536808e+02.*(1j.*w).^3+1.054341949561985e+07.*(1j.*w).^2+1.322911161087511e+09.*(1j.*w)+2.574601974931121e+13);

G_jw4_2=(1.185381652824216.*(1j.*w).^2+28.854826080530785.*(1j.*w)+2.439423798159570e+07)./...
    (1.*(1j.*w).^2+2.034300880700634e+02.*(1j.*w)+2.142097586407810e+07);
Gw=G_jw4_2.*G_jw1.*G_jw_ideal;
logamp=20*log10(abs(Gw));
ang=angle(Gw)/pi*180;
lon=length(ang);
for i=1:lon
    if ang(i)>0
        ang(i)=ang(i)-360;
    end
end

figure;
subplot(2,1,1)
semilogx(f,amp_log);grid on; hold on;
semilogx(ff,logamp);
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
legend('测量结果','辨识结果')
title('幅频图')
subplot(2,1,2)
semilogx(f,ang_deg_deDelay_deExp);grid on;hold on;
semilogx(ff,ang);
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('相频图')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ff=1:0.5:1000;
w=2*pi*ff;
s=1j.*w;
%2-28辨识
% G=(11180.*(0.9067.*s.^4+210.*s.^3+9.034e6.*s.^2+1.106e9.*s+2.187e13).*(1.185.*s.^2+28.85.*s+2.439e7))./...
%     ((s.^2+8.013.*s+32.1).*(s.^4+258.2.*s.^3+1.054e7.*s.^2+1.323e9.*s+2.575e13).*(s.^2+203.4.*s+2.142e7));
%后2阶使用年前辨识
G=(11180.*(0.9067.*s.^4+210.*s.^3+9.034e6.*s.^2+1.106e9.*s+2.187e13).*(1.1.*s.^2+24.832.*s+2.267e7))./...
    ((s.^2+8.013.*s+32.1).*(s.^4+258.2.*s.^3+1.054e7.*s.^2+1.323e9.*s+2.575e13).*(s.^2+237.0656.*s+2.145e7));

log=20*log10(abs(G));
an=angle(G)/pi*180;
lo=length(an);
for i=1:lo
    if an(i)>0
        an(i)=an(i)-360;
    end
end
figure;
subplot(2,1,1)
semilogx(f,amp_log);grid on; hold on;
semilogx(ff,log);
xlabel('频率（Hz）')
ylabel('幅值比（dB）');
legend('测量结果','辨识结果')
title('幅频图')
subplot(2,1,2)
semilogx(f,ang_deg_deDelay_deExp);grid on;hold on;
semilogx(ff,an);
xlabel('频率（Hz）')
ylabel('相位差（°）');
title('相频图')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%
figure;
subplot(2,1,1)
semilogx(f,amp_log);grid on; hold on;
semilogx(ff,logamp);
semilogx(ff,logamp6);

xlabel('频率（Hz）')
ylabel('幅值比（dB）');
legend('测量结果','2-4-2模型','2-6-2模型')
title('幅频图')
subplot(2,1,2)
semilogx(f,ang_deg_deDelay_deExp);grid on;hold on;
semilogx(ff,ang);
semilogx(ff,ang6);

xlabel('频率（Hz）')
ylabel('相位差（°）');
title('相频图')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
bode(11180,[1,8.013,32.1]);grid on;hold on;
% bode(3693,[1,14.91,3.759])
bode(1827,[1,11.85,1.5])
legend('频域','时域')

inputlen=length(m);
t=(0:(inputlen-1))/4000;
t=t';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%