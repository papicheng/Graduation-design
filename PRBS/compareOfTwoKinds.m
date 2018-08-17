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
    N=4000;
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
        M=M1(mi:mi+N-1);
        z=z1(mi:mi+N-1);
%         z=lowp(z,1000,1800,0.1,20,fs);
        zz=diff(z)*4000;
        z=[0;zz];
        
        
%         mm=[M M];
%         zz=[z z];
%
%         %%%%%%%%%%%%%%%%%%计算互相关函数%%%%%%%%%%%%%%%%%%
%         for k=1:TN
%             R(k)=0;
%             for i=TN+1:2*TN
%                 R(k)=R(k)+mm(i-k)*zz(i);
%             end
%             Rmz(k)=R(k)/TN;
%         end
%         %%%%%%%%%%%%%%%%%%脉冲响应估计值%%%%%%%%%%%%%%%%%%
%         for k=1:TN
%             g(k)=(Rmz(k)-Rmz(TN-1))*TN/(TN+1)/(1000*1000)/dt;
%         end
%         figure;
%         plot((1:TN)*dt,g);zoom on;grid on;
%         ylabel('EncPos');
%         xlabel('t/s');
%         title('脉冲响应估计');

    end
    Mfft=fft(M);
    zfft=fft(z);
    Np=length(M);
    %             f = Fs*(0:(Np/2))/Np;
    Mmag2 = abs(Mfft/Np);
    Mmag1 = Mmag2(2:Np/2+1);%注意+1
    Mmag1 = 2*Mmag1;
    zmag2 = abs(zfft/Np);
    zmag1 = zmag2(2:Np/2+1);%注意+1
    zmag1 = 2*zmag1;
    magr=zmag1./Mmag1;
    G=20*log10(magr);%bode图幅值
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



end
    semilogx(x,G);grid on;hold on;
%     xlabel('Frequency(Hz)');
% xlabel('Frequency(rad/s)');
%     ylabel('Amplitude(dB)');
    title('幅频图对比');

rowinput=2;
rowoutput=1;
makelgw=0;
folder_name = uigetdir('选择文件夹');
if folder_name~=0
    %导入原始数据
    %-------------------------------------------------------------------------%
    fs=4000;%采样频率
    N=4000;%采样点数
    df=fs/N;
    %         n=2^nextpow2(N);
    set_df=fs/N;%设置频率分辨率
    ts=1/fs;
    dt=ts;
    %-----------------------------------------------------s--------------------%
    %导入原始数据
    % cd('G:\study\GraduationThesis\dataOfSine\2017-12-08');%待处理的数据文件所在文件夹
    % cd('G:\study\GraduationThesis\dataOfSine\位置闭环扫频数据1-10Hz');
    cd(folder_name);
    Allname=struct2cell(dir); %得到上述文件夹下的所有文件名
    %dir命令，可以得到路径内包括文件名在内的文件信息，为struc数据结构。
    %-------------------------------------------------------------------------%
    %逐个读入文件
    [m,n]=size(Allname);
    mag_rate=zeros(1,n-2);
    phase_diff=zeros(1,n-2);
    for i=3:n%前两个不是文件名,3:n
        
        name=Allname{1,i};
        %-----------从数据名称中分离出输入信号频率和幅度--------------%
        remainder=name;
        parsed='';
        for chopped_i=1:8
            [chopped,remainder]=strtok(remainder,'_');%根据_拆分
            parsed = strvcat(parsed, chopped);
        end
        str_f=parsed(5,:);
        str_m=parsed(7,:);
        str_f=str_f(regexp(str_f,'\d'));
        str_m=str_m(regexp(str_m,'\d'));
        num_f(i-2)=str2num(str_f);%频率
        num_mag(i-2)=str2num(str_m);%幅度
        
        real_f(i-2)=num_f(i-2);
        f_num=num_f(i-2)/df+1;%输入信号频率对应于FFT后序列的位置
        %----------------------------------------------------------%
        data=importdata(name);
