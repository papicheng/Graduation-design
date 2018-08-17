close all;
clear all
clc
x1=1;x2=1;x3=1;x4=1;
m=15;
for i=1:m
    y4=x4;y3=x3;y2=x2;y1=x1;
    x4=y3;x3=y2;x2=y1;x1=xor(y3,y4);
    if y4==0
        u(i)=-1;
    else
        u(i)=y4;
    end
end
m=u
%grapher
i1=i;
k=1:1:i1;
figure
stairs(0:1:14,u)
set(gca,'YLim',[-1.05,1.05])
title('M序列波形')
figure;
subplot(3,1,1)
plot(u,'rx')
xlabel('k')
ylabel('m序列')
title('m序列')
a1=-1;a2=0.5;b1=1;b2=0.5;Y(1)=0;Y(2)=0;
for K=3:1:16
    Y(K)=Y(K-1)-0.5*Y(K-2)+u(K-1)+0.5*u(K-2);
end

subplot(3,1,2)
k=1:1:i1+1;
plot(k,Y,k,Y,'rx')
xlabel('k')
ylabel('输出')
title('系统输出')
H=1/16;
p=ones(15);q=eye(15);
R=p+q;
for j=1:15
    for i=1:16-j
        M(i,i+j-1)=u(j);
    end
end

for t=1:15
    Z(t,1)=Y(1,t);
end
g=H*R*M*Z

subplot(3,1,3)
k=1:1:i1;
plot(k,g,k,g,'rx')
xlabel('k')
ylabel('输出')
title('脉冲响应估计值')
for r=1:15
    z(r)=m(r)*g(r);
end






