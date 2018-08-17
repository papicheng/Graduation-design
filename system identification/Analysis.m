% �������Է���
clear;clc;
load('uy3.mat');
theta=[1.5;0.8;0.5;0.2];        %������ֵ
n=2;                            %ϵͳ����
N=length(u)-n;                  %����ά��
Y=y(n+1:n+N,1);                 %�������
Phi=zeros(N,2*n);
for i=1:n
    Phi(:,i)=-y(n-i+1:n+N-i,1);
    Phi(:,n+i)=u(n-i+1:n+N-i,1);
end
Y_=Phi*theta;
e=Y_-Y;                         %�в�

%����
figure(1)
plot(1:N,e)


%��ֵ����
e_mean=mean(e)

%�������
e_var=var(e)


%����غ�������
C=xcorr(e,'unbiased');
NC=(length(C)+1)/2;
j=1;
for i=-(NC-1):(NC-1)
    C(j)=C(j)/abs(i);
    j=j+1;
end
figure(2)
plot(-(NC-1):(NC-1),C)


%�������ܶȷ���
nfft=1024;
cxn=xcorr(e,'unbiased');
CXk=fft(cxn,nfft);
Pxx=abs(CXk);
figure(3)
plot(1:1024,Pxx)
axis([1,1024,0,10])