clc
close all
clear
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
        input_row=1;output_row=2;ini=1;injudge=1;
        xt1=data(:,input_row);ct1=data(:,output_row);
        %-------------------------------------------------------------------%
        xt1_len=length(xt1);
        %�������ݳ���ȡһ����������
        %         nnnn=0;
        if xt1_len<6000
            xt1_i=1;
            while xt1(xt1_i)==0
                xt1_i=xt1_i+1;
            end
            xt1_i=xt1_i-1;
            xt=xt1(xt1_i:xt1_i+N-1);
            ct=ct1(xt1_i:xt1_i+N-1);
        else
            
            xt=xt1(2000:2000+N-1);
            ct=ct1(2000:2000+N-1);
            
        end
        
%         diffct=diff(ct)/dt;
%         ct=[0;diffct];
%         diffxt=diff(xt)/dt;
%         xt=[0;diffxt];
        
        cthannc=ct;%winhann.*
        cthannfftc=fft(cthannc);
        cthannfftmag(i-2)=abs(cthannfftc(f_num))/(N/2);
        
        cthannx=xt;%winhann.*
        cthannfftx=fft(cthannx);
        cthannfftmagx(i-2)=abs(cthannfftx(f_num))/(N/2);
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
    p3=p2;
    pp=0;ppp=0;
    phase_diff=phase_diff(iw);
    mag_rate=mag_rate(iw);
    for ip=1:length(iw)
        if ppp==1
            phase_diff(ip)=phase_diff(ip)-360;
        end
        if ip>2
            
            if pp==0&&phase_diff(ip-1)+360<50&&phase_diff(ip)>-50
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
    p4=phase_diff;
%     for ip=1:length(iw)-5
%         [sm,sn]=min(phase_diff(ip:ip+5));
%         if abs(sm-mean(phase_diff(ip:ip+5)))>50
%             phase_diff(ip+sn)=2*phase_diff(ip+sn-1)-phase_diff(ip+sn-2);
%         end
%     end

    cd('..'); % ������һ��·����
    folder_name=0;
end

subplot(2,1,1)
semilogx(w,20*log10(mag_rate));grid on;zoom on;
ylabel('Amplitude(dB)');
subplot(2,1,2)
semilogx(w,phase_diff);grid on;zoom on;


xlabel('Frequency(Hz)');
ylabel('Phase(Deg)');
%
resultData(:,1)=w;
resultData(:,2)=p1;
resultData(:,3)=p2;
resultData(:,4)=p3;

% name_data = ['Frequency', 'AmplitudeRatio', 'PhaseDifference'];                           % �������鼯��data
% 
% [m, n] = size(data);
% 
% data_cell = mat2cell(data, ones(m,1), ones(n,1));    % ��data�и��m*n��cell����
% 
% title_data = {'Frequency', 'AmplitudeRatio', 'PhaseDifference'};                          % ��ӱ�������
% 
% result = [title_data; data_cell];                                            % ���������ƺ���ֵ�鼯��result
result(:,1)=w;
result(:,2)=mag_rate;
result(:,3)=phase_diff;
[filename,pathname] = uiputfile({'*.xls','excel(*.xls)'}, '��������','�ջ�����ɨƵ');
if filename==0
    return
end
xlswrite(fullfile(pathname,filename),result);
