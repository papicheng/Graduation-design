clear 
clc
close all
L=15;
y1=1;y2=1;y3=1;y4=0;
for i=1:L
    x1=xor(y3,y4);
    x2=y1;
    x3=y2;
    x4=y3;
    y(i)=y4;
    if y(i)>0.5,u(i)=-0.1;
    else u(i)=0.1;
    end
    y1=x1;y2=x2;y3=x3;y4=x4;
end
subplot(1,3,1)
stairs(u);title('M序列');
z(2)=0;z(1)=0;
for k=3:15;
    z(k)=2*z(k-1)-1*z(k-2)+u(k-1)+1.5*u(k-2);
end
subplot(1,3,2);
plot(z);title('输出信号');
c0=[0.001 0.001 0.001 0.001]';
p0=10^6*eye(4,4);
E=0.0000000005;
c=[c0,zeros(4,14)];
e=zeros(4,15);
for k=3:15
    h1=[-z(k-1),-z(k-2),u(k-1),u(k-2)]';
    x=h1'*p0*h1+1;
    x1=inv(x);
    k1=p0*h1*x1;
    d1=z(k)-h1'*c0;
    c1=c0+k1*d1;
    e1=c1-c0;
    e2=e1./c0;
    e(:,k)=e2;
    c0=c1;
    c(:,k)=c1;
    p1=p0-k1*k1'*[h1'*p0*h1+1];
    p0=p1;
    if e2<=E break;
    end
end
c,e
a1=c(1,:);a2=c(2,:);b1=c(3,:);b2=c(4,:);ea1=e(1,:);ea2=e(2,:);ea3=e(3,:);ea4=e(4,:);
subplot(1,3,3);
i=1:15;
plot(i,a1,i,a2,i,b1,i,b2);
legend('a1','a2','b1','b2');grid on;
title('参数估计');
