%利用残差的方差估计模型的阶次
%方崇智，过程辨识，清华大学出版社；P345，例13.4
%===================================
close all
clear
clc
data=load('G:\study\GraduationThesis\dataOfSine\X-Y-Table-速度闭环\X-Y-Table-Y轴速度闭环Prbs\Axis2_RefVel_EncVel_Prbs_Gain_20_115019.txt');
M=data(:,1);
z=data(:,2);
M=M(3:6007);
z=z(3:6008);
M=M';
z=z';
%==========产生M序列作为输入===============
x=[0 1 0 1 1 0 1 1 1]; %initial value
n=1003; %n为脉冲数目
% M=[]; %存放M序列
% for i=1:n
% temp=xor(x(4),x(9));
% M(i)=x(9);
% for j=9:-1:2
% x(j)=x(j-1);
% end
% x(1)=temp;
% end
% %产生高斯白噪声
% v=randn(1,1004);
% z=[];
% z(1)=-1;
% z(2)=0;
L=4000;
% for i=3:L+4
% z(i)=1.5*z(i-1)-0.7*z(i-2)+M(i-1)+0.5*M(i-2)+v(i);
% end
% 模型阶次n=1
for i=1:L
H1(i,1)=z(i);
H1(i,2)=M(i);
end
estimate=inv(H1'*H1)*H1'*z(2:4001)';
e=z(2:4001)'-H1*estimate;
V1=e'*e/L;
% 模型阶次n=2
for i=1:L
H2(i,1)=z(i+1);;
H2(i,2)=z(i);
H2(i,3)=M(i+1);
H2(i,4)=M(i);
end
estimate=inv(H2'*H2)*H2'*z(3:4002)';
e=z(3:4002)'-H2*estimate;
V2=e'*e/L;
% 模型阶次n=3
for i=1:L
H3(i,1)=z(i+2);
H3(i,2)=z(i+1);
H3(i,3)=z(i);
H3(i,4)=M(i+2);
H3(i,5)=M(i+1);
H3(i,6)=M(i);
end
estimate=inv(H3'*H3)*H3'*z(4:4003)';
e=z(4:4003)'-H3*estimate;
V3=e'*e/L;
% 模型阶次n=4
for i=1:L
H4(i,1)=z(i+3);
H4(i,2)=z(i+2);
H4(i,3)=z(i+1);
H4(i,4)=z(i);
H4(i,5)=M(i+3);
H4(i,6)=M(i+2);
H4(i,7)=M(i+1);
H4(i,8)=M(i);
end
estimate=inv(H4'*H4)*H4'*z(5:4004)';
e=z(5:4004)'-H4*estimate;
V4=e'*e/L;
% 模型阶次n=5
for i=1:L
H5(i,1)=z(i+4);
H5(i,2)=z(i+3);
H5(i,3)=z(i+2);
H5(i,4)=z(i+1);
H5(i,5)=z(i);
H5(i,6)=M(i+4);
H5(i,7)=M(i+3);
H5(i,8)=M(i+2);
H5(i,9)=M(i+1);
H5(i,10)=M(i);
end
estimate=inv(H5'*H5)*H5'*z(6:4005)';
e=z(6:4005)'-H5*estimate;
V5=e'*e/L;
% 模型阶次n=6
for i=1:L
H6(i,1)=z(i+5);
H6(i,2)=z(i+4);
H6(i,3)=z(i+3);
H6(i,4)=z(i+2);
H6(i,5)=z(i+1);
H6(i,6)=M(i);
H6(i,7)=M(i+5);
H6(i,8)=M(i+4);
H6(i,9)=M(i+3);
H6(i,10)=M(i+2);
H6(i,11)=M(i+1);
H6(i,12)=M(i);
end
estimate=inv(H6'*H6)*H6'*z(7:4006)';
e=z(7:4006)'-H6*estimate;
V6=e'*e/L;
% 模型阶次n=7
for i=1:L
H7(i,1)=z(i+6);
H7(i,2)=z(i+5);
H7(i,3)=z(i+4);
H7(i,4)=z(i+3);
H7(i,5)=z(i+2);
H7(i,6)=z(i+1);
H7(i,7)=z(i);
H7(i,8)=M(i+6);
H7(i,9)=M(i+5);
H7(i,10)=M(i+4);
H7(i,11)=M(i+3);
H7(i,12)=M(i+2);
H7(i,13)=M(i+1);
H7(i,14)=M(i);
end
estimate=inv(H7'*H7)*H7'*z(8:4007)';
e=z(8:4007)'-H7*estimate;
V7=e'*e/L;
plot(1:5,[V1 V2 V3 V4 V5])
title('利用残差的方差估计模型的阶次')
xlabel('阶次')
ylabel('残差方差')