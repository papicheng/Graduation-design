% ��׶���С���˷����в�����ʶ�������ַ�����
clear;clc;
load('uy1.mat');
n=2;                            %ϵͳ����
m=2;                            %���Ž���
N=length(u)-n-m;                  %����ά��
Y=y(n+m+1:n+m+N,1);                 %�������
Phi=zeros(N,2*n);
for i=1:m+n
    Phi(:,i)=-y(m+n-i+1:m+n+N-i,1);
    Phi(:,m+n+i)=u(m+n-i+1:m+n+N-i,1);
end
alpha=inv(Phi'*Phi)*Phi'*Y;      %��ʶ���
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







