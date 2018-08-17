clc
close all
clear
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
        frealshow(i-2)=num_f(i-2);
        f_num(i-2)=num_f(i-2)/df+1;%输入信号频率对应于FFT后序列的位置
        %----------------------------------------------------------%
        data=importdata(name);
        %---判断谁是输入 ------------------------%
                input_row=1;output_row=2;                
                xt1=data(:,input_row);ct1=data(:,output_row);
                teinput=xt1(1:20);teouput=ct1(1:20);
                stdx=std(teinput,0);
                stdc=std(teouput,0);
                if stdx<stdc
                    temp=xt1;
                    xt1=ct1;
                    ct1=temp;
                end
        %-------------------------------------------------------------------%
        xt1len=length(xt1);
        si=1;jump=0;
        if max(xt1)==0||max(ct1)==0
            jump=1;%判断是否有有效数据，否则该频率点无效，重复上一个频率点
        end
        while xt1(si)==0&&jump==0
            si=si+1;
            if si>=xt1len-1
                jump=1;
            end
        end
        if jump==0
            si=si-1;
            xend=length(xt1);
            while xt1(xend)==0
                xend=xend-1;
            end
            xt1long=xend-si+1;
            if xt1long>=4000
                starti=xend-4000+1;
                xt=xt1(starti:starti+3999);
                ct=ct1(starti:starti+3999);
            end
            if xt1long==3999
                xt=xt1(si:si+3999);
                ct=ct1(si:si+3999);
            end
            if xt1long<3999
                xt=xt1(si:xend);
                ct=ct1(si:xend);
                xlong=length(xt);
                dfin=fs/xlong;
                f_num(i-2)=round(real_f(i-2)/dfin)+1;
                frealshow(i-2)=(f_num(i-2)-1)*dfin;
            end            
            cthannc=ct;%winhann.*
            cthannfftc=fft(cthannc);
            cthannfftmag(i-2)=abs(cthannfftc(f_num(i-2)));
            
            cthannx=xt;%winhann.*
            cthannfftx=fft(cthannx);
            cthannfftmagx(i-2)=abs(cthannfftx(f_num(i-2)));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            mag_rate(i-2)=cthannfftmag(i-2)/cthannfftmagx(i-2);%幅值比
            phase_diff(i-2)=(angle(cthannfftc(f_num(i-2)))-angle(cthannfftx(f_num(i-2))))*180/pi;
            p1(i-2)=phase_diff(i-2);
            if phase_diff(i-2)>0%第一次处理
                phase_diff(i-2)=phase_diff(i-2)-360;
            end
            p2(i-2)=phase_diff(i-2);
        end
        if jump==1
            phase_diff(i-2)=phase_diff(i-3);
            mag_rate(i-2)=mag_rate(i-3);
            real_f(i-2)=real_f(i-3);
            frealshow(i-2)=frealshow(i-3);
        end
    end
    [w,iw]=sort(frealshow);%iw是新序列在旧序列中的位置
    p1=p1(iw);
    p2=p2(iw);
    p3=p2;
    pp=0;ppp=0;
    mag_rate=mag_rate(iw);
    phase_diff=phase_diff(iw);
    for ip=1:length(iw)
        if ppp==1
            phase_diff(ip)=phase_diff(ip)-360;
        end
        if ip>2
            
            if pp==0&&phase_diff(ip-1)+360<50&&phase_diff(ip)>-50
                phase_diff(ip)=phase_diff(ip)-360;%只执行一次
                ppp=1;
                pp=1;
            end
        end
    end
    p4=phase_diff;
    stop=1;
    plen=length(phase_diff);
    while stop==1
        for px=2:plen
            phaseabs(px)=abs(phase_diff(px-1)-phase_diff(px));
        end
        if max(phaseabs)<200
            stop=0;
        end
            
        if max(phaseabs)>200
            for px=2:plen
                if abs(phase_diff(px-1)-phase_diff(px))>200
                    phase_diff(px)=phase_diff(px)-360;
                end
            end
        end
    end
    
    cd('..'); % 跳到上一级路径下
    folder_name=0;
end
mag_ratelog=20*log10(mag_rate);
subplot(2,1,1)
semilogx(w,mag_ratelog);grid on;zoom on;
ylabel('Amplitude(dB)');
subplot(2,1,2)
semilogx(w,phase_diff);grid on;zoom on;

resultData(:,1)=p1;
resultData(:,2)=p2;
resultData(:,3)=p3;
resultData(:,4)=p4;
resultData(:,5)=phase_diff;
xlabel('Frequency(Hz)');
ylabel('Phase(Deg)');

w=w';
phase_diff=phase_diff';
mag_ratelog=mag_ratelog';
a=datestr(now,0);
filename = 'testdata';
a=strrep(a,'-','_');
a=strrep(a,' ','_');
a=strrep(a,':','_');
filename=[filename,a,'.xlsx'];
R(:,1)=w;
R(:,2)=mag_rate;
R(:,3)=phase_diff;
xlswrite(filename,R);

%
% resultData(:,3)=phase_diff;
%     resultData(:,3)=phase_diff_3(iw);
%         resultData(:,5)=phase_diff_4(iw);
