% ���ƹ�����С���˷����в�����ʶ
clear;clc;
load('uy1.mat');
n=2;                            %ϵͳ����
MAXN=500;                       %��������
t=1:MAXN;                       %ʱ���ʼ��
P1=100^2*diag([1 1 1 1]);       %P���ʼ��
theta=zeros(4,MAXN);            %��ʶ�����ʼ��
nbegin=50;                      %����̫С����Ϊ������С���˷��Գ�ֵ�ǳ�����
%���Ʊ�ʶ
for i=3:MAXN
    if i<=nbegin                %ǰnbegin��ʹ�õ�����С���˱�ʶ����������
        Psi=[-y(i-1) -y(i-2) u(i-1) u(i-2)]';
        K1=P1*Psi*inv(1+Psi'*P1*Psi);
        P1=P1-K1*Psi'*P1;
        theta(:,i)=theta(:,i-1)+K1*(y(i)-Psi'*theta(:,i-1));
    end
    if i==nbegin                %�ڵ�nbegin����������RLS�Բ������б�ʶ����Ҫ��P2��f����ֵ
        Y=y(n+1:i,1);           %�������
        Y2=y(n:i-1,1);
        Y3=y(n-1:i-2,1);
        U=u(n+1:i,1);           %�������
        U2=u(n:i-1,1);
        U3=u(n-1:i-2,1);
        Phi=[-Y2,-Y3,U2,U3];
        e=Y-Phi*theta(:,i-1);
        E=e(3:i-2);
        Omega=[-e(2:i-3),-e(1:i-4)];
        P2=inv(Omega'*Omega);   %P2����ֵ
        f=P2*Omega'*E;          %f����ֵ
    end
    if i>nbegin                 %��nbegin���Ժ󣬻������㹻�����ݣ�����RGLS��ʶ
        Y=y(n+1:i,1);           %�������
        Y2=y(n:i-1,1);
        Y3=y(n-1:i-2,1);
        U=u(n+1:i,1);           %�������
        U2=u(n:i-1,1);
        U3=u(n-1:i-2,1);
        Phi=[-Y2,-Y3,U2,U3];
        e=Y-Phi*theta(:,i-1);     %��в�
        %��ʶf
        omega=[-e(i-3);-e(i-4)];
        K2=P2*omega*inv(1+omega'*P2*omega);
        P2=P2-K2*omega'*P2;
        f=f+K2*(e(i-2)-omega'*f);
        %��ʶtheta
        y_=Y+[Y2,Y3]*f;
        u_=U+[U2,U3]*f;
        Psi=[-y_(i-3);-y_(i-4);u_(i-3);u_(i-4)];
        K1=P1*Psi*inv(1+Psi'*P1*Psi);
        P1=P1-K1*Psi'*P1;
        theta(:,i)=theta(:,i-1)+K1*(y_(i-2)-Psi'*theta(:,i-1));
        
    end
end
% ��ʶ�����ͼ
figure (1)
plot(t,theta(1,:))
figure (2)
plot(t,theta(2,:))
figure (3)
plot(t,theta(3,:))
figure (4)
plot(t,theta(4,:))





