function [num,den]=lsqident(u,y,m,n)
M=length(u);Y=y(n+1:M);
for i=1:length(Y)
    X(i,:)=[-y(n+i-1:-1:i)' u(m+i:-1:i)'];
end
t=X\Y;den=[1 t(1:n)'];num=t(n+1:length(t))';