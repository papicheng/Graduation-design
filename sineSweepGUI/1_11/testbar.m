clear
tic;
h=waitbar(0,'ū������Ŭ�����㣬�������԰�����');
n=1;
for i=1:10e+2;
    waitbar(i/10e+2)
    n=n+i;
end
close(h)
toc