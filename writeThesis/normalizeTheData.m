close all
clear
data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f1001_Gain_1200_092240.txt');
data2=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f801_Gain_1200_092159.txt');
y=data(:,1);
y2=data2(:,1);
y=y(300:350);
y2=y2(300:350);
for i=1:length(y2)
    if y2(i)>198
        y2(i)=y2(i)*1.05;
    end
    if y2(i)<198
        y2(i)=y2(i)*0.95;
    end
end

% y=[1 3 2 5 7 9 13 2 5 7];
% y2=[6 2 7 3 8 0 1 2 7 0];
% y=rand(1,20)*10;
% y2=rand(1,20)*100;
y=y;
yy=linearNormal(y);
yy2=linearNormal(y2);
t=(0:length(y)-1);
figure('color',[1 1 1]);
plot(t,y)
hold on;
plot(t,y2)
grid on;
set(gca,'YLim',[185 212]);%X���������ʾ��Χ

title('��һ��ǰ')
legend('����1','����2');
figure('color',[1 1 1]);
plot(t,yy)
hold on;
plot(t,yy2)
grid on;
title('��һ����')
legend('����1','����2');
set(gca,'YLim',[-0.05 1.05]);%X���������ʾ��Χ

function [normalized_data] = normalize(source_data, kind)
% ���ݵı�׼������һ��������
% ����filename ���ø�ʽ��Դ����
% ����kind ������ֹ�һ�� 1��[0~1]��׼�� 2��[-1~1]��׼��
% ���ع�һ���������

if nargin < 2
    kind = 1; % Ĭ�Ͻ���[0-1]��׼�� ����Min-Max��׼��
end;

[m,n]  = size(source_data);
normalized_data = zeros(m, n);

%% normalize the data x to [0,1]
if kind == 1
    for i = 1:n
        ma = max( source_data(:, i) ); % Matlab�б��������˺ͺ�������ͬ�����Բ���max��min��mean�ȱ�����
        mi = min( source_data(:, i) );
        normalized_data(:, i) = ( source_data(:, i)-mi ) / ( ma-mi );
    end
end
%% normalize the data x to [-1,1]
if kind == 2
    for i = 1:n
        mea = mean( source_data(:, i) );
        st = std( source_data(:, i) );
        normalized_data(:, i) = ( source_data(:, i)-mea ) / st;
    end
end
end
function y=linearNormal(x)
y=(x-min(x))/(max(x)-min(x));
end