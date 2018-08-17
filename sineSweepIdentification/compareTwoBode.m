clc
clear
close all
data=load('ampPhaseTwo.mat');
fo=data.resultData(:,1);
ampo=data.resultData(:,2);
phaseo=data.resultData(:,3);
fc=data.resultData(:,4);
ampc=data.resultData(:,5);
phasec=data.resultData(:,6);
subplot(2,1,1);
semilogx(fo,20*log10(ampo));
grid on;zoom on;
hold on;
semilogx(fc,20*log10(ampc));
legend('Openloop','Closeloop');
ylabel('Amplitude(dB)');
title('Openloop&Closeloop Bode');
subplot(2,1,2);
semilogx(fo,phaseo);
grid on;zoom on;
hold on;
semilogx(fc,phasec);
xlabel('Frequency(Hz)');
ylabel('Phase(Deg)');
legend('Openloop','Closeloop');
