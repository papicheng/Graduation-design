clear
tic;
h=waitbar(0,'奴家正在努力计算，请主子稍安勿躁');
n=1;
for i=1:10e+2;
    waitbar(i/10e+2)
    n=n+i;
end
close(h)
toc