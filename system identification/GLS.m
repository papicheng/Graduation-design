% 广义最小二乘法进行参数辨识
clear;clc;
load('uy1.mat');
n=2;                            %系统阶数
N=length(u)-n;                  %矩阵维数
Y=y(n+1:n+N,1);                 %输出矩阵
Y2=y(n:n+N-1,1);
Y3=y(n-1:n+N-2,1);
U=u(n+1:n+N,1);                 %输入矩阵
U2=u(n:n+N-1,1);
U3=u(n-1:n+N-2,1);
Phi(:,1)=-y(n:n+N-1,1);
Phi(:,2)=-y(n-1:n+N-2,1);
Phi(:,3)=u(n:n+N-1,1);
Phi(:,4)=u(n-1:n+N-2,1);
%先进行一次基本最小二乘辨识
theta(:,1)=inv(Phi'*Phi)*Phi'*Y;
e(:,1)=Y-Phi*theta(:,1);        %残差
sigma2(1)=e'*e/N;               %方差
%迭代进行广义最小二乘法辨识
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
    e(:,1)=Y-Phi*theta(:,i);        %残差
    sigma2(i)=e'*e/N;     %方差
    if sum((theta(:,i)-theta(:,i-1)).^2)<1e-20
        break
    end
end
    





