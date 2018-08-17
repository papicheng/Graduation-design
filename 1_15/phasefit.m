clc
close all
% num=xlsread('G:\study\GraduationThesis\dataOfSine\Axis1_DAC_ENC_SweepSine_15_Jan_2018_17_29_06.xlsx');
num=xlsread('G:\study\GraduationThesis\dataOfSine\X-Y-Table-ËÙ¶È±Õ»·\Axis1_RefVel_EncVel_SweepSine_12_Jan_2018_10_52_42.xlsx');

fn=num(:,1);
amp=num(:,2);
phase=num(:,3);
% amp(1)=993.3546;
% phase(1)=-60;
amplog=20*log10(amp);
T=0.001;


len=length(fn);
phase2=phase;
for i=3:len
    if abs(phase(i)-phase(i-1))>30
        phase2(i)=2*phase(i-1)-phase(i-2);
    end
end
phase3=phase2;
phase3=phase3-relay;
figure;
semilogx(fn,phase);hold on;grid on; zoom on;
% semilogx(fn,phase2);
% semilogx(fn,phase3);

p=polyfit(log10(fn),phase,10);
x2=1:0.1:1000;
yp2=polyval(p,log10(x2));
relay=-360*T*x2;
% yp2=yp2-relay;
semilogx(x2,yp2);
figure;
semilogx(fn,amplog);hold on;grid on; zoom on;
% semilogx(fn,phase2);
% semilogx(fn,phase3);

p=polyfit(log10(fn),amplog,4);
ya2=polyval(p,log10(x2));
semilogx(x2,ya2);
amp2=power(10,ya2/20);
n=3;
for m=0:n-1
    m
x2=2*pi*x2;
fn=fn*2*pi;
[b,a]=invfreqs(amp.*exp(1j*phase),fn,m,n);
figure;
freqs(b,a);
end