% 极大似然法进行参数辨识
clear;clc;
load('uy1.mat');
n=2;                            %系统阶数
N=length(u)-n;                  %矩阵维数
Y=y(n+1:n+N,1);                 %输出矩阵
U=u(n+1:n+N,1);                 %输入矩阵
Phi(:,1)=-y(n:n+N-1,1);
Phi(:,2)=-y(n-1:n+N-2,1);
Phi(:,3)=u(n:n+N-1,1);
Phi(:,4)=u(n-1:n+N-2,1);
%先进行一次基本最小二乘辨识
theta(:,1)=inv(Phi'*Phi)*Phi'*Y;
e(:,1)=Y-Phi*theta(:,1);        %残差
e=[0;0;e];
theta(5:6,1)=[0;0];
sigma2(1)=e'*e/N;               %方差
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
    theta(:,i)=theta(:,i-1)-(P2)^-1*PJPtheta*0.1;%乘以系数0.1 使其波动不那么剧烈 最终实现收敛
    e(3:n+N,1)=Y-Phi*theta(:,i);    %残差
    sigma2(i)=e'*e/N;               %方差
    Phi(:,5)=e(n:n+N-1,1);
    Phi(:,6)=e(n-1:n+N-2,1);
    if abs(sigma2(i)-sigma2(i-1))/sigma2(i-1)<1e-10
        break
    end
end
    
        