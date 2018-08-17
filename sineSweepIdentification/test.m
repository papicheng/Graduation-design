% % clc
% % clear
% % close all
% % data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f51_Gain_1000_043150.txt');
% % x=[0:length(data(:,1))-1]*(1/4000);
% % figure;
% % plotyy(x,data(:,1),x,data(:,2));zoom on;grid on;
clc
clear 
close all
fs=4000;
dt=1/fs;
f0=50;
N=4000;
t=(0:10000)*dt;
fr=rand(1,4000);
fr(1:400)=fr(1:400)*100;
fr(401:700)=fr(401:700)*300;
fr(700:900)=fr(700:900)*500;
x=sin(50*2*pi*t+45/180*pi)+sin(1110*2*pi*t+45/180*pi)+4.*t.*t.*t.*t-5.*t.*t+5*exp(t)+sin(1111*2*pi*t)+4*sin(1112*2*pi*t)+sin(1113*2*pi*t);
fi=randi(1000,1,4000);
for i=1:4000
    for j=1:10001
    x(i)=x(i)+sin(fi(i)*2*pi*t(j))+sin(fr(i)*2*pi*t(j));
    end
end

x=[0 x(1:end-1)];
x1=x(1:N);
% x1=x1-mean(x1);
figure;
plot(t,x);grid on;
x1fft=fft(x1);
mag=abs(x1fft/N);
mag(2:N/2+1)=mag(2:N/2+1)*2;
f=(1:N/2)*(fs/N);
figure;
plot(f,mag(2:N/2+1),'*');grid on;
% 
% % clear;
% % fs=4000;%fs为采样频率;?
% % t=1/fs:1/fs:2;
% % x1=20*sin(5*pi*t);
% % subplot(4,1,1);plot(x1);title('原始信号')
% % x2=t.*t.*t+2.*t.*t-t-2;
% % x2=x2/17;
% % subplot(4,1,2);plot(x2);title('趋势项')
% % x=x1+x2;
% % subplot(4,1,3);plot(t,x);title('原始信号＋趋势项')
% % m=2;
% % a=polyfit(t,x,m);%计算多项式待定系数向量a?
% % b=polyval(a,t);
% % y=x-b;%用x减去多项式系数a生成的趋势项?
% % subplot(4,1,4);plot(t,y,t,b);
% % title('去除趋势项后得到的信号')

% A=[1,4,2,-6,-3,7,-2];
% function [a,b]=sorting(A)
% n = length(A);
% b=1:n;
% for i = 1:n-1
%     for j = i+1:n
%         if A(i)>A(j)
%             temp = A(i);
%             A(i) = A(j);
%             A(j) = temp;
%             te=b(i);
%             b(i)=b(j);
%             b(j)=te;
%         end
%     end
% end
% a=A;
% end
