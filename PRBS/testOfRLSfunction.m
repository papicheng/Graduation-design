clear
clc
close all
x = [0 1 0 1 1 0 1 1 1];
n = 400;                
u = [];                  
for i=1:n
    temp = xor(x(4),x(9));
    u(i) = x(9);
    for j = 9:-1:2
        x(j) = x(j-1);
    end
    x(1) = temp;
end
v = randn(1,398);
z = zeros(400,1);
z(1) = -1;
z(2) = 0;
for i=3:400
z(i) = 1.5*z(i-1)-0.7*z(i-2)+u(i-1)+0.5*u(i-2)+v(i-2);
end
a = RLS(2,2,z,u,'RLS',[],2);