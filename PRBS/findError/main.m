clc
clear
close all
fs=1e3;
T=0.05;
t=0:1/fs:T;
fc=50;
%%%%ÐÅºÅÉú³É%%%%
yy=3*t.*t.*t-2*t.*t+5*t+9+3*sin(4*t)+cos(2*pi*fc*t);
plot(t,yy);hold on;
% yy(16)=yy(16)-2;
% yy(17)=yy(17)-1;
% yy(24:25)=yy(24:25)+3;
% yy(37)=yy(37)+4;
% yy(38)=yy(38)+2;
% yy(40)=yy(40)/2;
vv=randn(1,length(yy));
yy=yy+vv;


y=yy;
L=length(y);
i=5;
while i<L
    [u,delta,i]=pand(y,i,L);
    if i==L
    else
        j=i-1;
        w=delta;
        [u,delta,i]=pand1(y,i,L);
        k=i-j;
        y=guji(k,j,y,w);
        i=k+j;
        
        plot(t(j),yy(j),'o',t(i+1),yy(i+1),'o');
        hold on;
    end
end
plot(t,y,':',t,yy);
hold off;
