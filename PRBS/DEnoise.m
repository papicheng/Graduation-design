clc
clear
close all

%��������Ⱥ��������ֵ
snr=4;
init=2055615866;
%����ԭʼ�ź�sref�͸�˹��������Ⱦ���ź�s
[sref,s]=wnoise(1,11,snr,init);
%��db1С����ԭʼ�źŽ���3��ֽⲢ��ȡϵ��
[c,l]=wavedec(s,3,'db1');
a3=appcoef(c,l,'db1',3);
d3=detcoef(c,l,3);
d2=detcoef(c,l,2);
d1=detcoef(c,l,1);
thr=1;
%����Ӳ��ֵ����
ythard1=wthresh(d1,'h',thr);
ythard2=wthresh(d2,'h',thr);
ythard3=wthresh(d3,'h',thr);
c2=[a3 ythard3 ythard2 ythard1];
s3=waverec(c2,l,'db1');
%��������ֵ����
ytsoftd1=wthresh(d1,'s',thr);
ytsoftd2=wthresh(d2,'s',thr);
ytsoftd3=wthresh(d3,'s',thr);
c3=[a3 ytsoftd3 ytsoftd2 ytsoftd1];
s4=waverec(c3,l,'db1');
%�������źŽ���ͼʾ
subplot(5,1,1);plot(sref);title('�ο��ź�');
subplot(5,1,2);plot(s);title('Ⱦ���ź�');
subplot(5,1,3);plot(s3);title('Ӳ��ֵ����');
subplot(5,1,4);plot(s4);title('����ֵ����');