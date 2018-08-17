
clc

data=xlsread('G:\study\GraduationThesis\dataOfSine\ʵ��\Axis1_DAC_ENC_SweepSine_16_Jan_2018_20_18_43.xlsx');
f_=data(:,1);
ampsin_=data(:,2);
logampsin_=20*log10(ampsin_);
phsin_=data(:,3);
figure
subplot(2,1,1)
semilogx(f_,logampsin_);grid on
title('�ٶȱջ�����ɨƵBODEͼ')
ylabel('��ֵ')
set(gca,'xlim',[1 2000])
subplot(2,1,2)
semilogx(f_,phsin_);grid on
xlabel('Ƶ�ʣ�Hz��')
ylabel('��λ')
set(gca,'xlim',[1 2000])



data=xlsread('G:\study\GraduationThesis\dataOfSine\X-Y-Table-�ٶȱջ�\Axis1_RefVel_EncVel_SweepSine_18_Jan_2018_11_10_45.xlsx');
fsin=data(:,1);
ampsin=data(:,2);
logampsin=20*log10(ampsin);
phsin=data(:,3);

i=1;
while fitf(i)<1000
    i=i+1;
end
fadd=fitf(i:3:end);
Gadd=fitG(i:3:end)-1;
fadd1=[fsin;fadd];
Gadd1=[logampsin;Gadd];
figure
subplot(2,1,1)
semilogx(fadd1,Gadd1);grid on
title('�ٶȱջ�����ɨƵBODEͼ')
ylabel('��ֵ')
set(gca,'xlim',[1 2000])
subplot(2,1,2)
semilogx(fadd1box,padd1box);grid on
xlabel('Ƶ�ʣ�Hz��')
ylabel('��λ')
set(gca,'xlim',[1 2000])




figure
subplot(2,1,1)
semilogx(fsin,logampsin);grid on
title('�ٶȱջ�����ɨƵBODEͼ')
ylabel('��ֵ')
subplot(2,1,2)
semilogx(fsin,phsin);grid on
xlabel('Ƶ�ʣ�Hz��')
ylabel('��λ')

figure
semilogx(fadd1,Gadd1);grid on
hold on
semilogx(fitf,fitG);
title('�ٶȱջ���Ƶͼ�Ա�')
xlabel('Ƶ�ʣ�Hz��')
ylabel('��ֵ')
legend('����ɨƵ','PRBS')
set(gca,'xlim',[0.02 2000])


data=xlsread('G:\study\GraduationThesis\dataOfSine\Axis1_DAC_ENC_SweepSine_07_Mar_2018_16_03_11.xlsx');
fsino=data(:,1);
ampsino=data(:,2);
logampsino=20*log10(ampsino);
phsino=data(:,3);

faddo=[fsino;fadd(1:19)];
Gaddo=[logampsino;Gadd(1:19)+31.882];
faddo=[faddo;fadd(20:2:end)];
Gaddo=[Gaddo;Gadd(20:2:end)+31.882];
figure
subplot(2,1,1)
semilogx(faddo,Gaddo);
set(gca,'xlim',[1 2000])
grid on
title('��������ɨƵBODEͼ')
ylabel('��ֵ')
poa=[phsino;paddbox(1:35)+101.9];
subplot(2,1,2)
semilogx(faddo,poa)
grid on
set(gca,'xlim',[1 2000])
xlabel('Ƶ�ʣ�Hz��')
ylabel('��λ')

% boxdata=xlsread('G:\study\GraduationThesis\dissertationAndMore\���Ļ�ͼ\X���ٶȱջ�_PRBS_Ƶ��_����.xlsx');
% boxf=boxdata(:,1);
% boxf=boxf/2/pi;
% % boxcomplex=boxdata(:,2);
% for i=1:length(boxcomplex)
% strcomplex=cell2mat(boxcomplex(i));
% numcomplex(i)=str2num(strcomplex);
% end
% boxamp=20*log10(abs(numcomplex));


data=xlsread('G:\study\GraduationThesis\dataOfSine\X-Y-Table-�ٶȱջ�\X-Y-Table-X���ٶȱջ�Prbs\Axis1_RefVel_EncVel_Prbs_12_Jan_2018_21_05_52.xlsx');
f=data(:,1);
amp=data(:,2);
Np=length(amp);

% ampAdjust(amp,amplog);

% if Np<=6000
%     movepoint=40;
% end
% if Np>6000&&Np<=10000
%     movepoint=60;
% end
% if Np>10000
%     movepoint=150;
% end
% A = medfilt1(amp,30);
% yyy=moving_average(A,movepoint);
% yyy__=yyy;
% %                 revisepoint=8;
% %                 movepoint=round(revisepoint/df);
% %                 yyy(1:end-movepoint+1)=yyy__(movepoint:end);
% magr=yyy;
A=medfit(20,amp);
magr=smoothfilt(20,A);
G=20*log10(magr);%bodeͼ��ֵ

fitlen=length(G);
stepx=round(fitlen/300);
for i=1:fitlen
    if f(i)>100%��һ��HZ��ʼ����ȡ1000����ķ���
        startx=i;
        break;
    end
end
%%%%%%%%%%%%%%%%%%��¼�´�ԭʼͼ��ȡ�µ�λ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
positon=[1:startx-1,startx:stepx:fitlen];
fitf=f(positon);
fitG=G(positon);
figure
semilogx(f,20*log10(amp));grid on;zoom on;
hold on
semilogx(fitf,fitG);
xlabel('Ƶ�ʣ�HZ��')
ylabel('��ֵ')
legend('�˲�ǰ','�˲���')
title('�ٶȱջ�PRBS��Ƶ����')
set(gca,'xlim',[0.02 2000])
% semilogx(boxf,boxamp);

% dd=xlsread('G:\study\GraduationThesis\VSProgram\C#\SweepFrequencyDrawing20180310\SweepFrequencyDrawing\bin\Debug\Axis1_RefVel_EncVel_Prbs_filtered_20180315090703.csv');
% ff=dd(:,1);
% aa=dd(:,2);
% figure;
% semilogx(f,amplog);grid on;zoom on;%original pic
% hold on;
% semilogx(f,G);
% semilogx(fsin,logampsin);
% % semilogx(fsino,logampsino);
% semilogx(fitf,fitG);
% a=abs(mydataff.ResponseData(1,1,:));
% a=a(:);
% semilogx(mydataff.Frequency/2/pi,20*log10(a));
% %semilogx(ff,aa);
% legend('ԭʼͼ','������ֵ','���ұջ�','300','������')
% 


function ampAdjust(amp,amplog)
if amp(1)<1.5&&amp(1)>0.5
    amplog=20*log10(amp);
else
    amplog=amp;
    amp=10.^(amp/20);
end
end

function smoothedBuf= medfit(N,originalBuf)
if mod(N,2)~=0
    N=N+1;
end
smoothedBuf=originalBuf;
len=length(originalBuf);
for n=1:len-N+1
    Nbuf=originalBuf(n:n+N-1);
    smoothedBuf(n+N/2)=median(Nbuf);
end
smoothedBuf(len-N/2:len)=smoothedBuf(len-N/2);
end
function smoothedBuf=smoothfilt(N,originalBuf)
smoothedBuf=originalBuf;
len=length(originalBuf);
if mod(N,2)~=0
    N=N+1
end
for n=1:len-N+1
    Nbuf=originalBuf(n:n+N-1);
    smoothedBuf(n+N/2)=mean(Nbuf);
end
smoothedBuf(len-N/2:len)=smoothedBuf(len-N/2);
end