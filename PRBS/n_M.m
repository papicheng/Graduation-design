clear all
close all
clc

L = 60;
x1 = 1; x2 = 1; x3 = 1; x4 = 0; S = 1;

for k = 1:L
    IM = xor(S,x4);
    if IM == 0
        u(k) = -1;
    else
        u(k) = 1;
    end
    S = not(S);
    M(k) = xor(x3,x4);
    x4 = x3; x3 = x2; x2 = x1; x1 = M(k);
end

% subplot(211)
% stairs(M);
% grid on;
% axis([0 L -0.5 1.5]);
% xlabel('k');
% ylabel('幅值');
% title('M序列')

% subplot(212)
stairs(u);
grid on;
axis([0 L -1.5 1.5]);
xlabel('k');
ylabel('幅值');
title('逆M序列')
mfft=fft(u);
len=length(u);
Mmag2 = abs(mfft/len);
Mmag1 = Mmag2(1:len/2+1);%注意+1
Mmag1(2:end-1) = 2*Mmag1(2:end-1);
figure;
stem(Mmag1);