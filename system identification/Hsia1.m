% 夏式偏差修正法进行参数辨识
clear;clc;
load('uy1.mat');
n=2;                            %系统阶数
N=length(u)-n;                  %矩阵维数
Y=y(n+1:n+N,1);                 %输出矩阵
Y2=y(n+3:n+N,1);
Phi(:,1)=-y(n:n+N-1,1);
Phi(:,2)=-y(n-1:n+N-2,1);
Phi(:,3)=u(n:n+N-1,1);
Phi(:,4)=u(n-1:n+N-2,1);
Gam=inv(Phi'*Phi)*Phi';
Phi2=[-y(n+2:n+N-1,1),-y(n+1:n+N-2,1),u(n+2:n+N-1,1),u(n+1:n+N-2,1)];
Gam2=inv(Phi2'*Phi2)*Phi2';
M=eye(N-n)-Phi2*Gam2;      %为了保持与Omega的维度关系，重新构造Phi和Gam，来计算M
%先进行一次基本最小二乘辨识
theta(:,1)=Gam*Y;
thetaLS=theta(:,1);
e(:,1)=Y-Phi*theta(:,1);        %残差
sigma2(1)=e'*e/N;               %方差
thetaB(:,1)=zeros(4,1);
%迭代进行广义最小二乘法辨识
for i=2:10000
    Omega(:,1)=-e(2:N-1);
    Omega(:,2)=-e(1:N-2);
    D=Omega'*M*Omega;
    Dn=inv(D);
    f=Dn*Omega'*M*Y2;
    thetaB(:,i)=Gam2*Omega*f;
    theta(:,i)=thetaLS-thetaB(:,i);
    e(:,1)=Y-Phi*theta(:,i);    %残差
    sigma2(i)=e'*e/N;           %方差
    if sum((thetaB(:,i)-thetaB(:,i-1)).^2)<1e-20
        break
    end
end