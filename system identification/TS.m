% ���������в�����ʶ
clear;clc;
load('uy1.mat');
n=2;                            %ϵͳ����
N=length(u)-n;                  %����ά��
% p=6;
% M=4;
p=10;
M=10;
sigma=-p:M;
Nsigma=length(sigma);
Ruu=zeros(Nsigma,1);
Ruy=zeros(Nsigma,1);
S=zeros(Nsigma-n,2*n);
%��һ�� ��غ�����
for i=1:Nsigma
    if sigma(i)<0
        for k=1:n+N+sigma(i)
            Ruu(i)=Ruu(i)+u(k)*u(k-sigma(i));
            Ruy(i)=Ruy(i)+y(k)*u(k-sigma(i));
        end
        Ruu(i)=Ruu(i)/(n+N+sigma(i));
        Ruy(i)=Ruy(i)/(n+N+sigma(i));
    end
    if sigma(i)>=0
        for k=sigma(i)+1:n+N
            Ruu(i)=Ruu(i)+u(k)*u(k-sigma(i));
            Ruy(i)=Ruy(i)+y(k)*u(k-sigma(i));
        end
        Ruu(i)=Ruu(i)/(n+N-sigma(i));
        Ruy(i)=Ruy(i)/(n+N-sigma(i));
    end
end
%�ڶ��� ��С���˷�
Y=Ruy(n+1:Nsigma);
for i=1:n
    S(:,i)=-Ruy(n-i+1:Nsigma-i,1);
    S(:,n+i)=Ruu(n-i+1:Nsigma-i,1);
end
theta=inv(S'*S)*S'*Y      %��ʶ���

    






