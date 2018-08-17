% clc
% clear 
close all
format long
%{
%X_open
data=xlsread('G:\study\GraduationThesis\dataOfSine\Axis1_DAC_ENC_SweepSine_17_Jan_2018_09_51_42.xlsx');%X轴开环
fn=data(:,1);
amp=data(:,2);
phase=data(:,3);
f=(1:10000)*0.1;
fw=f*2*pi;
% for i=1:1000
%     Gw(i)=2.938/(1j*fw(i)+3.622);
% end
[h,w]=freqs([2.938],[1 3.622],fw);
figure;
subplot(2,1,1);
semilogx(fn,20*log10(amp));grid on;zoom on;hold on;
semilogx(f,20*log10(abs(h)));
subplot(2,1,2);
semilogx(fn,phase);grid on;zoom on;hold on;
semilogx(f,angle(h)/pi*180);
a=angle(h);
%}
% data=xlsread('G:\study\GraduationThesis\dataOfSine\X-Y-Table-速度闭环\Axis1_RefVel_EncVel_SweepSine_18_Jan_2018_11_10_45.xlsx');%X轴开环
data=xlsread('G:\study\GraduationThesis\dataOfSine\Axis1_DAC_ENC_SweepSine_17_Jan_2018_09_51_42.xlsx');%X轴开环
% data=xlsread('G:\study\GraduationThesis\dataOfSine\X-Y-Table-速度闭环\Axis2_RefVel_EncVel_SweepSine_18_Jan_2018_16_52_39.xlsx');%X轴开环

fn=data(:,1);
amp=data(:,2);
phase=data(:,3);
i=1;
while fn(i)<=150
    i=i+1;
    if fn(i)==150
        m=i;
    end
end
% fn=fn(1:i);
% amp=amp(1:i);
% phase=phase(1:i);
% phase(m+1:end)=179.5;
% Kp=0.98998;
% Tw=0.0017395;
% Zeta=0.70009;
% Td=0.000924;

% Kp=0.99495;
% Tw=0.0016554;
% Zeta=0.72553;
% Td=00.00115;

% Kp=0.98036;
% Tw=0.0018624;
% Zeta=0.69687;
% Td=0.0014322;
% Tz=0.00070652;

Kp=0.75845;
Tp1=0.25901;
Td=0.0013;
% num=tf29.Numerator;
% den=tf29.Denominator;
num=tf35.Numerator;
den=tf35.Denominator;

% num=[98.16 5.661e05 6.437e08 3.362e12 1.053e12 -3.378e13];
% den=[1 1.881e05 2.79e07 1.221e12 5.169e12 1.22e13 2.844e13];

