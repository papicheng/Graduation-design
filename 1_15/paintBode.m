num=xlsread('G:\study\GraduationThesis\dataOfSine\X-Y-Table-ËÙ¶È±Õ»·\Axis2_RefVel_EncVel_SweepSine_12_Jan_2018_10_50_26.xlsx');
fn=num(:,1);
amp=num(:,2);
logamp=20*log10(amp);
phase=num(:,3);
figure;
semilogx(fn,logamp);grid on; zoom on;
figure;
semilogx(fn,phase);grid on;zoom on;