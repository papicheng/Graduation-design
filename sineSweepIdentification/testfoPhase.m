clc
close all
clear
fs=1000;
t=0:0.001:9.999;
len=length(t);
df=fs/len;
A1=10;A2=20;f0=30;xita1=0;xita2=-300;
x1=A1*sin(2*pi*f0*t-xita1/180*pi);
x2=A2*sin(2*pi*f0*t+xita2/180*pi);
x1fft=fft(x1);
x2fft=fft(x2);
fnum=f0/df+1;
mag1=abs(x1fft(fnum))/(len/2);
mag2=abs(x2fft(fnum))/(len/2);
% a1=real(x1fft(fnum));b1=imag(x1fft(fnum));
% a2=real(x2fft(fnum));b2=imag(x2fft(fnum));
% p1=atan2(a1,b1)/pi*180;
% p2=atan2(a2,b2)/pi*180;
p1=angle(x1fft(fnum));
p2=angle(x2fft(fnum));
jiao=(p2-p1)/pi*180;