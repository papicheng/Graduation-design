%Hankel矩阵法辨识模型阶次
%方崇智，过程辨识，清华大学出版社，P332
%========================================
clear
clc
clear 
close all

g=[1 0.8 0.65 0.54 0.46 0.39 0.35 0.31 0.28 0.26 0.24 0.23 0.22 0.21 0.20 0.19 0.19 0.18 0.18 0.18 0.17 0.17 0.17 0.16 0.16 0.15 0.15 0.15 0.15 0.14 0.14 0.14 0.13 0.13 0.13 0.13 0.12 0.12 0.12 0.12 0.12 0.11 0.11 0.11 0.11 0.11 0.11 0.11];
plot(g);
% data=load('closeloop_pulse_g.txt');
% g=data(:,1);
glen=length(g);
%L=2
s1=0;
for i=1:glen-2
h1=[g(i) g(i+1);
g(i+1) g(i+2)];
s1=s1+det(h1);
end
%L=3
s2=0;
for i=1:glen-4
h2=[g(i) g(i+1) g(i+2);
g(i+1) g(i+2) g(i+3);
g(i+2) g(i+3) g(i+4)];
s2=s2+det(h2);
end
%L=4;
s3=0;
for i=1:glen-6
h3=[g(i) g(i+1) g(i+2) g(i+3);
g(i+1) g(i+2) g(i+3) g(i+4);
g(i+2) g(i+3) g(i+4) g(i+5);
g(i+3) g(i+4) g(i+5) g(i+6)];
s3=s3+det(h3);
end
%L=5;
s4=0;
for i=1:glen-8
h4=[g(i) g(i+1) g(i+2) g(i+3) g(i+4);
g(i+1) g(i+2) g(i+3) g(i+4) g(i+5);
g(i+2) g(i+3) g(i+4) g(i+5) g(i+6);
g(i+3) g(i+4) g(i+5) g(i+6) g(i+7);
g(i+4) g(i+5) g(i+6) g(i+7) g(i+8)];
s4=s4+det(h4);
end
%L=6;
s5=0;
for i=1:glen-10
h5=[g(i) g(i+1) g(i+2) g(i+3) g(i+4) g(i+5);
g(i+1) g(i+2) g(i+3) g(i+4) g(i+5) g(i+6);
g(i+2) g(i+3) g(i+4) g(i+5) g(i+6) g(i+7);
g(i+3) g(i+4) g(i+5) g(i+6) g(i+7) g(i+8);
g(i+4) g(i+5) g(i+6) g(i+7) g(i+8) g(i+9)
g(i+5) g(i+6) g(i+7) g(i+8) g(i+9) g(i+10)];
s5=s5+det(h5);
end
D2=(s1/glen-2)/(s2/glen-4)
D3=(s2/glen-4)/(s3/glen-6)
D4=(s3/glen-6)/(s4/glen-8)
D5=(s4/glen-8)/(s5/glen-10)