% 噪声特性分析
clear;clc;
load('uy3.mat');
theta=[1.5;0.8;0.5;0.2];        %参数真值
n=2;                            %系统阶数
N=length(u)-n;                  %矩阵维数
Y=y(n+1:n+N,1);                 %输出矩阵
Phi=zeros(N,2*n);
for i=1:n
    Phi(:,i)=-y(n-i+1:n+N-i,1);
    Phi(:,n+i)=u(n-i+1:n+N-i,1);
end
Y_=Phi*theta;
e=Y_-Y;                         %残差

%波形
figure(1)
plot(1:N,e)


%均值分析
e_mean=mean(e)

%方差分析
e_var=var(e)


%自相关函数分析
C=xcorr(e,'unbiased');
NC=(length(C)+1)/2;
j=1;
for i=-(NC-1):(NC-1)
    C(j)=C(j)/abs(i);
    j=j+1;
end
figure(2)
plot(-(NC-1):(NC-1),C)


%功率谱密度分析
nfft=1024;
cxn=xcorr(e,'unbiased');
CXk=fft(cxn,nfft);
Pxx=abs(CXk);
figure(3)
plot(1:1024,Pxx)
axis([1,1024,0,10])