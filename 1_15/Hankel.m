function [Gz,Gs]=Hankel(G,T)      %用Hankel矩阵和脉冲响应数据，辨识脉冲传递函数 
clear all 
% G=[7.157039 9.491077 8.563889 5.930506 2.845972 0.144611]; 
% T=0.05; 
k=max(size(G)); 
n=k/2; 
n1=n; 
n2=n; 
n3=n; 
n8=n; 
 
i1=1; 
i2=0; 
i3=n+1; 
i4=1; 
i6=n; 
 
j1=1; 
j2=0; 
j3=1; 
 
%构造矩阵H 
for i=1:n 
    for j=j1:n 
       H(i,j-j2)=G(j); 
    end  
    j1=j1+1; 
    j2=j2+1; 
    n=n+1; 
end 
 
%构造矩阵g1 
for i8=1:n8 
     g1(i8)=G(i8); 
end 
 
%构造矩阵g2 
for i4=1:n 
    if (i3<=k) 
       g2(i4)=G(i3); 
       i3=i3+1; 
    end 
   
end 
a1=-inv(H)*g2'; 
 
%构造矩阵a 
for i5=1:n 
    if (i6>=1) 
       a2(i5)=a1(i6); 
       i6=i6-1; 
end 
end 
a=a2'; 
 
%构造矩阵A 
A1=zeros(n2); 
for j3=1:n 
    for i7=i1:n2 
        if(i7-i2<n2-i2) 
             A1(i7+1,j3)=a(i7-i2); 
         end 
     end 
     i1=i1+1; 
     i2=i2+1; 
end 
A2=eye(n2); 
A=A1+A2; 
b=A*g1'; 
 
 
%求出脉冲传递函数的估计值 
den1=ones(1,n3+1); 
for i9=1:n3 
    den1(i9+1)=a(i9); 
end 
den=den1; 
num=b'; 
Gz=tf(num,den,T) 
%连续传递函数的估计值 
Gs=d2c(Gz,'tustin') 