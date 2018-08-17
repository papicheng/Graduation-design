clc
clear 
close all
num=[1];
den=[1 3 2 0];
sf=tf(num,den);
bode(sf);
grid on;zoom on;