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
    %---判断谁是输入 输入一定从0开始，如果两个都从0开始，输入先到非0数------------------------%
    input_row=1;output_row=2;ini=1;injudge=1;
    M1=data(:,input_row);z1=data(:,output_row);
    if injudge==1&&M1(ini)~=0
        mt=M1;
        M1=z1;
        z1=mt;
        injudge=0;
    end
    if injudge==1
        while M1(ini)==0&&z1(ini)==0
            ini=ini+1;
        end
        if z1(ini)>M1(ini)
            mt=M1;
            M1=z1;
            z1=mt;
        end
        injudge=0;
    end
    %-----------------------------------------------------------------------------------%
    mi=1;
    while M1(mi)==0
        mi=mi+1;
    end
    M1_len=length(M1);
    if M1_len<TN
        while M1(M1_len)==0
            M1_len=M1_len-1;
        end
        lenn=M1_len-mi+1;
        if mod(lenn,2)==1
            M1_len=M1_len-1;
        end
        M=M1(mi:M1_len);
        z=z1(mi:M1_len);
    else
        M=M1(mi:mi+TN);
        z=z1(mi:mi+TN);
        
        mm=[M M];
        zz=[z z];
        
        %%%%%%%%%%%%%%%%%%计算互相关函数%%%%%%%%%%%%%%%%%%
        for k=1:TN
            R(k)=0;
            for i=TN+1:2*TN
                R(k)=R(k)+mm(i-k)*zz(i);
            end
            Rmz(k)=R(k)/TN;
        end
        %%%%%%%%%%%%%%%%%%脉冲响应估计值%%%%%%%%%%%%%%%%%%
        for k=1:TN
            g(k)=(Rmz(k)-Rmz(TN-1))*TN/(TN+1)/(1000*1000)/dt;
        end
        figure;
        plot((1:TN)*dt,g);zoom on;grid on;
        ylabel('EncPos');
        xlabel('t/s');
        title('脉冲响应估计');

    end
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
%     i12=1;
%     while x(i12)<10
%         i12=i12+1;
%     end
%     x12=x(1:i12);
%     G12=G(1:i12);
%     for i=1:3
%         y2=polyfit(x12,G12,i);
%         Y=polyval(y2,x12);%计算拟合函数在x处的值。
%         s12(i)=sum((Y-G12).^2);
%     end
%     [m12,n12]=min(s12);
%     y2=polyfit(x12,G12,n12);
%     Y12=polyval(y2,x12);%计算拟合函数在x处的值。
    
%     i1=1;
%     while x(i1)<200
%         i1=i1+1;
%     end
%     x1=x(1:i1);
%     G1=G(1:i1);
%     for i=1:4
%         y2=polyfit(x1,G1,i);
%         Y=polyval(y2,x1);%计算拟合函数在x处的值。
%         s(i)=sum((Y-G1).^2);
%     end
%     [m,n]=min(s);
%     y2=polyfit(x1,G1,n);
%     Y=polyval(y2,x1);%计算拟合函数在x处的值。
%     
%     x2=x(i1-200:end);
%     G2=G(i1-200:end);
%     for i=1:3
%         y2=polyfit(x2,G2,i);
%         Y1=polyval(y2,x2);%计算拟合函数在x处的值。
%         s1(i)=sum((Y1-G2).^2);
%     end
%     [m1,n1]=min(s1);
%     y2=polyfit(x2,G2,n1);
%     Y1=polyval(y2,x2);%计算拟合函数在x处的值。
    
    %             plot(x,Y,'Parent',handles.paint);
    %             hold on;
%     x=2*pi*x;
figure;
    semilogx(x,G);grid on;hold on;
    xlabel('Frequency(Hz)');
% xlabel('Frequency(rad/s)');
    ylabel('Amplitude(dB)');
    title('幅频图');
    hold off;
    
    return;
end
