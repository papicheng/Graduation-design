close all
clear
clc

A=10;
beta=0.3;
f0=1;
t=(0:500)*0.01;
x=A*cos(2*pi*(beta.*t+f0).*t);
plot(t,x,'k');
grid on
xlabel('t/(s)')
ylabel('x(t)')