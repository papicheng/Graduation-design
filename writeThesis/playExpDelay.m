bode(conv([1 8 40000],[1 5 43000]),conv([1 5 40000],[1 8 43000]),'k');grid on
set(gca,'xlim',[100,400])

data=0;f=0;pha=0;pha_exp=0;
data=xlsread('G:\study\GraduationThesis\dataOfSine\Axis1_DAC_ENC_SweepSine_07_Apr_2018_21_42_04.xlsx');
f=data(:,1);
pha=data(:,3);

pha_exp=-0.43*f-180;
figure
plot(f,pha,'--gs',...
    'LineWidth',1,...
    'MarkerSize',3,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
hold on
plot(f,pha_exp);
set(gca,'xlim',[150,1001])
xlabel('Frequency(Hz)')
ylabel('Phase(deg)')
legend('原始数据','拟合数据')
grid on