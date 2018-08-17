clc
clear

%y_=[ya1 ya2 ya3 ya4 ya5 ya6 ya7 ya8 ya9 ya10 ya11 ya12 ya13 ya14 ya15 ya16 ya17 ya18 ya19];
w_=([1:0.5:10]*2*pi)';
for i=1:19
%y=y_(:,i);
%t_=t(10000:15000);
t=0:0.001:99999*0.001;
t=t';
t_=t(25000:75000);
w=w_(i);
u=0.5*sin(w*t);
num=[133];
den=[1 25 10];
G=tf(num,den);
y=lsim(G,u,t);
y=y(25000:75000);
u=u(25000:75000);
if i==1
    [m,n]=lsqident(u,y,0,2)
end
l=[sin(w*t_),cos(w*t_)];
c=(l'*l)^(-1)*l'*y;
Af(i)=(c(1)^2+c(2)^2)^0.5;
faie(i)=atan(c(2)/c(1))-pi;
end
g=Af/0.5;
M=20*log10(g);
hp=g.*(cos(faie)+j*sin(faie));
% hp=g-faie*j;
[b,a]=invfreqs(hp,w_,0,2)
syss1=tf(b,a);
t=0:0.01:10000;
y1=step(syss1,t);
plot(t,y1);
hold on;
syss2=tf(m,n);
y2=step(syss2,t);
plot(t,y2);