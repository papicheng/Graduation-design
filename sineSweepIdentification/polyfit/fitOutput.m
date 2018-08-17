%输出数据去趋势

clc
close all
clear

data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f151_Gain_2500_043353.txt');
x=data(:,1);

x=x(400:1000);

% j=i;
% k=i;
% j=j+1;
% if x(j)>x(k)
%     while x(j)>x(k)
%         k=j;
%         j=j+1;
%     end
%     t(1)=i+(j-i)/2;
%     y(1)=(x(j)-x(i))/2;
% 
% end


% 节点信息  
% data=[105.03 99.18 84.965 72.445 68.994 77.265...  
%     91.052 100.61 98.215 86.363 74.439 71.625...  
%     80.061 92.18 97.823 91.483 80.241 73.616...  
%     78.547 89.084 94.924 89.689 79.898 75.485...  
%     81.544 89.485 90.578 83.712 77.401 80.18...  
%     86.904 88.721 83.468 78.971 81.983 86.25...  
%     85.224 80.901 80.808 84.488];  
data=x;
% % 微分变号信息  
% c=findpeaks(data);  
% IndMin=find(diff(sign(diff(data)))>0)+1;   %获得局部最小值的位置  
% IndMax=find(diff(sign(diff(data)))<0)+1;   %获得局部最大值的位置  
% figure; hold on;
% box on;  
% plot(1:length(data),data);  
% plot(IndMin,data(IndMin),'r^')  
% plot(IndMax,data(IndMax),'k*')  
% legend('曲线','波谷点','波峰点')  
% title('计算离散节点的波峰波谷信息', 'FontWeight', 'Bold');  

xmax1=max(x);
[xmin1,mini1]=min(x);
xinv=xmax1-x;
[xmax,maxi]= findpeaks(x);%,'minpeakdistance',300);
[xmin,mini]=findpeaks(xinv);%,'minpeakdistance',300);
xmin=data(mini);
mini_=[mini1;mini];
IndMin=mini;IndMax=maxi;

len=min(length(IndMin),length(IndMax));
for i=1:len
    hen(i)=(IndMax(i)-IndMin(i))/2+IndMin(i);
    zong(i)=(data(IndMax(i))-data(IndMin(i)))/2+data(IndMin(i));
end
hen_=hen;
zong_=zong;
mini=mini_;
IndMin=mini;IndMax=maxi;
len=min(length(IndMin),length(IndMax));
for i=1:len
    hen(i)=(IndMax(i)-IndMin(i))/2+IndMin(i);
    zong(i)=(data(IndMax(i))-data(IndMin(i)))/2+data(IndMin(i));
end
le1=length(hen);
le2=length(hen_);
[a,b]=sorting([hen,hen_]);
for i=1:(le1+le2)
    if b(i)<=le1
        e(i)=zong(b(i));
    else
        e(i)=zong_(b(i)-le1);
    end
end

        




figure('color',[1 1 1]);
plot(x);hold on;
plot(a,e);
plot(hen,zong,'*');
plot(hen_,zong_,'*');
xx=[hen,hen_];
xx=sort(xx);
y1=polyfit(a,e,7);
f=polyval(y1,1:length(x));
f=f';
x=x-f;
plot(f);
plot(x);


for i=1:length(hen)
    interx(i*2-1)=hen(i);
    intery(i*2-1)=zong(i);
    interx(i*2)=hen_(i);
    intery(i*2)=zong_(i);
end
xi=hen(1):1:hen_(end);
yi=interp1(interx(2:end),intery(2:end),xi);
figure('color',[1 1 1]);
plot(interx,intery,'o-');hold on;
x=data(:,1);
plot(hen(1):1:hen_(end),x(hen(1):1:hen_(end)));
py=x(xi)-yi';
plot(xi,py)
grid on
title('去趋势示意图')
xlabel('采样点数')
ylabel('输出数据')
legend('分段线性插值','原始数据','处理后的数据')

grid on;
zoom on;
plot(hen(1):1:hen_(end),yi)
function [a,b]=sorting(A)
n = length(A);
b=1:n;
for i = 1:n-1
    for j = i+1:n
        if A(i)>A(j)
            temp = A(i);
            A(i) = A(j);
            A(j) = temp;
            te=b(i);
            b(i)=b(j);
            b(j)=te;
        end
    end
end
a=A;
end