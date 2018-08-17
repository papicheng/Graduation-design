% 基本最小二乘法进行参数辨识
clear;clc;
load('uy1.mat');
n=2;                            %系统阶数
N=length(u)-n;                  %矩阵维数
Y=y(n+1:n+N,1);                 %输出矩阵
Phi=zeros(N,2*n);
for i=1:n
    Phi(:,i)=-y(n-i+1:n+N-i,1);
    Phi(:,n+i)=u(n-i+1:n+N-i,1);
end
theta=inv(Phi'*Phi)*Phi'*Y      %辨识结果






