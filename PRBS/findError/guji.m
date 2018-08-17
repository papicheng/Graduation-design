function y=guji(k,j,y,w)
for i=1:4
    a(i,1)=1;
    a(i,2)=k+5-i;
    a(i,3)=(k+5-i)^2;
    l(i,1)=y(j+k+5-i);
end
for i=5:8
    a(i,1)=1;
    a(i,2)=5-i;
    a(i,3)=(5-i)^2;
    l(i,1)=y(j+5-i);
end
for i=1:k
    b(i,1)=1;
    b(i,2)=k+1-i;
    b(i,3)=(k+1-i)^2;
end
h=b*(a'*a)^(-1)*a'*l;
for i=1:k
    if abs(y(j+k+1-i)-h(i))>w
        y(j+k+1-i)=h(i);
    end
end