heng=0;zong=0;aa=0;

data_yuan=load('D:\qq文件夹\2275316862\FileRecv\外厂\zhoucheng\ZH(-490).txt');
heng=data_yuan(:,1);
zong=data_yuan(:,2);
zzhou=data_yuan(:,3);
bb=sqrt(heng.^2+zong.^2+zzhou.^2);
aa=sqrt(heng.^2+zong.^2);
n=length(aa);
a=0;b=0;R=0;
for i=1:n
    a=a+aa(i)*cos(2*pi/n*i);
    b=b+aa(i)*sin(2*pi/n*i);
    R=R+aa(i);
end
a=2*a/n;
b=2*b/n;
R=R/n;
for i=1:n
    Rri(i)=sqrt((aa(i)*cos(2*3.14/n*i)-a)^2+(aa(i)*sin(2*3.14/n*i)-b)^2);
end
Rmax=max(Rri);
Rmin=min(Rri);
fLS=Rmax-Rmin;


a=mean(heng);
b=mean(zong);
figure
plot(heng,zong)
hold on
grid on
theta=0:0.01:2*pi;  
Circle1=a+Rmax/4*cos(theta);  
Circle2=b+Rmax/4*sin(theta); 
plot(Circle1,Circle2)
Circle1=a+Rmin/4*cos(theta);  
Circle2=b+Rmin/4*sin(theta); 
plot(Circle1,Circle2)
Circle1=a+R/4*cos(theta);  
Circle2=b+R/4*sin(theta); 
plot(Circle1,Circle2)
plot(a,b,'o')
legend('测量数据','最大','最小','最小二乘圆','最小二乘圆心')
