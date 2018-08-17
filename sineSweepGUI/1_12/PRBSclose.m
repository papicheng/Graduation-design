clc
clear
close all

filename=0;
[filename, pathname] = uigetfile('*.txt','选择文件');
if isequal(filename,0)
    return;
else
    cd(pathname);
    data=load(filename);
    fs=4000;%采样频率4000hz
    dt=1/fs;%数据采集时间和m序列移位脉冲周期相同
    TN=2^17-1;
    N=TN;
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
    M1_len=length(M1);
%     if M1_len<TN
%         while M1(M1_len)==0
%             M1_len=M1_len-1;
%         end
%         lenn=M1_len-mi+1;
%         if mod(lenn,2)==1
%             M1_len=M1_len-1;
%         end
%         M=M1(mi:M1_len);
%         z=z1(mi:M1_len);
%     else
%  
%         M=M1(mi:mi+N-1);
%         z=z1(mi:mi+N-1);
%         zz=diff(z)*4000;
%         z=[0;zz];
%         MM=diff(M)*4000;
%         M=[0;MM];
% 
%     end
    M=M1(mi:mi+N-1);
    z=z1(mi:mi+N-1);
    Mfft=fft(M);
    zfft=fft(z);
    Np=length(M);
    %             f = Fs*(0:(Np/2))/Np;
    Mmag2 = abs(Mfft/Np);
    Mmag1 = Mmag2(1:Np/2+1);%注意+1
    Mmag1(2:end-1) = 2*Mmag1(2:end-1);
    zmag2 = abs(zfft/Np);
    zmag1 = zmag2(1:Np/2+1);%注意+1
    zmag1(2:end-1) = 2*zmag1(2:end-1);
    magr=zmag1./Mmag1;
    G=20*log10(magr);%bode图幅值
    G=G(2:Np/2+1);
    x=[1:Np/2]*(fs/Np);
    x=x';

end
    semilogx(x,G);grid on;hold on;