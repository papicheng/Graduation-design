% ģ�ͽ׵�ȷ��1:���в���
clear;clc;
load('uy3.mat');
for n=1:5
    N=length(u)-n;                  %����ά��
    Y=y(n+1:n+N,1);                 %�������
    Phi=zeros(N,2*n);
    for i=1:n
        Phi(:,i)=-y(n-i+1:n+N-i,1);
        Phi(:,n+i)=u(n-i+1:n+N-i,1);
    end
    theta=inv(Phi'*Phi)*Phi'*Y;     %��ʶ���
    e=Y-Phi*theta(:,1);             %�в�
    J(n)=e'*e;
end
for n=1:4
    N=length(u)-n;                  %����ά��
    t(n)=(J(n)-J(n+1))/J(n+1)*(N-2*n-2)/2;
end

% ���� figure
figure1 = figure;

% ���� axes
axes1 = axes('Parent',figure1,'XTick',[1 2 3 4 5]);
box(axes1,'on');
hold(axes1,'all');

% ���� plot
plot(1:5,J);

% ���� ylabel
ylabel('Jn');

% ���� xlabel
xlabel('ģ�ͽ״�');