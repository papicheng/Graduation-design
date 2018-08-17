clear;
clc
close all

Fs=4000; %采样频率
% n=0:1/Fs:1;
% %产生含有噪声的序列
% xn=cos(2*pi*40*n)+3*cos(2*pi*100*n)+randn(size(n));

data=load('Axis1_RefPos_EncPos_Prbs_Gain_1000_040248.txt');
xn=data

window=boxcar(length(xn)); %矩形窗
nfft=1024;
[Pxx,f]=periodogram(xn,window,nfft,Fs); %直接法
plot(f,10*log10(Pxx));