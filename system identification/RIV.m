% 递推辅助变量法进行参数辨识
clear;clc;
load('uy1.mat');
n=2;                            %系统阶数
MAXN=500;                       %数据总量
t=1:MAXN;                       %时间初始化
P=100^2*diag([1 1 1 1]);        %P阵初始化
theta=zeros(4,MAXN);            %辨识结果初始化
%前50步使用递推最小二乘法进行参数辨识
for i=2:49
    Psi=[-y(i) -y(i-1) u(i) u(i-1)]';
    K=P*Psi*inv(1+Psi'*P*Psi);
    P=P-K*Psi'*P;
    theta(:,i+1)=theta(:,i)+K*(y(i+1)-Psi'*theta(:,i));
end
%50步以后使用递推辅助变量法(Tally原理)进行参数辨识
for i=50:MAXN-1
    Psi=[-y(i) -y(i-1) u(i) u(i-1)]';
    z=[-y(i-2) -y(i-3) u(i) u(i-1)]';
    K=P*z*inv(1+Psi'*P*Psi);
    P=P-K*Psi'*P;
    theta(:,i+1)=theta(:,i)+K*(y(i+1)-Psi'*theta(:,i));
end
%辨识结果作图
figure (1)
plot(t,theta(1,:))
figure (2)
plot(t,theta(2,:))
figure (3)
plot(t,theta(3,:))
figure (4)
plot(t,theta(4,:))




