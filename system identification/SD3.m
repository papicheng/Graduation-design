% ģ�ͽ׵�ȷ��3:���в��ɫ
clear;clc;
% load('uy1.mat');
data=load('Axis1_RefPos_EncPos_Prbs_Gain_1000_040248.txt');
u=data(:,2);
y=data(:,1);
for n=1:5
    n;
    N=length(u)-n;                  %����ά��
    Y=y(n+1:n+N,1);                 %�������
    Phi=zeros(N,2*n);
    for i=1:n
        Phi(:,i)=-y(n-i+1:n+N-i,1);
        Phi(:,n+i)=u(n-i+1:n+N-i,1);
    end
    theta=inv(Phi'*Phi)*Phi'*Y;     %��ʶ���
    e=Y-Phi*theta(:,1);             %�в�
    e=[zeros(n,1);e];
    theta(2*n+1:3*n,1)=zeros(n,1);
    sigma2(n,1)=e'*e/N;               %����
    for i=1:n
        Phi(:,2*n+i)=e(n-i+1:n+N-i,1);
    end

    for i=2:10000
        PD=zeros(n*3,n+N);
        PJPtheta=0;
        P2=0;
        for k=n+1:n+N
            for j=1:n
                PD(j,k)=y(k-j);
                PD(n+j,k)=-u(k-j);
                PD(2*n+j,k)=-e(k-j);
                for l=1:n
                    PD(j,k)=PD(j,k)-theta(2*n+l,i-1)*PD(j,k-l);
                    PD(n+j,k)=PD(n+j,k)-theta(2*n+l,i-1)*PD(n+j,k-l);
                    PD(2*n+j,k)=PD(2*n+j,k)-theta(2*n+l,i-1)*PD(2*n+j,k-l);
                end
            end
            PJPtheta=PJPtheta+e(k)*PD(:,k);
            P2=P2+PD(:,k)*PD(:,k)';
        end
        theta(:,i)=theta(:,i-1)-(P2)^-1*PJPtheta*0.1;%����ϵ��0.1 ʹ�䲨������ô���� ����ʵ������
        e(n+1:n+N,1)=Y-Phi*theta(:,i);    %�в�
        sigma2(n,i)=e'*e/N;               %����
        for k=1:n
            Phi(:,2*n+k)=e(n-k+1:n+N-k,1);
        end
        if abs(sigma2(n,i)-sigma2(n,i-1))/sigma2(n,i-1)<1e-4
            break
        end
    end
    for i=0:6
        R(n)=0;
        R0=0;
        for k=n+1:N+n-i
            R(n)=R(n)+e(k)*e(k+i);
            R0=R0+e(k)^2;
        end
        r(n,i+1)=R(n)/R0;
    end
end
% ���� figure
figure1 = figure;

% ���� axes
axes1 = axes('Parent',figure1);
box(axes1,'on');
hold(axes1,'all');

% ʹ�� plot �ľ������봴������
plot(0:6,r);
legend('1','2','3','4','5');
% ���� textbox
annotation(figure1,'textbox',...
    [0.416071428571428 0.508523809523811 0.0857142857142857 0.0666666666666667],...
    'String',{'n=1'},...
    'EdgeColor',[1 1 1]);

% ���� textbox
annotation(figure1,'textbox',...
    [0.423571428571428 0.286142857142859 0.0857142857142857 0.0666666666666667],...
    'String',{'n=2'},...
    'EdgeColor',[1 1 1]);


