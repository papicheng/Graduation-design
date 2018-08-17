% 递推夏式法进行参数辨识
clear;clc;
load('uy1.mat');
n=2;                            %系统阶数
MAXN=500;                       %数据总量
t=1:MAXN;                       %时间初始化
P1=100^2*diag([1 1 1 1]);       %P阵初始化
nbegin=10;                      %相比于递推广义二乘法，可以较小                  
theta=zeros(4,MAXN);          
Beta=zeros(6,MAXN);             %辨识结果初始化
%递推辨识
for i=3:MAXN
    if i<=nbegin                %前nbegin步使用递推最小二乘辨识，积累数据
        Psi=[-y(i-1) -y(i-2) u(i-1) u(i-2)]';
        K1=P1*Psi*inv(1+Psi'*P1*Psi);
        P1=P1-K1*Psi'*P1;
        theta(:,i)=theta(:,i-1)+K1*(y(i)-Psi'*theta(:,i-1));
        Beta(1:4,i)=theta(:,i);
    end
    if i==nbegin                %在第nbegin步，除了用RLS对参数进行辨识，还要对Beta赋初值
        Y=y(n+1:i,1);           %输出矩阵
        Y2=y(n:i-1,1);
        Y3=y(n-1:i-2,1);
        U=u(n+1:i,1);           %输入矩阵
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
    if i>nbegin                 %第nbegin步以后，积累了足够的数据，进行RGLS辨识
        Y=y(n+1:i,1);           %输出矩阵
        Y2=y(n:i-1,1);
        Y3=y(n-1:i-2,1);
        U=u(n+1:i,1);           %输入矩阵
        U2=u(n:i-1,1);
        U3=u(n-1:i-2,1);
        Phi=[-Y2,-Y3,U2,U3];
        e=Y-Phi*theta(:,i-1);     %求残差
        %辨识f
        Psi=[-y(i-1);-y(i-2);u(i-1);u(i-2);-e(i-3);-e(i-4)];
        r=P*Psi*inv(1+Psi'*P*Psi);
        P=P-r*Psi'*P;
        Beta(:,i)=Beta(:,i-1)+r*(y(i)-Psi'*Beta(:,i-1));
        theta(:,i)=Beta(1:4,i);
    end
end
% 辨识结果作图
figure (1)
plot(t,theta(1,:))
figure (2)
plot(t,theta(2,:))
figure (3)
plot(t,theta(3,:))
figure (4)
plot(t,theta(4,:))