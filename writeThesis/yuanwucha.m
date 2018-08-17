x=zhouchengX;
y=zhouchengY;
figure;plot(zhouchengX,zhouchengY);grid on
hold on
k=length(zhouchengX);
for i=1:k
%     theta(i)=360/k*(i-1);
%     % 计算各测点相对于坐标圆点的坐标值
%     x=(P(i)+R).*cos(pi*theta./180);
%     y=(P(i)+R).*sin(pi*theta./180);
%     % 计算各测点相对于坐标原点的半径值
%     t(i)=x(i);
%     q(i)=y(i);
    Ri(i)=sqrt(x(i)^2+y(i)^2);
    % 积分计算最小二乘圆圆心坐标
    % 将θ由角度值转变为弧度值
%     theta_r=pi*theta./180;
%     x_sum=x_sum+x(i);
%     y_sum=y_sum+y(i);
end
x_sum=sum(x);
y_sum=sum(y);
Ri_sum=sum(Ri);
a=x_sum/k;
b=y_sum/k;
R=Ri_sum/k;
% 计算各测量点相对于最小二乘圆圆心的最大半径和最小半径
for i=1:k
R_mea(i)=sqrt((x(i)-a)^2+(y(i)-b)^2);
end
R_max=max(R_mea);
R_min=min(R_mea);
roundness=R_max-R_min


figure;plot(zhouchengX,zhouchengY);grid on
hold on
theta=0:0.1:2*pi;  
Circle1=a+R_max/2*cos(theta);  
Circle2=b+R_max/2*sin(theta); 
plot(Circle1,Circle2)
Circle1=a+R_min/2*cos(theta);  
Circle2=b+R_min/2*sin(theta); 
plot(Circle1,Circle2)