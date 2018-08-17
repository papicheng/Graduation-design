clc;
clear;
close all;

Fs=4000;
N=Fs*2;
data=load('G:\study\GraduationThesis\dataOfSine\Prbs\Axis1_DAC_ENC_Prbs_Gain_200_065726.txt');
M1=data(:,2);
z1=data(:,1);
mi=1;
while M1(mi)==0
    mi=mi+1;
end
M1_len=length(M1);
while M1(M1_len)==0
    M1_len=M1_len-1;
end
% M=M1(mi:mi+N-1);
% z=z1(mi:mi+N-1);
M=M1(mi:M1_len);
% M(4000)=0;
% Mm1=(M-min(M))/(max(M)-min(M));
% zm1=(z-min(z))/(max(z)-min(z));
% 
% Mm2=(M-mean(M))/std(M,0);
% zm2=(z-mean(z))/std(z,0);

Mfft=fft(M);
% zfft=fft(z);
% Mm1fft=fft(Mm1);
% zm1fft=fft(zm1);
% Mm2fft=fft(Mm2);
% zm2fft=fft(zm2);

Np=length(M)
f = Fs*(0:(Np/2))/Np;
Mmag2 = abs(Mfft/Np);
Mmag1 = Mmag2(1:Np/2+1);%注意+1
Mmag1(2:end-1) = 2*Mmag1(2:end-1);

% zmag2 = abs(zfft/Np);
% zmag1 = zmag2(1:Np/2+1);%注意+1
% zmag1(2:end-1) = 2*zmag1(2:end-1);

% Mm1mag2 = abs(Mm1fft/Np);
% Mm1mag1 = Mm1mag2(1:Np/2+1);%注意+1
% Mm1mag1(2:end-1) = 2*Mm1mag1(2:end-1);
% 
% zm1mag2 = abs(zm1fft/Np);
% zm1mag1 = zm1mag2(1:Np/2+1);%注意+1
% zm1mag1(2:end-1) = 2*zm1mag1(2:end-1);
% 
% 
% Mm2mag2 = abs(Mm2fft/Np);
% Mm2mag1 = Mm2mag2(1:Np/2+1);%注意+1
% Mm2mag1(2:end-1) = 2*Mm2mag1(2:end-1);
% 
% zm2mag2 = abs(zm2fft/Np);
% zm2mag1 = zm2mag2(1:Np/2+1);%注意+1
% zm2mag1(2:end-1) = 2*zm2mag1(2:end-1);

% r1=zmag1(100)/Mmag1(100);
% r2=zm1mag1(100)/Mm1mag1(100);
% r3=zm2mag1(100)/Mm2mag1(100);
% figure;
% stairs(M/1000);grid on;
% hold on;
% stairs(Mm1);hold on;
% stairs(Mm2);
% legend('M','Mm1','Mm2');
figure;
stem(Mmag1);hold on;
% stem(f,Mm1mag1);hold on;
% stem(f,Mm2mag1);
% legend('Mmag','Mm1mag','Mm2mag');title('m fft mag');
% figure;
% stem(f,zmag1);hold on;
% stem(f,zm1mag1);hold on;
% stem(f,zm2mag1);
% legend('zmag','zm1mag','zm2mag');