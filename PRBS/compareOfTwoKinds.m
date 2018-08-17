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
    N=4000;
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
        M=M1(mi:mi+N-1);
        z=z1(mi:mi+N-1);
%         z=lowp(z,1000,1800,0.1,20,fs);
        zz=diff(z)*4000;
        z=[0;zz];
        
        
%         mm=[M M];
%         zz=[z z];
%
%         %%%%%%%%%%%%%%%%%%���㻥��غ���%%%%%%%%%%%%%%%%%%
%         for k=1:TN
%             R(k)=0;
%             for i=TN+1:2*TN
%                 R(k)=R(k)+mm(i-k)*zz(i);
%             end
%             Rmz(k)=R(k)/TN;
%         end
%         %%%%%%%%%%%%%%%%%%������Ӧ����ֵ%%%%%%%%%%%%%%%%%%
%         for k=1:TN
%             g(k)=(Rmz(k)-Rmz(TN-1))*TN/(TN+1)/(1000*1000)/dt;
%         end
%         figure;
%         plot((1:TN)*dt,g);zoom on;grid on;
%         ylabel('EncPos');
%         xlabel('t/s');
%         title('������Ӧ����');

    end
    Mfft=fft(M);
    zfft=fft(z);
    Np=length(M);
    %             f = Fs*(0:(Np/2))/Np;
    Mmag2 = abs(Mfft/Np);
    Mmag1 = Mmag2(2:Np/2+1);%ע��+1
    Mmag1 = 2*Mmag1;
    zmag2 = abs(zfft/Np);
    zmag1 = zmag2(2:Np/2+1);%ע��+1
    zmag1 = 2*zmag1;
    magr=zmag1./Mmag1;
    G=20*log10(magr);%bodeͼ��ֵ
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



end
    semilogx(x,G);grid on;hold on;
%     xlabel('Frequency(Hz)');
% xlabel('Frequency(rad/s)');
%     ylabel('Amplitude(dB)');
    title('��Ƶͼ�Ա�');

rowinput=2;
rowoutput=1;
makelgw=0;
folder_name = uigetdir('ѡ���ļ���');
if folder_name~=0
    %����ԭʼ����
    %-------------------------------------------------------------------------%
    fs=4000;%����Ƶ��
    N=4000;%��������
    df=fs/N;
    %         n=2^nextpow2(N);
    set_df=fs/N;%����Ƶ�ʷֱ���
    ts=1/fs;
    dt=ts;
    %-----------------------------------------------------s--------------------%
    %����ԭʼ����
    % cd('G:\study\GraduationThesis\dataOfSine\2017-12-08');%������������ļ������ļ���
    % cd('G:\study\GraduationThesis\dataOfSine\λ�ñջ�ɨƵ����1-10Hz');
    cd(folder_name);
    Allname=struct2cell(dir); %�õ������ļ����µ������ļ���
    %dir������Եõ�·���ڰ����ļ������ڵ��ļ���Ϣ��Ϊstruc���ݽṹ��
    %-------------------------------------------------------------------------%
    %��������ļ�
    [m,n]=size(Allname);
    mag_rate=zeros(1,n-2);
    phase_diff=zeros(1,n-2);
    for i=3:n%ǰ���������ļ���,3:n
        
        name=Allname{1,i};
        %-----------�����������з���������ź�Ƶ�ʺͷ���--------------%
        remainder=name;
        parsed='';
        for chopped_i=1:8
            [chopped,remainder]=strtok(remainder,'_');%����_���
            parsed = strvcat(parsed, chopped);
        end
        str_f=parsed(5,:);
        str_m=parsed(7,:);
        str_f=str_f(regexp(str_f,'\d'));
        str_m=str_m(regexp(str_m,'\d'));
        num_f(i-2)=str2num(str_f);%Ƶ��
        num_mag(i-2)=str2num(str_m);%����
        
        real_f(i-2)=num_f(i-2);
        f_num=num_f(i-2)/df+1;%�����ź�Ƶ�ʶ�Ӧ��FFT�����е�λ��
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
        %�������ݳ���ȡһ����������
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
        
        mag_rate(i-2)=cthannfftmag(i-2)/cthannfftmagx(i-2);%��ֵ��
        
        
        
        %         phase_diff(i-2)=(angle(cfft(f_num))-angle(xfft(f_num)))*180/pi;
        phase_diff(i-2)=(angle(cthannfftc(f_num))-angle(cthannfftx(f_num)))*180/pi;
        p1(i-2)=phase_diff(i-2);
        if phase_diff(i-2)>0%��һ�δ���
            phase_diff(i-2)=phase_diff(i-2)-360;
        end
        p2(i-2)=phase_diff(i-2);

    end
    
    [w,iw]=sort(real_f);%iw���������ھ������е�λ��
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
                phase_diff(ip)=phase_diff(ip)-360;%ִֻ��һ��
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
    
    

    cd('..'); % ������һ��·����
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
[h,w]=freqz(bz1,az1,256,Fs);
h=20*log10(abs(h));
figure;plot(w,h);title('������˲�����ͨ������');grid on;
%
y=filter(bz1,az1,x);%������x�˲���õ�������y
end
