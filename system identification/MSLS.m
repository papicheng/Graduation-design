% 多阶段最小二乘法进行参数辨识（第三种方法）
clear;clc;
load('uy1.mat');
n=2;                            %系统阶数
m=2;                            %干扰阶数
N=length(u)-n-m;                  %矩阵维数
Y=y(n+m+1:n+m+N,1);                 %输出矩阵
Phi=zeros(N,2*n);
for i=1:m+n
    Phi(:,i)=-y(m+n-i+1:m+n+N-i,1);
    Phi(:,m+n+i)=u(m+n-i+1:m+n+N-i,1);
end
alpha=inv(Phi'*Phi)*Phi'*Y;      %辨识结果
g=[alpha(m+n+1:2*(m+n));zeros(n,1)];
G(:,1)=[0;-alpha(m+n+1:2*(m+n));0];
G(:,2)=[0;0;-alpha(m+n+1:2*(m+n))];
G(:,3)=[1;alpha(1:m+n);0];
G(:,4)=[0;1;alpha(1:m+n)];
theta=inv(G'*G)*G'*g;
r=alpha(1:m+n,1)-[theta(1:n,1);zeros(m,1)];
R(:,1)=[1;theta(1:n,1);0];
R(:,2)=[0;1;theta(1:n,1)];
f=inv(R'*R)*R'*r;







