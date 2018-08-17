% ������Ȼ�����в�����ʶ
clear;clc;
load('uy1.mat');
n=2;                            %ϵͳ����
N=length(u)-n;                  %����ά��
Y=y(n+1:n+N,1);                 %�������
U=u(n+1:n+N,1);                 %�������
Phi(:,1)=-y(n:n+N-1,1);
Phi(:,2)=-y(n-1:n+N-2,1);
Phi(:,3)=u(n:n+N-1,1);
Phi(:,4)=u(n-1:n+N-2,1);
%�Ƚ���һ�λ�����С���˱�ʶ
theta(:,1)=inv(Phi'*Phi)*Phi'*Y;
e(:,1)=Y-Phi*theta(:,1);        %�в�
e=[0;0;e];
theta(5:6,1)=[0;0];
sigma2(1)=e'*e/N;               %����
Phi(:,5)=e(n:n+N-1,1);
Phi(:,6)=e(n-1:n+N-2,1);

for i=2:10000
    i
    PD=zeros(n*3,n+N);
    PJPtheta=0;
    P2=0;
    for k=3:n+N
        PD(1,k)=y(k-1)-theta(5,i-1)*PD(1,k-1)-theta(6,i-1)*PD(1,k-2);
        PD(2,k)=y(k-2)-theta(5,i-1)*PD(2,k-1)-theta(6,i-1)*PD(2,k-2);
        PD(3,k)=-u(k-1)-theta(5,i-1)*PD(3,k-1)-theta(6,i-1)*PD(3,k-2);
        PD(4,k)=-u(k-2)-theta(5,i-1)*PD(4,k-1)-theta(6,i-1)*PD(4,k-2);
        PD(5,k)=-e(k-1)-theta(5,i-1)*PD(5,k-1)-theta(6,i-1)*PD(5,k-2);
        PD(6,k)=-e(k-2)-theta(5,i-1)*PD(6,k-1)-theta(6,i-1)*PD(6,k-2);
        PJPtheta=PJPtheta+e(k)*PD(:,k);
        P2=P2+PD(:,k)*PD(:,k)';
    end
    theta(:,i)=theta(:,i-1)-(P2)^-1*PJPtheta*0.1;%����ϵ��0.1 ʹ�䲨������ô���� ����ʵ������
    e(3:n+N,1)=Y-Phi*theta(:,i);    %�в�
    sigma2(i)=e'*e/N;               %����
    Phi(:,5)=e(n:n+N-1,1);
    Phi(:,6)=e(n-1:n+N-2,1);
    if abs(sigma2(i)-sigma2(i-1))/sigma2(i-1)<1e-10
        break
    end
end
    
        