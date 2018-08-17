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

end
    semilogx(x,G);grid on;hold on;

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
        f_num=num_f(i-2)+1;%�����ź�Ƶ�ʶ�Ӧ��FFT�����е�λ��
        %----------------------------------------------------------%
        data=importdata(name);
          %---�ж�˭������ ����һ����0��ʼ�������������0��ʼ�������ȵ���0��------------------------%
                input_row=1;output_row=2;
                %                 ini=1;injudge=1;
                
                xt1=data(:,input_row);ct1=data(:,output_row);
                teinput=xt1(1:20);teouput=ct1(1:20);
                
                if std(teinput,0)<std(teouput,0)
                    temp=xt1;
                    xt1=ct1;
                    ct1=temp;
                end
        %-------------------------------------------------------------------%
        xt1_len=length(xt1);
        %�������ݳ���ȡһ����������
        %         nnnn=0;
        if xt1_len<6000
            xt1_i=1;
            while xt1(xt1_i)==0
                xt1_i=xt1_i+1;
            end
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
        cthannfftmag(i-2)=2*abs(cthannfftc(f_num))/(N/2);
        
        cthannx=xt;%winhann.*
        cthannfftx=fft(cthannx);
        cthannfftmagx(i-2)=2*abs(cthannfftx(f_num))/(N/2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        mag_rate(i-2)=cthannfftmag(i-2)/cthannfftmagx(i-2);%��ֵ��
    end
  

    cd('..'); % ������һ��·����
    folder_name=0;
end
[w,iw]=sort(real_f);%iw���������ھ������е�λ��
semilogx(w,20*log10(mag_rate(iw)));
ylabel('Amplitude(dB)');
    xlabel('Frequency(Hz)');
% xlabel('Frequency(rad/s)');
%     ylabel('Amplitude(dB)');
