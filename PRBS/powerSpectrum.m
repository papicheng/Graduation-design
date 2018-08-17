clear;
clc
close all

Fs=4000; %����Ƶ��
% n=0:1/Fs:1;
% %������������������
% xn=cos(2*pi*40*n)+3*cos(2*pi*100*n)+randn(size(n));

data=load('Axis1_RefPos_EncPos_Prbs_Gain_1000_040248.txt');
xn=data

window=boxcar(length(xn)); %���δ�
nfft=1024;
[Pxx,f]=periodogram(xn,window,nfft,Fs); %ֱ�ӷ�
plot(f,10*log10(Pxx));