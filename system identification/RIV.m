% ���Ƹ������������в�����ʶ
clear;clc;
load('uy1.mat');
n=2;                            %ϵͳ����
MAXN=500;                       %��������
t=1:MAXN;                       %ʱ���ʼ��
P=100^2*diag([1 1 1 1]);        %P���ʼ��
theta=zeros(4,MAXN);            %��ʶ�����ʼ��
%ǰ50��ʹ�õ�����С���˷����в�����ʶ
for i=2:49
    Psi=[-y(i) -y(i-1) u(i) u(i-1)]';
    K=P*Psi*inv(1+Psi'*P*Psi);
    P=P-K*Psi'*P;
    theta(:,i+1)=theta(:,i)+K*(y(i+1)-Psi'*theta(:,i));
end
%50���Ժ�ʹ�õ��Ƹ���������(Tallyԭ��)���в�����ʶ
for i=50:MAXN-1
    Psi=[-y(i) -y(i-1) u(i) u(i-1)]';
    z=[-y(i-2) -y(i-3) u(i) u(i-1)]';
    K=P*z*inv(1+Psi'*P*Psi);
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




