clc 
clear 
close all
fs=4000;
N=40;
real_f=1500;
t=(1:N)/fs;
x=sin(2*pi*real_f*t);
c=1.3*sin(2*pi*real_f*t+pi/4);
dfin=fs/N;
f_num=round(real_f/dfin)+1;
frealshow=(f_num-1)*dfin;

cthannc=c;%winhann.*
cthannfftc=fft(cthannc);
cthannfftmag=abs(cthannfftc(f_num));

cthannx=x;%winhann.*
cthannfftx=fft(cthannx);
cthannfftmagx=abs(cthannfftx(f_num));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mag_rate=cthannfftmag/cthannfftmagx;%·ùÖµ±È
phase_diff=(angle(cthannfftc(f_num))-angle(cthannfftx(f_num)))*180/pi;
