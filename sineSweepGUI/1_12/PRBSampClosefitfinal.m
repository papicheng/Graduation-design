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
    df=fs/N;
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

    M=M1(mi:mi+N-1);
    z=z1(mi:mi+N-1);
    
    MM=M;
    
    
    Mfft=fft(M);
    zfft=fft(z);
    Np=length(M);

    Mmag2 = abs(Mfft);
    Mmag1 = Mmag2(1:Np/2+1);%ע��+1
    Mmag1(2:end-1) = 2*Mmag1(2:end-1);
    zmag2 = abs(zfft);
    zmag1 = zmag2(1:Np/2+1);%ע��+1
    zmag1(2:end-1) = 2*zmag1(2:end-1);
    magr=zmag1./Mmag1;
    G=20*log10(magr);%bodeͼ��ֵ
    G=G(2:Np/2+1);
    x=[1:Np/2]*(fs/Np);
    x=x';
end
figure;
plot(x,zmag1(2:Np/2+1));grid on;hold on;
zmagfit=zmag1(2:Np/2+1);


A = medfilt1(zmagfit,30);

yyy=moving_average(A,150);
yyy__=yyy;
movepoint=round(1.5/df);
yyy(1:end-movepoint+1)=yyy__(movepoint:end);

plot(x,A);
plot(x,yyy);
huadong=yyy;
legend('1','2','3','4');

yyy=yyy./Mmag1(2:end);

%   magr=magr./Mmag1(2:end);
G=20*log10(yyy);%bodeͼ��ֵ
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








function [ y ] = moving_average( x, win_size )
y1=filter(ones(1,win_size/2+1)/win_size,1,x);
y2=filter(ones(1,win_size/2+1)/win_size,1,fliplr(x));
y=y1+fliplr(y2)-(1/win_size)*x;
end






















