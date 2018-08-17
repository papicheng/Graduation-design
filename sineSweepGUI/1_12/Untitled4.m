clc
clear
close all
openflag=0;
filename=0;
[filename, pathname] = uigetfile({'*.txt';'*.xlsx'},'选择文件');
if isequal(filename,0)
    return;
else
    cd(pathname);
    data=load(filename);
    fs=4000;%采样频率4000hz
    dt=1/fs;%数据采集时间和m序列移位脉冲周期相同
    TN=2^17-1;
    N=4000;
    df=fs/N;
    Mamp=0.110486286083016;%未转换，fft直接绝对值
    %---判断谁是输入 输入一定从0开始，如果两个都从0开始，输入先到非0数------------------------%
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
    endi=length(M1);
    while M1(endi)==0
        endi=endi-1;
    end
    lenM1=endi-mi+1;
    M=M1(mi:endi);
    z=z1(mi:endi);
    
    
%     z=diff(z)*4000;
%     z=[0;z];
    
    Mfft=fft(M);
    zfft=fft(z);
    Np=length(M);
    df=fs/Np;
    
    Mmag2 = abs(Mfft);
    Mmag1 = Mmag2(1:Np/2+1);%注意+1
    Mmag1(2:end-1) = Mmag1(2:end-1);
    zmag2 = abs(zfft);
    zmag1 = zmag2(1:Np/2+1);%注意+1
    zmag1(2:end-1) = zmag1(2:end-1);
    magr=zmag1./Mmag1;
    %     G=20*log10(magr);%bode图幅值
    %     G=G(2:Np/2+1);
    x=[1:Np/2]*(fs/Np);
    x=x';
    x=x*2*pi;
end
figure;
% plot(x,zmag1(2:Np/2+1));grid on;hold on;
zmagfit=zmag1(2:Np/2+1);

G=zmagfit./Mmag1(2:end);


G=20*log10(G);%bode图幅值




if Np<=6000
    movepoint=20;
end
if Np>6000&&Np<=10000
    movepoint=40;
end
if Np>10000
    movepoint=100;
end







A = medfilt1(G,30);
yyy=moving_average(A,movepoint);
semilogx(x,A);grid on;hold on;
semilogx(x,yyy);
figure;
semilogx(x,G);grid on;hold on;
yyy__=yyy;
% revisepoint=8;
% movepoint=round(revisepoint/df);
% yyy(1:end-movepoint+1)=yyy__(movepoint:end);
fitpoint=floor(1/df);
if fitpoint==0
    fitpoint=1;
end
yyy=yyy(fitpoint:end);
x=x(fitpoint:end);
magr=magr(fitpoint:end);
G=yyy;


semilogx(x,G);
% semilogx(x,G1);
title('幅频图对比');
dd=load('openSine_f_amp_phase.txt');
ff=dd(:,1);
aa=dd(:,2);
semilogx(ff,20*log10(aa));hold on;
ddd=load('closesine_f_amp_phase.txt');
fff=ddd(:,1);
aaa=ddd(:,2);
semilogx(fff,20*log10(aaa));hold on;
% legend('PRBS','open','close')
[NUM]=xlsread('Axis2_RefVel_EncVel_SweepSine_12_Jan_2018_10_50_26.xlsx');
x1=NUM(:,1);
y1=NUM(:,2);
semilogx(x1,20*log10(y1));
[NUM1]=xlsread('Axis1_RefVel_EncVel_SweepSine_12_Jan_2018_10_52_42.xlsx');
x2=NUM1(:,1);
y2=NUM1(:,2);
semilogx(x2,20*log10(y2));










function [ y ] = moving_average( x, win_size )
y1=filter(ones(1,win_size/2+1)/win_size,1,x);
y2=filter(ones(1,win_size/2+1)/win_size,1,fliplr(x));
y=y1+fliplr(y2)-(1/win_size)*x;
end






















