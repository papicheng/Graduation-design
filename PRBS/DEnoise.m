clc
clear
close all

%设置信噪比和随机种子值
snr=4;
init=2055615866;
%产生原始信号sref和高斯白噪声污染的信号s
[sref,s]=wnoise(1,11,snr,init);
%用db1小波对原始信号进行3层分解并提取系数
[c,l]=wavedec(s,3,'db1');
a3=appcoef(c,l,'db1',3);
d3=detcoef(c,l,3);
d2=detcoef(c,l,2);
d1=detcoef(c,l,1);
thr=1;
%进行硬阈值处理
ythard1=wthresh(d1,'h',thr);
ythard2=wthresh(d2,'h',thr);
ythard3=wthresh(d3,'h',thr);
c2=[a3 ythard3 ythard2 ythard1];
s3=waverec(c2,l,'db1');
%进行软阈值处理
ytsoftd1=wthresh(d1,'s',thr);
ytsoftd2=wthresh(d2,'s',thr);
ytsoftd3=wthresh(d3,'s',thr);
c3=[a3 ytsoftd3 ytsoftd2 ytsoftd1];
s4=waverec(c3,l,'db1');
%对上述信号进行图示
subplot(5,1,1);plot(sref);title('参考信号');
subplot(5,1,2);plot(s);title('染噪信号');
subplot(5,1,3);plot(s3);title('硬阈值处理');
subplot(5,1,4);plot(s4);title('软阈值处理');