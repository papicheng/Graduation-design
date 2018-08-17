num=tf4.Numerator;
den=tf4.Denominator;
T=1/4000;
sy=tf(num,den);
figure;
% dbode(num,den,T);
bode(sy);