% num=[-6.494 3.022e04 -1.503e08 3.379e11 -6.232e14 9.977e17 7.072e19 1.709e21 2.925e23 -1.26e25];
% den=[1 7918 5.162e07 1.163e11 3.044e14 3.856e17 3.201e19 9.001e20 1.227e23 -3.781e24 -1.079e25];
% num=[9159 -3.364e07 1.198e11 -1.866e14 4e17 2.989e19 7.17e20 1.23e23 -5.026e24];
% den=[1 4960 2.817e07 5.826e10 1.431e14 1.544e17 1.337e19 3.719e20 5.122e22 -1.5e24 -4.28e24];
% g=tf(num,conv(den,[1 0]));
% g.OutputDelay=0.0013;
g=tf(num,den);
figure;
bode(g);
zpk(g)
% Kp=0.98673;
% Tw=0.0019744;
% Zeta=0.66214;
% Td=0.00158;
% Tz=0.00083721;
% num=[0.0004283 -0.002747 0.007774 -0.01259 0.0126 -0.007801 0.002767 -0.0004341 0 0 0 0 0 0 0 0 0 0 0];
% den=[1 -9.489 46.08 -155 404.5 -855.4 1486 -2128 2509 -2413 1840 -1027 299.9 129.5 -249.9 191.1 -94.18 31.01 -6.28 0.5959];
% num=wrev(num)
% den=wrev(den)
% dsys = tf( num,den,'Ts',0.00025 ) %系统传递函数z/(z-1),采样时间1
% scsys = d2c( dsys,'tustin') %采用双线性变换 tustin
% zpk(scsys)
% [num1,den1] = tfdata( scsys,'v' );%获得s传函的分子和分母
f=(1:5000)*0.2;
fw=f*2*pi;
% for n=1:5000
% Gw=Kp.*exp(-Td.*1j.*fw)./(1+2.*Zeta.*Tw.*1j.*fw+(Tw.*1j.*fw).^2);
% Gw=Kp.*exp(-Td.*1j.*fw).*(1+Tz.*1j.*fw)./(1+2.*Zeta.*Tw.*1j.*fw+(Tw.*1j.*fw).^2);
% Gw=Kp.*exp(-Td.*1j.*fw)./(1+Tp1.*1j.*fw);
% Gw=(9159.*(1j.*fw).^8 -3.364e07.*(1j.*fw).^7+ 1.198e11.*(1j.*fw).^6 -1.866e14.*(1j.*fw).^5+ 4e17.*(1j.*fw).^4+ 2.989e19.*(1j.*fw).^3+ 7.17e20.*(1j.*fw).^2+1.23e23.*(1j.*fw) -5.026e24)./(1.*(1j.*fw).^10+4960.*(1j.*fw).^9+2.817e07.*(1j.*fw).^8+ 5.826e10.*(1j.*fw).^7+ 1.431e14.*(1j.*fw).^6+ 1.544e17.*(1j.*fw).^5+ 1.337e19.*(1j.*fw).^4+3.719e20.*(1j.*fw).^3+ 5.122e22.*(1j.*fw).^2 -1.5e24.*(1j.*fw) -4.28e24);
Gw=(-6.494.*(1j.*fw).^9+3.022e04.*(1j.*fw).^8 -1.503e08.*(1j.*fw).^7+ 3.379e11.*(1j.*fw).^6 -6.232e14.*(1j.*fw).^5+ 9.977e17.*(1j.*fw).^4+ 7.072e19.*(1j.*fw).^3+ 1.709e21.*(1j.*fw).^2+2.925e23.*(1j.*fw) -1.26e25)./...
    (1.*(1j.*fw).^10+7918.*(1j.*fw).^9+5.162e07.*(1j.*fw).^8+ 1.163e11.*(1j.*fw).^7+ 3.044e14.*(1j.*fw).^6+ 3.856e17.*(1j.*fw).^5+ 3.201e19.*(1j.*fw).^4+9.001e20.*(1j.*fw).^3+ 1.227e23.*(1j.*fw).^2 -3.781e24.*(1j.*fw) -1.079e25);

% figure;
% dbode(num,den,0.00025);
% hold on;
% bode(scsys);
% [h,w]=freqz(num,den,fw);
% end
% [h,w]=freqs([1.845e05],[1 521.5 1.853e05],fw);
% [h,w]=freqs([-205.3 2.734e05],[1 725.8 2.808e05],fw);
% [h,w]=freqs([-7.331e05 1.223e09],[1 4856 3.437e06 1.247e09],fw);
% [h,w]=freqs([2.713e06 -1.084e10 1.316e13],[1 4.421e07 3.38e10 1.341e13],fw);
figure;
subplot(2,1,1);
semilogx(fn,20*log10(amp));grid on;zoom on;hold on;
h=Gw;
Gr=abs(h);
semilogx(f,20*log10(Gr));
subplot(2,1,2);
semilogx(fn,phase);grid on;zoom on;hold on;
a=angle(h)/pi*180;
len=length(a);
for i=1:len
    if a(i)>0
        a(i)=a(i)-360;
    end
end
for i=3:len
    if abs(a(i)-a(i-1))>200
        a(i)=a(i)-360;
    end
end
semilogx(f,a);
figure;
plot(fn,amp);
hold on;grid on;zoom on;
plot(f,Gr);
figure;
plot(fn,phase);
hold on;grid on;zoom on;
plot(f,a);