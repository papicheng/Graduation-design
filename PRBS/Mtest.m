clc
close all
clear

data=load('Prbs15_1_0.txt');
M=data;
% M=M(1:4000);
len=length(M);
% Np=4000;
Np=len;
Fs=4000;
Mfft=fft(M);
% f = Fs*(0:(Np/2))/Np;
% Mmag2 = abs(Mfft/Np);
% Mmag1 = Mmag2(1:Np/2+1);%зЂвт+1
% Mmag1(2:end-1) = 2*Mmag1(2:end-1);

figure;
stairs(M);grid on;
figure;
% stem(f,Mmag1);hold on;
stem(abs(Mfft));
