data=0;in=0;out=0;din=0;dout=0;
data=load('G:\study\GraduationThesis\dataOfSine\Prbs\Axis1_DAC_ENC_Prbs_Gain_200_034741.txt');
in=data(:,2);
out=data(:,1);
len=2^17+5;
in=in(1:len);
out=out(1:len);

din=in(1:end-1);
dout=diff(out);
%画速度的PRBS
t=(0:len-2)*0.00025;
figure;
N=250;
N1=1;
[AX,H1,H2] = plotyy(t(N1:N),din(N1:N),t(N1:N),dout(N1:N),'stairs','plot');
% grid on;zoom on;
legend('输入','输出')
xlabel('采样点数')
ylabel(AX(1),'输入DAC') ;
ylabel(AX(2),'输出速度');
title('开环PRBS输入输出数据')
% set(gca,'xlim',[0,0.06])
set(AX(1),'ylim',[-205,205])
set(AX(2),'ylim',[0,12])

%画开环位置PRBS
figure;
N=2^17-1;
N1=1;
[AX,H1,H2] = plotyy(t(N1:N),in(N1:N),t(N1:N),out(N1:N),'stairs','plot');
% grid on;zoom on;
legend('输入','输出')
xlabel('采样点数')
ylabel(AX(1),'输入DAC') ;
ylabel(AX(2),'输出位置');
title('开环PRBS输入输出数据')
% set(gca,'xlim',[0,0.06])
% set(AX(1),'ylim',[-205,205])
% set(AX(2),'ylim',[0,12])

figure
plot(t(1:5000),dout(1:5000),'k')
grid on
xlabel('时间(s)')
ylabel('速度（脉冲数/s）')
title('开环PRBS输出速度数据')


data=load('G:\study\GraduationThesis\dataOfSine\X-Y-Table-速度闭环\X-Y-Table-X轴速度闭环Prbs\Axis1_RefVel_EncVel_Prbs_Gain_20_112949.txt');
input=data(:,1);
output=data(:,2);
figure
plot(t(1:5000),output(1:5000),'k')
grid on
xlabel('时间(s)')
ylabel('速度（脉冲数/s）')
title('速度环PRBS输出速度数据')
set(gca,'xlim',[0,1.25])
a=diff1ff500.ResponseData;
a=a(:);
b=abs(a);
c=angle(a)*180/pi;


%画开环PRBS位置滤波前后的
%滤波前
prefilter=xlsread('E:\MATLAB\R2016b\bin\sineSweepGUI\1_12\GUI_M\Axis1_DAC_ENC_Prbs_06_May_2018_20_49_19DIFF0.xlsx');
pref=prefilter(:,1);
preamp=prefilter(:,2);
preamp=20*log10(preamp);

%滤波后
filter=xlsread('G:\study\GraduationThesis\dissertationAndMore\论文绘图\开环PRBS位置0次差分_频率_幅值_相位使用的辨识工具箱.xlsx');
f=filter(:,1);
f=f/2/pi;
amp=filter(:,2);
amp=20*log10(amp);
pha=filter(:,3);
figure;
semilogx(pref,preamp);
grid on
hold on;
semilogx(f,amp);
filter=xlsread('E:\MATLAB\R2016b\bin\sineSweepGUI\1_12\GUI_M\Axis1_DAC_ENC_Prbs__Filtered_06_May_2018_20_46_12DIFF0.xlsx');
f=filter(:,1);
amp=filter(:,2);
amp=20*log10(amp);
figure;
semilogx(pref,preamp);
grid on
hold on;
semilogx(f,amp);
xlabel('f(Hz)')
ylabel('amplitude(dB)')
title('开环PRBS输出位置滤波前后')
legend('原始数据','处理数据')
set(gca,'xlim',[0.01,2010])


%开环PRBS滤波前后
speed=xlsread('G:\study\GraduationThesis\dissertationAndMore\论文绘图\开环PRBS速度1次差分_频率_幅值_相位使用的辨识工具箱.xlsx');
sf=speed(:,1);
sf=sf/2/pi;
samp=speed(:,2);
samp=20*log10(samp);
phase_diff=speed(:,3);
w=sf;
plen=length(phase_diff);
for ii=1:plen
    if phase_diff(ii)>0
        if w(ii)<10&&phase_diff(ii)<30
            continue
        end
        phase_diff(ii)=phase_diff(ii)-360;
    end
end
for i0=3:plen
    if ((abs(phase_diff(i0-1)+360) < 50 || ...
            abs(phase_diff(i0 - 2) + 360) < 50 || ...
            abs(phase_diff(i0)-phase_diff(i0-1))>90 ||...
            abs(phase_diff(i0)-phase_diff(i0-2))>90) && ...
            (phase_diff(i0)>-180))...
            ||...
            (abs(phase_diff(i0) - phase_diff(i0 - 1)) > 300 &&...
            (phase_diff(i0) > -360))
        
        phase_diff(i0) = phase_diff(i0) - 360;
        
    end
