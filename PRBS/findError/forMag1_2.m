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
    %---�ж�˭������ ����һ����0��ʼ�������������0��ʼ�������ȵ���0��------------------------%
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
        
        %%%%%%%%%%%%%%%%%%���㻥��غ���%%%%%%%%%%%%%%%%%%
        for k=1:TN
            R(k)=0;
            for i=TN+1:2*TN
                R(k)=R(k)+mm(i-k)*zz(i);
            end
            Rmz(k)=R(k)/TN;
        end
        %%%%%%%%%%%%%%%%%%������Ӧ����ֵ%%%%%%%%%%%%%%%%%%
        for k=1:TN
            g(k)=(Rmz(k)-Rmz(TN-1))*TN/(TN+1)/(1000*1000)/dt;
        end
        figure;
        plot((1:TN)*dt,g);zoom on;grid on;
        ylabel('EncPos');
        xlabel('t/s');
        title('������Ӧ����');

    end
    Mfft=fft(M);
    zfft=fft(z);
    Np=length(M);
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
%     i12=1;
%     while x(i12)<10
%         i12=i12+1;
%     end
%     x12=x(1:i12);
%     G12=G(1:i12);
%     for i=1:3
%         y2=polyfit(x12,G12,i);
%         Y=polyval(y2,x12);%������Ϻ�����x����ֵ��
%         s12(i)=sum((Y-G12).^2);
%     end
%     [m12,n12]=min(s12);
%     y2=polyfit(x12,G12,n12);
%     Y12=polyval(y2,x12);%������Ϻ�����x����ֵ��
    
%     i1=1;
%     while x(i1)<200
%         i1=i1+1;
%     end
%     x1=x(1:i1);
%     G1=G(1:i1);
%     for i=1:4
%         y2=polyfit(x1,G1,i);
%         Y=polyval(y2,x1);%������Ϻ�����x����ֵ��
%         s(i)=sum((Y-G1).^2);
%     end
%     [m,n]=min(s);
%     y2=polyfit(x1,G1,n);
%     Y=polyval(y2,x1);%������Ϻ�����x����ֵ��
%     
%     x2=x(i1-200:end);
%     G2=G(i1-200:end);
%     for i=1:3
%         y2=polyfit(x2,G2,i);
%         Y1=polyval(y2,x2);%������Ϻ�����x����ֵ��
%         s1(i)=sum((Y1-G2).^2);
%     end
%     [m1,n1]=min(s1);
%     y2=polyfit(x2,G2,n1);
%     Y1=polyval(y2,x2);%������Ϻ�����x����ֵ��
    
    %             plot(x,Y,'Parent',handles.paint);
    %             hold on;
%     x=2*pi*x;
figure;
    semilogx(x,G);grid on;hold on;
    xlabel('Frequency(Hz)');
% xlabel('Frequency(rad/s)');
    ylabel('Amplitude(dB)');
    title('��Ƶͼ');
    hold off;
    
    return;
end
