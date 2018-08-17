data=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f51_Gain_1000_043150.txt');
in=data(:,2);
out=data(:,1);
if out(1)~=0
    out=out-out(1);
end
lon=length(in);
t=(0:lon-1)/4000;
t=t';

data300=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f300_Gain_1200_091928.txt');
in300=data300(:,2);
out300=data300(:,1);
if out300(1)~=0
    out300=out300-out300(1);
end
lon300=length(in300);
t300=(0:lon300-1)/4000;
t300=t300';


data981=load('G:\study\GraduationThesis\dataOfSine\openLoop1_1001Hz\Axis1_DAC_ENC_SweepSine_f981_Gain_1200_092236.txt');
in981=data981(:,2);
out981=data981(:,1);
if out981(1)~=0
    out981=out981-out981(1);
end
lon981=length(in981);
t981=(0:lon981-1)/4000;
t981=t981';

data_prbs=load('G:\study\GraduationThesis\dataOfSine\Prbs\Axis1_DAC_ENC_Prbs_Gain_200_034741.txt');
in_prbs=data_prbs(:,2);
out_prbs=data_prbs(:,1);
if out_prbs(1)~=0
    out_prbs=out_prbs-out_prbs(1);
end
lon_prbs=length(out_prbs);
t_prbs=(0:lon_prbs-1)/4000;
t_prbs=t_prbs';

idealmode=tf(1.118e4,[1 8.013 32.1]);
zpk(idealmode)
zpkdata(idealmode)
margin(idealmode)


