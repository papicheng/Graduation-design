% ������С���˷����в�����ʶ
clear;clc;
load('uy1.mat');
n=2;                            %ϵͳ����
N=length(u)-n;                  %����ά��
Y=y(n+1:n+N,1);                 %�������
Phi=zeros(N,2*n);
for i=1:n
    Phi(:,i)=-y(n-i+1:n+N-i,1);
    Phi(:,n+i)=u(n-i+1:n+N-i,1);
end
theta=inv(Phi'*Phi)*Phi'*Y      %��ʶ���






