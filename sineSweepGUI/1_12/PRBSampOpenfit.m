clc
clear
close all

filename=0;
[filename, pathname] = uigetfile('*.txt','ѡ���ļ�');
if isequal(filename,0)
    return;
else
    cd(pathname);
    data=load(filename);
    fs=4000;%����Ƶ��4000hz
    dt=1/fs;%���ݲɼ�ʱ���m������λ����������ͬ
    TN=2^17-1;
    N=TN;
    %---�ж�˭������ ����һ����0��ʼ�������������0��ʼ�������ȵ���0��------------------------%
    input_row=1;output_row=2;
    %             ini=1;injudge=1;
    M1=data(:,input_row);z1=data(:,output_row);
    testin=abs(M1(15:30));
    testout=abs(z1(15:30));
    if std(testin,0)>std(testout,0)
        temp=M1;
        M1=z1;
        z1=temp;
    end
    %-----------------------------------------------------------------------------------%
    
    mi=1;
    while M1(mi)==0
        mi=mi+1;
    end
    M1_len=length(M1);
    z1=diff(z1)*4000;
% b=fir1(40, 2000/(fs/2));
% z=filter(b,1,z);  %�ź�ͨ���˲���


        M=M1(mi:mi+N-1);
        z=z1(mi:mi+N-1);

   MM=M;

    
    Mfft=fft(M);
    zfft=fft(z);
    Np=length(M);
    
    phase_diff=(angle(zfft(2:Np/2+1))-angle(Mfft(2:Np/2+1)))*180/pi;
    
    %             f = Fs*(0:(Np/2))/Np;
    Mmag2 = abs(Mfft/Np);
    Mmag1 = Mmag2(1:Np/2+1);%ע��+1
    Mmag1(2:end-1) = 2*Mmag1(2:end-1);
    zmag2 = abs(zfft/Np);
    zmag1 = zmag2(1:Np/2+1);%ע��+1
    zmag1(2:end-1) = 2*zmag1(2:end-1);
    magr=zmag1./Mmag1;
    G=20*log10(magr);%bodeͼ��ֵ
    G=G(2:Np/2+1);
    x=[1:Np/2]*(fs/Np);
    x=x';
end
% G1=lowp(G,500,550,0.3,30,fs);
 figure;
    plot(x,zmag1(2:Np/2+1));grid on;hold on;
    zmagfit=zmag1(2:Np/2+1);
    
% y1=polyfit(x,zmagfit,7);
% yy=polyval(y1,x);
A = medfilt1(zmagfit,50);
A(1:10)=A(10);


% function y=LMSsmooth(data,k)%kʱ���ͷLMS�㷨�˲�������,k=100,u��������
data=zmagfit;
k=20;

%{
u=1/4000;
N=length(data);
y=zeros(1,N);
e=zeros(1,N);

y(1:k)=data(1:k);     %�������źŵ�ǰk��ֵ��Ϊ���y��ǰk��ֵ
w=1/k*ones(1,k);                                        %���ó�ͷ��Ȩ��ֵ
%��LMS�㷨�����˲�
for i=(k+1):N
        XN=data((i-k+1):(i));
        y(i)=w*XN;
        e(i)=data(i)-y(i);
        w=w+2*u*e(i)*XN';
end
% end

yyyyy=y;
%}
% nlong=300;
% len=length(zmagfit);
% smoothy1=zmagfit;
% for i=1:len-nlong
%     smoothy(i)=sum(x(i:i+nlong-1))/nlong;
% end



% XC=moving_average(XC,500);

yyy=moving_average(A,200);
% yyyy=moving_average(XC,300);
% yyyyy=LMSsmooth(zmagfit,100);
 plot(x,A);   
 plot(x,yyy);
%  plot(x,yyyyy);
 legend('1','2','3','4');
 %�ջ�

 
 
 %����
%   magr1=XC(1:100)./Mmag1(2:101);
%  magr2=yyy(101:length(x))./Mmag1(102:length(Mmag1));
 
toal= [A(1:6553);yyy(6554:end)];
 magr=toal./Mmag1(2:end);
 
%   magr=magr./Mmag1(2:end);
    G=20*log10(magr);%bodeͼ��ֵ
    G=G(1:Np/2);  
    
    
