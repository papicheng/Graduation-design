% ������С���˷����в�����ʶ
clear;clc;
load('uy1.mat');
n=2;                            %ϵͳ����
N=length(u)-n;                  %����ά��
Y=y(n+1:n+N,1);                 %�������
Y2=y(n:n+N-1,1);
Y3=y(n-1:n+N-2,1);
U=u(n+1:n+N,1);                 %�������
U2=u(n:n+N-1,1);
U3=u(n-1:n+N-2,1);
Phi(:,1)=-y(n:n+N-1,1);
Phi(:,2)=-y(n-1:n+N-2,1);
Phi(:,3)=u(n:n+N-1,1);
Phi(:,4)=u(n-1:n+N-2,1);
%�Ƚ���һ�λ�����С���˱�ʶ
theta(:,1)=inv(Phi'*Phi)*Phi'*Y;
e(:,1)=Y-Phi*theta(:,1);        %�в�
sigma2(1)=e'*e/N;               %����
%�������й�����С���˷���ʶ
for i=2:10000
    E=e(3:N);
    Omega(:,1)=-e(2:N-1);
    Omega(:,2)=-e(1:N-2);
    f=inv(Omega'*Omega)*Omega'*E;
    y_=Y+[Y2,Y3]*f;
    u_=U+[U2,U3]*f;
    Y_=y_(n+1:N,1);
    Phi_(:,1)=-y_(n:N-1,1);
    Phi_(:,2)=-y_(n-1:N-2,1);
    Phi_(:,3)=u_(n:N-1,1);
    Phi_(:,4)=u_(n-1:N-2,1);
    theta(:,i)=inv(Phi_'*Phi_)*Phi_'*Y_;
    e(:,1)=Y-Phi*theta(:,i);        %�в�
    sigma2(i)=e'*e/N;     %����
    if sum((theta(:,i)-theta(:,i-1)).^2)<1e-20
        break
    end
end
    





