% 模型阶的确定2:AIC
clear;clc;
load('uy3.mat');
for n=1:4
    n;
    N=length(u)-n;                  %矩阵维数
    Y=y(n+1:n+N,1);                 %输出矩阵
    Phi=zeros(N,2*n);
    for i=1:n
        Phi(:,i)=-y(n-i+1:n+N-i,1);
        Phi(:,n+i)=u(n-i+1:n+N-i,1);
    end
    theta=inv(Phi'*Phi)*Phi'*Y;     %辨识结果
    e=Y-Phi*theta(:,1);             %残差
    e=[zeros(n,1);e];
    theta(2*n+1:3*n,1)=zeros(n,1);
    sigma2(n,1)=e'*e/N;               %方差
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
        theta(:,i)=theta(:,i-1)-(P2)^-1*PJPtheta*0.1;%乘以系数0.1 使其波动不那么剧烈 最终实现收敛
        e(n+1:n+N,1)=Y-Phi*theta(:,i);    %残差
        sigma2(n,i)=e'*e/N;               %方差
        for k=1:n
            Phi(:,2*n+k)=e(n-k+1:n+N-k,1);
        end
        if abs(sigma2(n,i)-sigma2(n,i-1))/sigma2(n,i-1)<1e-4
            break
        end
    end
    AIC(n)=N*log(sigma2(n,i))+6*n;
end