figure;
    semilogx(x,G);grid on;hold on;
   
% semilogx(x,G1);
    title('��Ƶͼ�Ա�');
dd=load('openSine_f_amp_phase.txt');
ff=dd(:,1);
aa=dd(:,2);
semilogx(ff,20*log10(aa));hold on;
ddd=load('closesine_f_amp_phase.txt');
fff=ddd(:,1);
aaa=ddd(:,2);
semilogx(fff,20*log10(aaa));hold on;
% legend('PRBS','open','close')

 



%Ӧ��db5��ΪС����������3��ֽ�
%������ƫ��Ȼ������ֵ
%�����ݽ���ȥ�봦��
% n=size(z);
s=z(1:2000);
%С���ֽ�
[C L]=wavedec(z,6,'db5');
%��c����ȡ�߶�3�µĽ���С��ϵ��
cA3=appcoef(C,L,'db5',6);
%���ź�c����ȡ�߶�1,2,3�µ�ϸ��С��ϵ��
cD1=detcoef(C,L,1);
cD2=detcoef(C,L,2);
cD3=detcoef(C,L,3);
%ʹ��stein����ƫ��Ȼ����ԭ�����ѡ��������ֵ
%cD1,cD2,cD3Ϊ����С��ϵ��
%'rigrsure'Ϊ��ƫ��Ȼ������ֵ����
thr1=thselect(cD1,'rigrsure');
thr2=thselect(cD2,'rigrsure');
thr3=thselect(cD3,'rigrsure');
%�������ֵ
TR=[thr1,thr2,thr3];
%'s'Ϊ����ֵ��'h'ΪӲ��ֵ
SORH='h';
%ȥ��
%XCΪȥ����ź�
%[CXC,LXC]ΪС���ֽ�ṹ
%PERF0��PERF2�ǻָ���ѹ���ķ����ٷֱ�
%'lvd'Ϊ�������ø������ֵ
%'gbl'Ϊ�̶���ֵ
%3Ϊ��ֵ�ĳ���
[XC,CXC,LXC,PERF0,PERF2]=wdencmp('lvd',z,'db5',3,TR,SORH);
%ȥ��Ч��������SNRԽ��Ч��Խ�ã�MSEԽСԽ��
%ѡȡ�źŵĳ���
% N=n(2);
N=length(z);
x=z;
y=XC;
F=0;
M=0;
for ii=1:N
    m(ii)=(x(ii)-y(ii))^2;
    t(ii)=y(ii)^2;
    f(ii)=t(ii)/m(ii);
    F=F+f(ii);
    M=M+m(ii);
end;
SNR=10*log10(F);
MSE=M/N;
SM=SNR/MSE;
%�Ա�ԭʼ�źźͳ������ź�
% figure;
% subplot(2,1,1);
% plot(s);
% title('ԭʼ�ź�');
% subplot(2,1,2);
% plot(XC);
% title('�������ź�');
% SNR,MSE
zzz=XC;


z=MM;
%Ӧ��db5��ΪС����������3��ֽ�
%������ƫ��Ȼ������ֵ
%�����ݽ���ȥ�봦��
% n=size(z);
s=z(1:2000);
%С���ֽ�
[C L]=wavedec(z,6,'db5');
%��c����ȡ�߶�3�µĽ���С��ϵ��
cA3=appcoef(C,L,'db5',6);
%���ź�c����ȡ�߶�1,2,3�µ�ϸ��С��ϵ��
cD1=detcoef(C,L,1);
cD2=detcoef(C,L,2);
cD3=detcoef(C,L,3);
%ʹ��stein����ƫ��Ȼ����ԭ�����ѡ��������ֵ
%cD1,cD2,cD3Ϊ����С��ϵ��
%'rigrsure'Ϊ��ƫ��Ȼ������ֵ����
thr1=thselect(cD1,'rigrsure');
thr2=thselect(cD2,'rigrsure');
thr3=thselect(cD3,'rigrsure');
%�������ֵ
TR=[thr1,thr2,thr3];
%'s'Ϊ����ֵ��'h'ΪӲ��ֵ
SORH='s';
%ȥ��
%XCΪȥ����ź�
%[CXC,LXC]ΪС���ֽ�ṹ
%PERF0��PERF2�ǻָ���ѹ���ķ����ٷֱ�
%'lvd'Ϊ�������ø������ֵ
%'gbl'Ϊ�̶���ֵ
%3Ϊ��ֵ�ĳ���
[XC,CXC,LXC,PERF0,PERF2]=wdencmp('lvd',z,'db5',3,TR,SORH);
%ȥ��Ч��������SNRԽ��Ч��Խ�ã�MSEԽСԽ��
%ѡȡ�źŵĳ���
% N=n(2);
N=length(z);
x=z;
y=XC;
F=0;
M=0;
for ii=1:N
    m(ii)=(x(ii)-y(ii))^2;
    t(ii)=y(ii)^2;
    f(ii)=t(ii)/m(ii);
    F=F+f(ii);
    M=M+m(ii);