%         input_row=2;output_row=1;ini=1;injudge=1;
%         xt1=data(:,input_row);ct1=data(:,output_row);
%         if injudge==1&&xt1(ini)~=0
%             mt=xt1;
%             xt1=ct1;
%             ct1=mt;
%             injudge=0;
%         end
%         if injudge==1
%             while xt1(ini)==0&&ct1(ini)==0
%                 ini=ini+1;
%             end
%             if ct1(ini)>xt1(ini)
%                 mt=xt1;
%                 xt1=ct1;
%                 ct1=mt;
%             end
%             injudge=0;
%         end
        input_row=2;output_row=1;ini=1;injudge=1;
        xt1=data(:,input_row);ct1=data(:,output_row);
        %-------------------------------------------------------------------%
        xt1_len=length(xt1);
        xt1_len_half=500;
        %根据数据长度取一段数做处理
        %         nnnn=0;
        if xt1_len<N+100
            xt1_i=1;
            while xt1(xt1_i)==0
                xt1_i=xt1_i+1;
            end
            xt1_i=xt1_i-1;
            xt=xt1(xt1_i:xt1_i+N-1);
            ct=ct1(xt1_i:xt1_i+N-1);
        else
            if num_f(i-2)~=1
                xt=xt1(xt1_len_half:xt1_len_half+N-1);
                ct=ct1(xt1_len_half:xt1_len_half+N-1);
            else
                xt=xt1(8000:8000+N-1);
                ct=ct1(8000:8000+N-1);
            end
        end
        
        diffct=diff(ct)/dt;
        ct=[0;diffct];
        
        cthannc=ct;%winhann.*
        cthannfftc=fft(cthannc);
        cthannfftmag(i-2)=2*abs(cthannfftc(f_num))/(N/2);
        
        cthannx=xt;%winhann.*
        cthannfftx=fft(cthannx);
        cthannfftmagx(i-2)=2*abs(cthannfftx(f_num))/(N/2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        mag_rate(i-2)=cthannfftmag(i-2)/cthannfftmagx(i-2);%幅值比
        
        
        
        %         phase_diff(i-2)=(angle(cfft(f_num))-angle(xfft(f_num)))*180/pi;
        phase_diff(i-2)=(angle(cthannfftc(f_num))-angle(cthannfftx(f_num)))*180/pi;
        p1(i-2)=phase_diff(i-2);
        if phase_diff(i-2)>0%第一次处理
            phase_diff(i-2)=phase_diff(i-2)-360;
        end
        p2(i-2)=phase_diff(i-2);

    end
    
    [w,iw]=sort(real_f);%iw是新序列在旧序列中的位置
    p1=p1(iw);
    p2=p2(iw);
    pp=0;ppp=0;
    phase_diff=phase_diff(iw);
    for ip=1:length(iw)
        if ppp==1
            phase_diff(ip)=phase_diff(ip)-360;
        end
        if ip>2
            
            if pp==0&&phase_diff(ip-1)+360<5&&phase_diff(ip)>-50
                phase_diff(ip)=phase_diff(ip)-360;%只执行一次
                ppp=1;
                pp=1;
            end
        end
        %         [sm,sn]=min(phase_diff(ip:ip+5));
        %         if abs(sm-mean(phase_diff(ip:ip+5)))>90
        %             phase_diff(sn)=2*phase_diff(sn-1)-phase_diff(sn-2);
        %         end
    end
    for ip=1:length(iw)-5
        [sm,sn]=min(phase_diff(ip:ip+5));
        if abs(sm-mean(phase_diff(ip:ip+5)))>50
            phase_diff(ip+sn)=2*phase_diff(ip+sn-1)-phase_diff(ip+sn-2);
        end
    end
    
    

    cd('..'); % 跳到上一级路径下
    folder_name=0;
end
%     resultData(:,1)=jiao(iw);
%     resultData(:,2)=jiao_r(iw);
% resultData(:,1)=w;
% resultData(:,2)=maghannrate(iw);
%
% resultData(:,3)=phase_diff;
%     resultData(:,3)=phase_diff_3(iw);
%         resultData(:,5)=phase_diff_4(iw);
p2(96:end)=p2(96:end)-360;
% subplot(2,1,1)
semilogx(w,20*log10(mag_rate(iw)));
ylabel('Amplitude(dB)');

function y=lowp(x,f1,f3,rp,rs,Fs)
%低通滤波
%使用注意事项：通带或阻带的截止频率的选取范围是不能超过采样率的一半
%即，f1,f3的值都要小于 Fs/2
%x:需要带通滤波的序列
% f 1：通带截止频率
% f 3：阻带截止频率
%rp：边带区衰减DB数设置
%rs：截止区衰减DB数设置
%FS：序列x的采样频率
% rp=0.1;rs=30;%通带边衰减DB值和阻带边衰减DB值
% Fs=2000;%采样率
%
wp=2*pi*f1/Fs;
ws=2*pi*f3/Fs;
% 设计切比雪夫滤波器；
[n,wn]=cheb1ord(wp/pi,ws/pi,rp,rs);
[bz1,az1]=cheby1(n,rp,wp/pi);
%查看设计滤波器的曲线
[h,w]=freqz(bz1,az1,256,Fs);
h=20*log10(abs(h));
figure;plot(w,h);title('所设计滤波器的通带曲线');grid on;
%
y=filter(bz1,az1,x);%对序列x滤波后得到的序列y
end
