data1=xlsread('G:\study\GraduationThesis\dataOfSine\Axis1_DAC_ENC_SweepSine_07_Mar_2018_16_03_11.xlsx');
fsino=data1(:,1);
ampsino=data1(:,2);
%logampsino=20*log10(ampsino);
phsino=data1(:,3);


fs=4000;%采样频率4000hz
dt=1/fs;%数据采集时间和m序列移位脉冲周期相同
TN=2^17-1;
N=4000;
out=simout.Data;
outftt=out(1:12000);
mfft=m(1:12000);
Mfft=fft(mfft);
zfft=fft(outftt);
Np=length(outftt);
df=fs/Np;
Mmag2 = abs(Mfft);
Mmag1 = Mmag2(2:Np/2+1);%注意+1
zmag2 = abs(zfft);
zmag1 = zmag2(2:Np/2+1);%注意+1
magr=zmag1./Mmag1;
x=[1:Np/2]*(fs/Np);
x=x';
f=x;
%------------------------------------------------------------
% A=medfit(20,magr);
% magr=smoothfilt(20,A);
G=20*log10(magr);%bode图幅值

% fitlen=length(G);
% stepx=round(fitlen/300);
% for i=1:fitlen
%     if f(i)>100%从一百HZ开始，用取1000个点的方法
%         startx=i;
%         break;
%     end
% end
% %%%%%%%%%%%%%%%%%%记录下从原始图中取下的位置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% positon=[1:startx-1,startx:stepx:fitlen];
% fitf=f(positon);
% fitG=G(positon);

%------------------------------------------------------



% if Np<=6000
%     movepoint=40;
% end
% if Np>6000&&Np<=10000
%     movepoint=60;
% end
% if Np>10000
%     movepoint=150;
% end
% A = medfilt1(magr,30);
% yyy=moving_average(A,movepoint);
% yyy__=yyy;
% %                 revisepoint=8;
% %                 movepoint=round(revisepoint/df);
% %                 yyy(1:end-movepoint+1)=yyy__(movepoint:end);
% magr=yyy;
% G=20*log10(magr);%bode图幅值


figure;
semilogx(f,G);
zoom on;grid on;hold on
semilogx(fsino,logampsino);

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