end;
SNR=10*log10(F);
MSE=M/N;
SM=SNR/MSE;

MMM=XC;


z=zzz;
M=MMM;
 Mfft=fft(M);
    zfft=fft(z);
    Np=length(M);
    
    
    phase_diff=(angle(zfft(2:Np/2+1))-angle(Mfft(2:Np/2+1)))*180/pi;
    
    %             f = Fs*(0:(Np/2))/Np;
    Mmag2 = abs(Mfft/Np);
    Mmag1 = Mmag2(1:Np/2+1);%ע��+1
    Mmag1(2:end-1) = 2*Mmag1(2:end-1);
    zmag2 = abs(zfft/Np);
    zmag1 = zmag2(1:Np/2+1);%ע��+1
    zmag1(2:end-1) = 2*zmag1(2:end-1);
    magr=zmag1./Mmag1;
    G=20*log10(magr);%bodeͼ��ֵ
    G=G(2:Np/2+1);
    x=[1:Np/2]*(fs/Np);
    x=x';
% semilogx(x,G);
% legend('PRBS','open','close','XC')






















    
    
function y=lowp(x,f1,f3,rp,rs,Fs)
%��ͨ�˲�
%ʹ��ע�����ͨ��������Ľ�ֹƵ�ʵ�ѡȡ��Χ�ǲ��ܳ��������ʵ�һ��
%����f1,f3��ֵ��ҪС�� Fs/2
%x:��Ҫ��ͨ�˲�������
% f 1��ͨ����ֹƵ��
% f 3�������ֹƵ��
%rp���ߴ���˥��DB������
%rs����ֹ��˥��DB������
%FS������x�Ĳ���Ƶ��
% rp=0.1;rs=30;%ͨ����˥��DBֵ�������˥��DBֵ
% Fs=2000;%������
%
wp=2*pi*f1/Fs;
ws=2*pi*f3/Fs;
% ����б�ѩ���˲�����
[n,wn]=cheb1ord(wp/pi,ws/pi,rp,rs);
[bz1,az1]=cheby1(n,rp,wp/pi);
%�鿴����˲���������
% [h,w]=freqz(bz1,az1,256,Fs);
% h=20*log10(abs(h));
% figure;plot(w,h);title('������˲�����ͨ������');grid on;
%
y=filter(bz1,az1,x);%������x�˲���õ�������y
end
function [ y ] = moving_average( x, win_size )
    y1=filter(ones(1,win_size/2+1)/win_size,1,x);
    y2=filter(ones(1,win_size/2+1)/win_size,1,fliplr(x));
    y=y1+fliplr(y2)-(1/win_size)*x;
end


%{
function data=smoothdata(data,N)
size=length(data);
sum1=0;
for j=1:size
    if j<N/2
        for k=1:N
            sum1=sum1+data(j+k);
        end
        data(j)=sum1/N;
    else
        if j<size-N/2
            for k=1:N/2
                sum1=sum1+data(j+k)+data(j-k+1);
            end
            data(j)=sum1/N;
        else
            for k=1:size
                sum1=sum1+data(j+k-1);
            end
            for k=1:(N-size+j)
                sum1=sum1+data(j-k+1);
            end
            data(j)=sum1/N;
        end
    end
    sum1=0;
end
end
%}

% function y=smoothdata(x,N)
% len=length(x);
% for i=1:len-N
%     y(i)=sum(x(i:i+N-1))/N;
% end
% end






