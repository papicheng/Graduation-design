% 模型阶的确定1:按残差方差定阶
clear;clc;
load('uy3.mat');
for n=1:5
    N=length(u)-n;                  %矩阵维数
    Y=y(n+1:n+N,1);                 %输出矩阵
    Phi=zeros(N,2*n);
    for i=1:n
        Phi(:,i)=-y(n-i+1:n+N-i,1);
        Phi(:,n+i)=u(n-i+1:n+N-i,1);
    end
    theta=inv(Phi'*Phi)*Phi'*Y;     %辨识结果
    e=Y-Phi*theta(:,1);             %残差
    J(n)=e'*e;
end
for n=1:4
    N=length(u)-n;                  %矩阵维数
    t(n)=(J(n)-J(n+1))/J(n+1)*(N-2*n-2)/2;
end

% 创建 figure
figure1 = figure;

% 创建 axes
axes1 = axes('Parent',figure1,'XTick',[1 2 3 4 5]);
box(axes1,'on');
hold(axes1,'all');

% 创建 plot
plot(1:5,J);

% 创建 ylabel
ylabel('Jn');

% 创建 xlabel
xlabel('模型阶次');