end
loopflag=5;
while loopflag
    loopflag=loopflag-1;
    for i0=3:plen
        if abs(phase_diff(i0) - phase_diff(i0 - 1)) > 250
            phase_diff(i0) = phase_diff(i0) - 360;
        end
    end
end

%滤波前
% presfilter=xlsread('E:\MATLAB\R2016b\bin\sineSweepGUI\1_12\GUI_M\Axis1_DAC_ENC_Prbs_Diff1_06_May_2018_20_53_11.xlsx');
% presf=presfilter(:,1);
% presamp=presfilter(:,2);
% presamp=20*log10(presamp);

presfilter=xlsread('E:\MATLAB\R2016b\bin\sineSweepGUI\1_12\GUI_M\Axis1_DAC_ENC_SweepSine_diffnum1_06_May_2018_21_14_21.xlsx');
presf=presfilter(:,1);
presamp=presfilter(:,2);
presamp=20*log10(presamp);
prespha=presfilter(:,3);



figure;
subplot(2,1,1)
semilogx(presf,presamp);
grid on
hold on;
semilogx(sf,samp);
ylabel('amplitude(dB)')
title('开环两种输入信号下用速度表示输出的BODE图')
legend('sweepsine','PRBS')
set(gca,'xlim',[0.01,2010])

subplot(2,1,2)
semilogx(presf,prespha);
grid on
hold on;
semilogx(sf,phase_diff);
ylabel('phase(deg)')
set(gca,'xlim',[0.01,2010])
xlabel('f(Hz)')


%开环sine位置
po=xlsread('E:\MATLAB\R2016b\bin\sineSweepGUI\1_12\GUI_M\Axis1_DAC_ENC_SweepSine_diffnum1_06_May_2018_21_14_21.xlsx');
fpo=po(:,1);
amppo=po(:,2);
amppo=20*log10(amppo);
phasepo=po(:,3);
figure;
subplot(2,1,1)
semilogx(fpo,amppo)
grid on
ylabel('amplitude(dB)')
title('开环sweepsine输入下输出位置的BODE图')
subplot(2,1,2)
semilogx(fpo,phasepo)
grid on
ylabel('phase(deg)')
xlabel('f(Hz)')


%速度环PRBS
speedPrbs=load('G:\study\GraduationThesis\dataOfSine\X-Y-Table-速度闭环\X-Y-Table-X轴速度闭环Prbs\Axis1_RefVel_EncVel_Prbs_Gain_20_112949.txt');
speedin=speedPrbs(:,1);
speedout=speedPrbs(:,2);

a=speedff500.ResponseData;
a=a(:);
b=abs(a);
c=angle(a)*180/pi;


speed=xlsread('G:\study\GraduationThesis\dissertationAndMore\论文绘图\速度环PRBS_频率_幅值_相位使用的辨识工具箱.xlsx');
spf=speed(:,1);
spf=spf/2/pi;
spamp=speed(:,2);
spamp=20*log10(spamp);
sppha=speed(:,3);


phase_diff=speed(:,3);
w=spf;
plen=length(phase_diff);
for ii=1:plen
    if phase_diff(ii)>0
        if w(ii)<10&&phase_diff(ii)<30
            continue
        end
        phase_diff(ii)=phase_diff(ii)-360;
    end
end
for i0=3:plen
    if ((abs(phase_diff(i0-1)+360) < 50 || ...
            abs(phase_diff(i0 - 2) + 360) < 50 || ...
            abs(phase_diff(i0)-phase_diff(i0-1))>90 ||...
            abs(phase_diff(i0)-phase_diff(i0-2))>90) && ...
            (phase_diff(i0)>-180))...
            ||...
            (abs(phase_diff(i0) - phase_diff(i0 - 1)) > 300 &&...
            (phase_diff(i0) > -360))
        
        phase_diff(i0) = phase_diff(i0) - 360;
        
    end
end
loopflag=5;
while loopflag
    loopflag=loopflag-1;
    for i0=3:plen
        if abs(phase_diff(i0) - phase_diff(i0 - 1)) > 250
            phase_diff(i0) = phase_diff(i0) - 360;
        end
    end
end

dds=xlsread('G:\study\GraduationThesis\dataOfSine\X-Y-Table-速度闭环\Axis1_RefVel_EncVel_SweepSine_18_Jan_2018_11_10_45.xlsx');
fdds=dds(:,1);
ampdds=dds(:,2);
ampdds=20*log10(ampdds);
phadds=dds(:,3);


figure;
subplot(2,1,1)
semilogx(spf,spamp)
hold on
grid on
semilogx(fdds,ampdds)
ylabel('amplitude(dB)')
title('速度环两种信号输入下的BODE图')
set(gca,'ylim',[-65,1])
set(gca,'xlim',[0.1,2020])
legend('PRBS','sweepsine');

subplot(2,1,2)
semilogx(spf,phase_diff)
grid on
hold on
semilogx(fdds,phadds)
ylabel('phase(deg)')
xlabel('f(Hz)')
set(gca,'ylim',[-1700,20])
set(gca,'xlim',[0.1,2020])
