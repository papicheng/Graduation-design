% 辅助变量法进行参数辨识
clear;clc;
load('uy1.mat');
n=2;                            %系统阶数
N=length(u)-n;                  %矩阵维数
Y=y(2*n+1:n+N,1);                 %输出矩阵
%Phi矩阵
Phi(:,1)=-y(2*n:n+N-1,1);
Phi(:,2)=-y(2*n-1:n+N-2,1);
Phi(:,3)=u(2*n:n+N-1,1);
Phi(:,4)=u(2*n-1:n+N-2,1);
%Tally辅助变量
Z(:,1)=-y(n:N-1,1);
Z(:,2)=-y(n-1:N-n,1);
Z(:,3)=u(n+2:N+1,1);
Z(:,4)=u(n+1:N,1);
%辨识结果
theta=inv(Z'*Phi)*Z'*Y




