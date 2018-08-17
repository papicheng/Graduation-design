clc;
clear all;
num=[1 10 20];
% den=[4 10.9 371 1];
den=[1 5 20];

t0=1;
T=1:t0:101;
L=length(T);
w=2*pi/L*T;
sys=tf(num,den)
% bode(sys)
for i=1:L
%     Gw(i)=(2*(j*w(i))^2+1.18*j*w(i)+20)/(4*(j*w(i))^3+10.9*(j*w(i))^2+371*j*w(i)+1);
    Gw(i)=((j*w(i))^2+10*j*w(i)+20)/((j*w(i))^2+5*j*w(i)+20);
end
%------进行levy法辨识-----%
%--生成系数矩阵--%
m=length(num);
n=length(den);
re=real(Gw);
im=imag(Gw);
plot(im)
v=zeros(1,m+2);s=zeros(1,m+4);
t=zeros(1,n+5);u=zeros(1,n+5);
for k=1:n+2
    for i=1:L
        v(k)=v(k)+w(i)^(k-1);
    end
end
for k=1:n+4
    for i=1:L
        s(k)=s(k)+w(i)^(k-1)*re(i);
        t(k)=t(k)+w(i)^(k-1)*im(i);
        u(k)=u(k)+w(i)^(k-1)*(re(i)^2+im(i)^2);
    end
end
V1=zeros(m,m);
for i=1:m
    for j=1:m
        if mod((i+j),2)==0
            V1(i,j)=v(i+j-1);
            if j==3||j==4
                V1(i,j)=-V1(i,j);
            end
        end
    end
end
V2=zeros(n,n);
for i=1:m
    for j=1:n
        if mod(i+j,2)==0
            if mod(i,2)~=0  
                V2(i,j)=(-1)^((j+1)/2+1)*t(i+j);
            else
                V2(i,j)=(-1)^(j/2+1)*t(i+j);
            end         
        else
            if mod(i,2)~=0  
                V2(i,j)=(-1)^(j/2+1)*s(i+j);
            else
                V2(i,j)=(-1)^((j+1)/2)*s(i+j);
            end            
        end
    end
end
V3=zeros(m,m);
for i=1:n
    for j=1:m
        if mod(i+j,2)==0
            if mod(i,2)~=0
                V3(i,j)=(-1)^((j+1)/2+1)*t(i+j);
            else
                V3(i,j)=(-1)^(j/2+1)*t(i+j);
            end         
        else
            if mod(i,2)~=0   
                V3(i,j)=(-1)^(j/2)*s(i+j);
            else
                V3(i,j)=(-1)^((j+1)/2+1)*s(i+j);
            end          
        end
    end
end
V4=zeros(n,n);
for i=1:n
    for j=1:n
        if mod((i+j),2)==0
            V4(i,j)=u(i+j+1);
            if j==3||j==4
                V4(i,j)=-V4(i,j);
            end
        end
    end
end
fai=[V1(:,:) V2(:,:);V3(:,:) V4(:,:)];
Y1=zeros(1,m);
for i=1:m
    if mod(i,2)~=0  
        Y1(i)=s(i);
    elseif mod(i,2)==0
        Y1(i)=t(i);
    end
end
Y2=zeros(1,n);
for i=1:n
    if mod(i,2)==0
        Y2(i)=u(i+1);
    end
end
Y=[Y1(:,:) Y2(:,:)];
S=inv(fai)*Y';
num1=[fliplr(S(1:m)')];
den1=[fliplr(S(m+1:m+n)'),1];
disp('辨识所得传递函数')
G=tf(num1,den1)

        
    
        
            
            
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
