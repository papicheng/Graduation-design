% ��ʽƫ�����������в�����ʶ
clear;clc;
load('uy1.mat');
n=2;                            %ϵͳ����
N=length(u)-n;                  %����ά��
Y=y(n+1:n+N,1);                 %�������
Y2=y(n+3:n+N,1);
Phi(:,1)=-y(n:n+N-1,1);
Phi(:,2)=-y(n-1:n+N-2,1);
Phi(:,3)=u(n:n+N-1,1);
Phi(:,4)=u(n-1:n+N-2,1);
Gam=inv(Phi'*Phi)*Phi';
Phi2=[-y(n+2:n+N-1,1),-y(n+1:n+N-2,1),u(n+2:n+N-1,1),u(n+1:n+N-2,1)];
Gam2=inv(Phi2'*Phi2)*Phi2';
M=eye(N-n)-Phi2*Gam2;      %Ϊ�˱�����Omega��ά�ȹ�ϵ�����¹���Phi��Gam��������M
%�Ƚ���һ�λ�����С���˱�ʶ
theta(:,1)=Gam*Y;
thetaLS=theta(:,1);
e(:,1)=Y-Phi*theta(:,1);        %�в�
sigma2(1)=e'*e/N;               %����
thetaB(:,1)=zeros(4,1);
%�������й�����С���˷���ʶ
for i=2:10000
    Omega(:,1)=-e(2:N-1);
    Omega(:,2)=-e(1:N-2);
    D=Omega'*M*Omega;
    Dn=inv(D);
    f=Dn*Omega'*M*Y2;
    thetaB(:,i)=Gam2*Omega*f;
    theta(:,i)=thetaLS-thetaB(:,i);
    e(:,1)=Y-Phi*theta(:,i);    %�в�
    sigma2(i)=e'*e/N;           %����
    if sum((thetaB(:,i)-thetaB(:,i-1)).^2)<1e-20
        break
    end
end