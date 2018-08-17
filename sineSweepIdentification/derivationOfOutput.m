clc
clear
close all
rowinput=2;
rowoutput=1;
makelgw=0;
folder_name = uigetdir('ѡ���ļ���');
if folder_name~=0
    %����ԭʼ����
    %-------------------------------------------------------------------------%
    fs=4000;%����Ƶ��
    N=4000;%��������
    %         n=2^nextpow2(N);
    set_df=fs/N;%����Ƶ�ʷֱ���
    ts=1/fs;
    dt=ts;
    %-----------------------------------------------------s--------------------%
    cd(folder_name);
    Allname=struct2cell(dir); %�õ������ļ����µ������ļ���
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
        f_num=num_f(i-2)+1;%�����ź�Ƶ�ʶ�Ӧ��FFT�����е�λ��
        %----------------------------------------------------------%
        data=importdata(name);
        xt1=data(:,rowinput);
        ct1=data(:,rowoutput);
        %-------------------------------------------------------------------%
        xt1_len=length(xt1);
        xt1_len_half=ceil(xt1_len/2);
        %�������ݳ���ȡһ����������
        if xt1_len<2*N
            xt1_i=1;
            while xt1(xt1_i)==0
                xt1_i=xt1_i+1;
            end
            nnnn=xt1_i;
            xt=xt1(xt1_i:xt1_i+N-1);
            ct=ct1(xt1_i:xt1_i+N-1);
            ctd=ct1(xt1_i:xt1_i+N+1);
            ctd(end-1)=2*ctd(end-2)-ctd(end-3);
            ctd(end)=2*ctd(end-1)-ctd(end-2);
        else
            xt=xt1(xt1_len_half:xt1_len_half+N-1);
            ct=ct1(xt1_len_half:xt1_len_half+N-1);
            ctd=ct1(xt1_len_half:xt1_len_half+N+1);
            nnnn=xt1_len_half;
            %             if real_f(i-2)==1
            %                 ct=ct1(8600:8600+N+1);
            %             end
        end
        %{
        if real_f(i-2)==51||real_f(i-2)==1001||real_f(i-2)==151
            Y = fft(ct);L=N;Fs=4000;
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            ph=angle(Y(1:(L/2+1)));
            P1(2:end-1) = 2*P1(2:end-1);
            f = Fs*(0:(L/2))/L;
            figure;
            plot(f,P1,'o');grid on;zoom on;
            figure;
            plot(f,ph,'*');grid on;zoom on;
        end
        %}
%         dct=diff(ctd)*4000;
%         ddct=diff(dct)*4000;
        ddct=-(2*pi*real_f(i-2))^2*ct;
        ddctfft=fft(ddct);
        ddctmag(i-2)=abs(ddctfft(f_num))/(N/2);
        
        if real_f(i-2)==1
            k=num_mag(i-2)/ddctmag(i-2);
        end
        
        %��blackman��
        winblackman=blackman(N);
        ctblackman=winblackman.*ct;
        ctblackfft=fft(ctblackman);
        ctblackfftmag(i-2)=2.381*abs(ctblackfft(f_num))/(N/2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %��hann��
        winhann=hann(N);
        cthann=winhann.*ct;
        cthannfftc=fft(cthann);
        cthannfftmag(i-2)=2*abs(cthannfftc(f_num))/(N/2);
        
        cthann=winhann.*xt;
        cthannfftx=fft(cthann);
        cthannfftmagx(i-2)=2*abs(cthannfftx(f_num))/(N/2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        xfft=fft(xt);
        cfft=fft(ct);
        xmag=abs(xfft);
        cmag=abs(cfft);
        outputmag(i-2)=cmag(f_num)/(N/2);
        inputmag(i-2)=xmag(f_num)/(N/2);
        mag_rate(i-2)=(cmag(f_num)/(N/2))/cthannfftmagx(i-2);%��ֵ��
        
        phase_diff(i-2)=(angle(cfft(f_num))-angle(xfft(f_num)))*180/pi;
        phase_diffx(i-2)=(angle(cthannfftc(f_num))-angle(cthannfftx(f_num)))*180/pi;
        if phase_diff(i-2)>0%��һ�δ���
            phase_diff(i-2)=phase_diff(i-2)-360;
        end
        if phase_diffx(i-2)>0%��һ�δ���
            phase_diffx(i-2)=phase_diffx(i-2)-360;
        end
        maghannrate(i-2)=cthannfftmag(i-2)/num_mag(i-2);
        magblackrate(i-2)=ctblackfftmag(i-2)/num_mag(i-2);
        
    end
    
    [w,iw]=sort(real_f);%iw���������ھ������е�λ��
    pp=0;ppp=0;
    phase_diff=phase_diff(iw);
    ddctmag=ddctmag(iw);
    Iout=ddctmag;
    Iinput=num_mag(iw);
    Iout(2:end)=Iout(2:end)*k;
    Irate=Iout./Iinput;
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
    
    figure;
    semilogx(w,20*log10(maghannrate(iw)));zoom on;grid on;hold on;
    semilogx(w,20*log10(magblackrate(iw)));
    %     semilogx(w,20*log10(Gjw(iw)));
    G20lg=20*log10(mag_rate);%bodeͼ��ֵ
    semilogx(w,G20lg(iw));
    legend('maghannrate','magblackrate','G20lg');%,'magrate1','magrate2','magrate3')
    cd('..'); % ������һ��·����
    folder_name=0;
end

resultData(:,1)=w;
resultData(:,2)=maghannrate(iw);

resultData(:,3)=phase_diff;

figure;
subplot(2,1,1)
semilogx(w,20*log10(maghannrate(iw)));zoom on;grid on;
hold on;
semilogx(w,20*log10(Irate));
legend('posation','I');
ylabel('Amplitude(dB)');
subplot(2,1,2)
semilogx(w,phase_diff);zoom on;grid on;
legend('phase_diff');
xlabel('Frequency(Hz)');
ylabel('Phase(deg)');