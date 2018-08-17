% ������С���˷����в�����ʶ
clear;clc;close all

load('uy1.mat');
n=2;                            %ϵͳ����
MAXN=500;                       %��������
t=1:MAXN;                       %ʱ���ʼ��
P=100^2*diag([1 1 1 1]);        %P���ʼ��
theta=zeros(4,MAXN);            %��ʶ�����ʼ��
%���Ʊ�ʶ
for i=2:MAXN-1
    Psi=[-y(i) -y(i-1) u(i) u(i-1)]';
    K=P*Psi*inv(1+Psi'*P*Psi);
    P=P-K*Psi'*P;
    theta(:,i+1)=theta(:,i)+K*(y(i+1)-Psi'*theta(:,i));
end
%��ʶ�����ͼ
figure (1)
plot(t,theta(1,:))
figure (2)
plot(t,theta(2,:))
figure (3)
plot(t,theta(3,:))
figure (4)
plot(t,theta(4,:))

