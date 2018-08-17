clear;
clc;
close all
%w Re Im L
%--------------���ɲ�������w��Gw-------------
%��������ϵͳ(���ӡ���ĸϵ��):(1.18s+200)/(10.9s^2+371s+1)
% num=[1.18 20];
% den=[10.9 371 1];
% T0=1;                       %����ʱ����1s           
% k=1:T0:100;     
% L=length(k);                %���ݳ���
% w=2*pi/L*k;
% %���ϵͳƵ������
% for i=1:L
%     Gw(i)=(1.18j*w(i)+20)/(10.9*(j*w(i))^2+371j*w(i)+1);
% end
% figure(1)
% stem(abs(Gw),'.');
data=xlsread('G:\study\GraduationThesis\dataOfSine\Axis1_DAC_ENC_SweepSine_17_Jan_2018_09_51_42.xlsx');%X�Ὺ��
w=data(:,1);
i=1;
while w(i)<=200
    w_(i)=w(i);
    i=i+1;
end
w=w_;
w=w*2*pi;
len=length(w);
amp=data(:,2);
amp=amp(1:len);
phase=data(:,3);
phase=phase(1:len);
phase(11:end)=89.9;
phase=phase/180*pi;
Gw=amp.*exp(1i*phase);
L=length(w);
%------------------��Levy����ʶ---------------------
%ϵͳ���ӡ���ĸ�״�m��n
% m=length(num)-1;
% n=length(den)-1;
m=0;n=1;
NN=2*n+1;              %j=1:N
Re=real(Gw);
Im=imag(Gw);
%����V,S,T,U
for j=1:NN
    V(j)=0;
    for i=1:L
        V(j)=V(j)+w(i)^(j-1);
    end
end
for j=1:NN
    S(j)=0;
    for i=1:L
        S(j)=S(j)+w(i)^(j-1)*Re(i);
    end
end
for j=1:NN
    T(j)=0;
    for i=1:L
        T(j)=T(j)+w(i)^(j-1)*Im(i);
    end
end
for j=1:NN
    U(j)=0;
    for i=1:L
        U(j)=U(j)+w(i)^(j-1)*(Re(i)^2+Im(i)^2);
    end
end
U
%----------------���ɴ�ϵ������A-----------------
%����A11,��СΪ(m+1)X(m+1)
for i=1:m+1
    for j=1:m+1
        if mod(i+j,2)~=0
            A11(i,j)=0;  
        else
            if mod(i,2)~=0    %������
                A11(i,j)=(-1)^((j+1)/2+1)*V(i+j-1);
            else
                A11(i,j)=(-1)^(j/2+1)*V(i+j-1);
            end
        end
    end
end
%����A12,��СΪ(m+1)Xn
for i=1:m+1
    for j=1:n
        if mod(i+j,2)==0
            if mod(i,2)~=0     %������
                A12(i,j)=(-1)^((j+1)/2+1)*T(i+j);
            else
                A12(i,j)=(-1)^(j/2+1)*T(i+j);
            end         
        else
            if mod(i,2)~=0     %������
                A12(i,j)=(-1)^(j/2+1)*S(i+j);
            else
                A12(i,j)=(-1)^((j+1)/2)*S(i+j);
            end            
        end
    end
end
%����A21����СΪnX(m+1)
for i=1:n
    for j=1:m+1
        if mod(i+j,2)==0
            if mod(i,2)~=0
                A21(i,j)=(-1)^((j+1)/2+1)*T(i+j);
            else
                A21(i,j)=(-1)^(j/2+1)*T(i+j);
            end         
        else
            if mod(i,2)~=0     %������
                A21(i,j)=(-1)^(j/2)*S(i+j);
            else
                A21(i,j)=(-1)^((j+1)/2+1)*S(i+j);
            end          
        end
    end
end
%����A22����СΪnXn
for i=1:n
    for j=1:n
        if mod(i+j,2)~=0
            A22(i,j)=0;            
        else
            if mod(i,2)~=0
                A22(i,j)=(-1)^((j+1)/2+1)*U(i+j+1);        
            else
                A22(i,j)=(-1)^(j/2+1)*U(i+j+1); 
            end
        end
    end
end
A=[A11 A12;A21 A22];
%����B��
for i=1:m+1
    if mod(i,2)~=0
        B1(i)=S(i);
    else
        B1(i)=T(i);
    end
end
for i=1:n
    if mod(i,2)~=0;
        B2=0;
    else
        B2(i)=U(i+1);
    end    
end
B2
B=[B1.';B2.'];
%����ϵ��
X=A\B;
b=X(1:m+1)       %b0,b1,...
a=X(m+2:n+m+1)   %a1,a2,...

sy=tf(a',b');
figure;
bode(sy);
