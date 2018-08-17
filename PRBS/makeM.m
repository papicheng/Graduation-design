clc 
clear
close all

% function[mseq]=m_sequence(fbconnection)
fbconnection=[0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 1];
n=length(fbconnection);
N=2^n-1;
% register=[zeros(1,n-1) 1];
register=[1 1 0 1 0 0 0 0 1 0 1 1 1 1 0 1];%��λ�Ĵ����ĳ�ʼ״̬ ��[r(i),r(i-1),r(i-2),...r(0)];
mseq(1)=register(n);
%m���еĵ�һ�������Ԫ
for i=2:N
    newregister(1)=mod(sum(fbconnection.*register),2);
    for j=2:n,
        newregister(j)=register(j-1);
    end;
    register=newregister;
    mseq(i)=register(n);
end
len=length(mseq);
stairs(mseq);
mfft=fft(mseq);

% f = Fs*(0:(Np/2))/Np;
Mmag2 = abs(mfft/len);
Mmag1 = Mmag2(1:len/2+1);%ע��+1
Mmag1(2:end-1) = 2*Mmag1(2:end-1);
figure;
stem(Mmag1);