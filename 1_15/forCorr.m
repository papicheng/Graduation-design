t = (1:0.5:100)';
w = 2*pi;
x1=sin(w*t);
x2=cos(w*t+pi/2);
x3=sin(w*t-pi/2);
x1_x2 = min(min(corrcoef(x1, x2)))
x1_x3 = min(min(corrcoef(x1, x3))) 
figure;
plot(x1);hold on;grid on;
plot(x2);
plot(x3);
legend('1','2','3');