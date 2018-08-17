% ������ʽ�����в�����ʶ
clear;clc;
load('uy1.mat');
n=2;                            %ϵͳ����
MAXN=500;                       %��������
t=1:MAXN;                       %ʱ���ʼ��
P1=100^2*diag([1 1 1 1]);       %P���ʼ��
nbegin=10;                      %����ڵ��ƹ�����˷������Խ�С                  
theta=zeros(4,MAXN);          
Beta=zeros(6,MAXN);             %��ʶ�����ʼ��
%���Ʊ�ʶ
for i=3:MAXN
    if i<=nbegin                %ǰnbegin��ʹ�õ�����С���˱�ʶ����������
        Psi=[-y(i-1) -y(i-2) u(i-1) u(i-2)]';
        K1=P1*Psi*inv(1+Psi'*P1*Psi);
        P1=P1-K1*Psi'*P1;
        theta(:,i)=theta(:,i-1)+K1*(y(i)-Psi'*theta(:,i-1));
        Beta(1:4,i)=theta(:,i);
    end
    if i==nbegin                %�ڵ�nbegin����������RLS�Բ������б�ʶ����Ҫ��Beta����ֵ
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
        f=inv(Omega'*Omega)*Omega'*E;
        Psi=[-y(4:i-1),-y(3:i-2),u(4:i-1),u(3:i-2),-e(2:i-3),-e(1:i-4)];
        P=inv(Psi'*Psi);
        Beta(:,i)=[theta(:,i);f];
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
        Psi=[-y(i-1);-y(i-2);u(i-1);u(i-2);-e(i-3);-e(i-4)];
        r=P*Psi*inv(1+Psi'*P*Psi);
        P=P-r*Psi'*P;
        Beta(:,i)=Beta(:,i-1)+r*(y(i)-Psi'*Beta(:,i-1));
        theta(:,i)=Beta(1:4,i);
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