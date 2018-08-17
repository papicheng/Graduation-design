% 递推广义最小二乘法进行参数辨识
clear;clc;
load('uy1.mat');
n=2;                            %系统阶数
MAXN=500;                       %数据总量
t=1:MAXN;                       %时间初始化
P1=100^2*diag([1 1 1 1]);       %P阵初始化
theta=zeros(4,MAXN);            %辨识结果初始化
nbegin=50;                      %不能太小，因为广义最小二乘法对初值非常敏感
%递推辨识
for i=3:MAXN
    if i<=nbegin                %前nbegin步使用递推最小二乘辨识，积累数据
        Psi=[-y(i-1) -y(i-2) u(i-1) u(i-2)]';
        K1=P1*Psi*inv(1+Psi'*P1*Psi);
        P1=P1-K1*Psi'*P1;
        theta(:,i)=theta(:,i-1)+K1*(y(i)-Psi'*theta(:,i-1));
    end
    if i==nbegin                %在第nbegin步，除了用RLS对参数进行辨识，还要对P2及f赋初值
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
        P2=inv(Omega'*Omega);   %P2赋初值
        f=P2*Omega'*E;          %f赋初值
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
        omega=[-e(i-3);-e(i-4)];
        K2=P2*omega*inv(1+omega'*P2*omega);
        P2=P2-K2*omega'*P2;
        f=f+K2*(e(i-2)-omega'*f);
        %辨识theta
        y_=Y+[Y2,Y3]*f;
        u_=U+[U2,U3]*f;
        Psi=[-y_(i-3);-y_(i-4);u_(i-3);u_(i-4)];
        K1=P1*Psi*inv(1+Psi'*P1*Psi);
        P1=P1-K1*Psi'*P1;
        theta(:,i)=theta(:,i-1)+K1*(y_(i-2)-Psi'*theta(:,i-1));
        
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





