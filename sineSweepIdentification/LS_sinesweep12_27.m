clc
clear
close all
rowinput=2;
rowoutput=1;
makelgw=0;
folder_name = uigetdir('选择文件夹');
if folder_name~=0
    %导入原始数据
    %-------------------------------------------------------------------------%
    fs=4000;%采样频率
    N=4000;%采样点数
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
        f_num=num_f(i-2)+1;%输入信号频率对应于FFT后序列的位置
        %----------------------------------------------------------%
        data=importdata(name);
        xt1=data(:,rowinput);
        ct1=data(:,rowoutput);
        %         xt1=data(:,2);
        %         ct1=data(:,1);
        %-------------------------------------------------------------------%
        xt1_len=length(xt1);
        xt1_len_half=ceil(xt1_len/2);
        %根据数据长度取一段数做处理
        %         nnnn=0;
        if xt1_len<2*N
            xt1_i=1;
            while xt1(xt1_i)==0
                xt1_i=xt1_i+1;
            end
            nnnn=xt1_i;
            xt=xt1(xt1_i:xt1_i+N-1);
            ct=ct1(xt1_i:xt1_i+N-1);
        else
            xt=xt1(xt1_len_half:xt1_len_half+N-1);
            ct=ct1(xt1_len_half:xt1_len_half+N-1);
            nnnn=xt1_len_half;
        end
        
        
        %去均值化
        %         xtm=(xt-mean(xt))/std(xt,0);
        %         ctm=(ct-mean(ct))/std(ct,0);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %         detrendc=detrend(ct);
        %
        %         trend=ct-detrendc;
        %         plot(trend);hold on;
        %         plot(ct);
        %         plot(detrendc);
        %         figure;
        %%%%% 求Y %%%%%%%%%%
        %{
       ccc=trend+mean(detrendc);
        for Yi=1:N
            Y(Yi,1)=ccc(i);
        end
        for zetai=1:N
            zeta(zetai,1)=sin(real_f(i-2)*zetai);
        end
        for zetai=1:N
            zeta(zetai,2)=cos(real_f(i-2)*zetai);
        end
        c=inv(zeta'*zeta)*zeta'*Y;
        mag_rateLS(i-2)=sqrt(c(1)*c(1)+c(2)*c(2))/num_mag(i-2);
        %}
        
        %         xtmfft=fft(xt);
        %         ctmfft=fft(trend+mean(detrendc));
        %         xmagm=abs(xtmfft);
        %         cmagm=abs(ctmfft);
        %         mag_ratem(i-2)=cmagm(f_num)/xmagm(f_num);%幅值比
        %加blackman窗
        winblackman=blackman(N);
        ctblackman=winblackman.*ct;
        ctblackfft=fft(ctblackman);
        ctblackfftmag(i-2)=2.381*abs(ctblackfft(f_num))/(N/2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %加hann窗
        winhann=hann(N);
        cthann=winhann.*ct;%
        cthannfftc=fft(cthann);
        cthannfftmag(i-2)=2*abs(cthannfftc(f_num))/(N/2);
        
        cthann=winhann.*xt;%winhann.*
        cthannfftx=fft(cthann);
        cthannfftmagx(i-2)=2*abs(cthannfftx(f_num))/(N/2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %       %最小二乘辨识频率特性
        %{
        A=num_mag(i-2);
        for rei=1+nnnn:N+nnnn
            re=sin(2*pi*num_f(i-2)*rei*ts)*ct1(rei);
        end
        re=2/N/A*re;
        for imi=1+nnnn:N+nnnn
            im=cos(2*pi*num_f(i-2)*imi*ts)*ct1(imi);
        end
        im=2/N/A*im;
        Gjw(i-2)=sqrt(re*re+im*im);
        %}
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        xfft=fft(xt);
        cfft=fft(ct);
        xmag=abs(xfft);
        cmag=abs(cfft);
        outputmag(i-2)=cmag(f_num)/(N/2);
        inputmag(i-2)=xmag(f_num)/(N/2);
        mag_rate(i-2)=(cmag(f_num)/(N/2))/cthannfftmagx(i-2);%幅值比
        
        
        
        
        %         a=real(xfft(f_num));b=imag(xfft(f_num));c=real(cfft(f_num));d=imag(cfft(f_num));
        
        %         phase_diff(i-2)=-acos((a*c+b*d)/sqrt((a*a+b*b)*(c*c+d*d)))*180/pi;%相位差
        
        
        
        phase_diff(i-2)=(angle(cfft(f_num))-angle(xfft(f_num)))*180/pi;
        phase_diffx(i-2)=(angle(cthannfftc(f_num))-angle(cthannfftx(f_num)))*180/pi;
        if phase_diff(i-2)>0%第一次处理
            phase_diff(i-2)=phase_diff(i-2)-360;
        end
        if phase_diffx(i-2)>0%第一次处理
            phase_diffx(i-2)=phase_diffx(i-2)-360;
        end
        maghannrate(i-2)=cthannfftmag(i-2)/num_mag(i-2);
        magblackrate(i-2)=ctblackfftmag(i-2)/num_mag(i-2);
        %         maghan_rate(i-2)=magchan(f_num)/xmag(f_num);%幅值比
        %         xphase(i-2)=atan2(a,b)*180/pi;
        %         cphase(i-2)=atan2(c,d)*180/pi;
        %         phase_diff(i-2)=(cphase(i-2)-xphase(i-2));
        % phase_diff(i-2)=(angle(cfft(f_num))-angle(xfft(f_num)))*180/pi;
        % if phase_diff(i-2)>0
        %     phase_diff(i-2)=-phase_diff(i-2);
        % end
    end
    %     xmag_mesure=xmag(f_num)/(N/2);
    %         if abs(xmag_mesure-num_mag(i-2))>2
    %             fprintf('----------------\n频率:%dhz 输入幅值=%f 测量幅值=%f, 输入幅值求得值差太多！！\n-------------------\n',real_f(i-2),num_mag(i-2),xmag_mesure);
    %         end
    %         fprintf('频率：%dhz\t幅值比=%f,相位差=%f°\n',real_f(i-2),mag_rate(i-2),phase_diff(i-2));
    
    % linkaxes (ax,'xy')
    %     outputmag1=(outputmag-min(outputmag))/(max(outputmag)-min(outputmag));
    %     num_mag1=(num_mag-min(num_mag))/(max(num_mag)-min(num_mag));
    %     magrate1=outputmag1./num_mag1;
    %
    %     outputmag2=mapminmax(outputmag);
    %     num_mag2=mapminmax(num_mag);
    %     magrate2=outputmag2./num_mag2;
    
    
    
    %     outputmag3=zscore(outputmag);
    %     num_mag3=zscore(num_mag);
    %     magrate3=outputmag3./num_mag3;
    
    
    [w,iw]=sort(real_f);%iw是新序列在旧序列中的位置
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
    
    pp=0;ppp=0;
    phase_diffx=phase_diffx(iw);
    for ip=1:length(iw)
        if ppp==1
            phase_diffx(ip)=phase_diffx(ip)-360;
        end
        if ip>2
            
            if pp==0&&phase_diffx(ip-1)+360<5&&phase_diffx(ip)>-50
                phase_diffx(ip)=phase_diffx(ip)-360;%只执行一次
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
        [sm,sn]=min(phase_diffx(ip:ip+5));
        if abs(sm-mean(phase_diffx(ip:ip+5)))>50
            phase_diffx(ip+sn)=2*phase_diffx(ip+sn-1)-phase_diffx(ip+sn-2);
        end
    end
    
    %     wl=length(iw);
    %     for pii=1:wl
    %         fprintf('频率：%dhz\t幅值比=%f,相位差=%f°,x相位=%%f°,c相位=%%f°\n',w(pii),mag_rate(iw(pii)),phase_diff(iw(pii)));%,xphase(iw(pii)),cphase(iw(pii)));
    %     end
    %     log_w=log10(real_f);%bode图lgw
    %
    semilogx(w,20*log10(maghannrate(iw)));zoom on;grid on;hold on;
    semilogx(w,20*log10(magblackrate(iw)));
    %     semilogx(w,20*log10(Gjw(iw)));
    G20lg=20*log10(mag_rate);%bode图幅值
    semilogx(w,G20lg(iw));
    %     semilogx(w,20*log10(magrate1(iw)));
    %     semilogx(w,20*log10(magrate2(iw)));
    %     semilogx(w,20*log10(magrate3(iw)));
    legend('maghannrate','magblackrate','G20lg');%,'magrate1','magrate2','magrate3')
    cd('..'); % 跳到上一级路径下
    folder_name=0;
end
%     resultData(:,1)=jiao(iw);
%     resultData(:,2)=jiao_r(iw);
resultData(:,1)=w;
resultData(:,2)=maghannrate(iw);

resultData(:,3)=phase_diff;
 %     resultData(:,3)=phase_diff_3(iw);
%         resultData(:,5)=phase_diff_4(iw);
figure;
subplot(2,1,1)
semilogx(w,20*log10(maghannrate(iw)));zoom on;grid on;
ylabel('Amplitude(dB)');
subplot(2,1,2)
semilogx(w,phase_diff);zoom on;grid on;
hold on;
semilogx(w,phase_diffx);
legend('phase_diff','phase_diffx');
xlabel('Frequency(Hz)');
ylabel('Phase(deg)');