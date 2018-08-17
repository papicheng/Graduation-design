clc
clear 
close all
N=4000;%8192*2-1;
fs=4000;
dt=1/fs;
t = [0:N-1]*dt;
f = 10.0;
s1 = sin(2*pi*f*t+0*pi/180);
s2 = sin(2*pi*f*t-300*pi/180);
x = xcorr(s1,s2,'coeff');
tx = [-N+1:N-1]*dt;
plot(tx,x);grid on; zoom on;
[m,n]=max(x);
jiao=tx(n)*360*f;
% if jiao<-180
%     jiao=jiao-360;
% end
% if jiao>180
%     jiao=jiao-360;
% end

jiao
figure;
plot(t,s1,t,s2);