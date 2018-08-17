clear 
clc
close all
Np=400;
u=[1 0 0 1 1 0 1 0 1 1];
for i=10:(Np-1)
    u(i)=xor(u(i-4),u(i-9));
end
for j=10:(Np-1)
    if mod(j,2)==0
        y(j)=1;
    else
        y(j)=0;
    end
    u(i)=xor(u(i),y(j));
end
v=randn(3,400);
z=[1,398]';
for i=3:400
    z(i)=1.5*z(i-1)-0.7*z(i-2)+1*u(i-1)+0.5*u(i-2);%+v(i);%辨识对象
end
H=zeros(400,4);
plot(z);grid on;
figure;
for i=3:400
    H(i,1)=-z(i-1);
    H(i,2)=-z(i-2);
    H(i,3)=u(i-1);
    H(i,4)=u(i-2);
end
thetal=inv(H'*H)*H'*z
i=1:400;
subplot(1,3,1)
plot(i,thetal(1,:),i,thetal(2,:),i,thetal(3,:),i,thetal(4,:))
title('一次性最小二乘法');
P=10^6*eye(4);
theta2=0.0001*eye(4,1);
I=eye(4);
h=H';
for i=3:400
    K=P*h(:,i)*(H(i,:)*P*h(:,i)+1)^(-1);
    P=(I-K*H(i,:))*P;
    theta2=theta2+K*(z(i)-H(i,:)*theta2);
end
disp('')
theta2
i=1:400;
subplot(1,3,2)
plot(i,theta2(1,:),'r',i,theta2(2,:),'k',i,theta2(3,:),'g',i,theta2(4,:),'b')
title('递推算法');
subplot(1,3,3)
stairs(u)
title('M序列')