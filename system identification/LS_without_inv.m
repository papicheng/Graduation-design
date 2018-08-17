% 不需矩阵求逆的最小二乘法进行参数辨识
clear;clc;
load('uy1.mat');
n=2;                            %系统阶数
N=length(u)-n;                  %矩阵维数
Y=y(n+1:n+N,1);                 %输出矩阵
%系统阶数为1，第1次运算
Psi11=-y(2:499);
Phi11=Psi11;
X11=1/(Psi11'*Psi11);
%系统阶数为1，第2次运算
Psi12=u(2:499);
Phi12=[Phi11,Psi12];
B22=1/(Psi12'*Psi12-Psi12'*Phi11*X11*Phi11'*Psi12);
B12=-X11*Phi11'*Psi12*B22;
B21=B12';
B11=X11-B12*Psi12'*Phi11*X11;
X12=[B11,B12;B21,B22];
%系统阶数为2，第1次运算
Psi21=-y(1:498);
Phi21=[Phi12,Psi21];
B22=1/(Psi21'*Psi21-Psi21'*Phi12*X12*Phi12'*Psi21);
B12=-X12*Phi12'*Psi21*B22;
B21=B12';
B11=X12-B12*Psi21'*Phi12*X12;
X21=[B11,B12;B21,B22];
%系统阶数为2，第2次运算
Psi22=u(1:498);
Phi22=[Phi21,Psi22];
B22=1/(Psi22'*Psi22-Psi22'*Phi21*X21*Phi21'*Psi22);
B12=-X21*Phi21'*Psi22*B22;
B21=B12';
B11=X21-B12*Psi22'*Phi21*X21;
X22=[B11,B12;B21,B22];
%辨识结果
theta2=X22*Phi22'*Y;
theta=[theta2(1);theta2(3);theta2(2);theta2(4)]



