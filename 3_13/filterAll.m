data=xlsread('G:\study\GraduationThesis\dataOfSine\X-Y-Table-ËÙ¶È±Õ»·\Axis1_RefVel_EncVel_SweepSine_18_Jan_2018_11_10_45.xlsx');
f=data(:,1);
logamp=data(:,2);
ph=data(:,3);
a=abs(c_x_pff500.ResponseData(1,1,:));
b=angle(c_x_pff500.ResponseData(1,1,:))*180/pi;
phase_diff=b(1,1,:);

plen=length(phase_diff(1,1,:));
for i=1:plen
    if phase_diff(1,1,(i))>0
        phase_diff(1,1,(i))=phase_diff(1,1,(i))-360;
    end
end
for i0=3:plen
    if ((abs(phase_diff(1,1,(i0-1))+360) < 50 || ...
            abs(phase_diff(1,1,(i0 - 2)) + 360) < 50 || ...
            abs(phase_diff(1,1,(i0))-phase_diff(1,1,(i0-1)))>90 ||...
            abs(phase_diff(1,1,(i0))-phase_diff(1,1,(i0-2)))>90) && ...
            (phase_diff(1,1,(i0))>-180))...
            ||...
            (abs(phase_diff(1,1,(i0)) - phase_diff(1,1,(i0 - 1))) > 300 &&...
            (phase_diff(1,1,(i0)) > -360))
        
        phase_diff(1,1,(i0)) = phase_diff(1,1,(i0)) - 360;
        
    end
end
for i0=3:plen
    if abs(phase_diff(1,1,(i0)) - phase_diff(1,1,(i0 - 1))) > 250
        phase_diff(1,1,(i0)) = phase_diff(1,1,(i0)) - 360;
    end
end
for i0=3:plen
    if abs(phase_diff(1,1,(i0)) - phase_diff(1,1,(i0 - 1))) > 250
        phase_diff(1,1,(i0)) = phase_diff(1,1,(i0)) - 360;
    end
end
for i0=3:plen
    if abs(phase_diff(1,1,(i0)) - phase_diff(1,1,(i0 - 1))) > 250
        phase_diff(1,1,(i0)) = phase_diff(1,1,(i0)) - 360;
    end
end
b=phase_diff;

a1=abs(c_x_pff_log1000.ResponseData(1,1,:));
b1=angle(c_x_pff_log1000.ResponseData(1,1,:))*180/pi;
phase_diff=b1(1,1,:);

plen=length(phase_diff(1,1,:));
% for i=1:plen
%     if phase_diff(1,1,(i))>0
%         phase_diff(1,1,(i))=phase_diff(1,1,(i))-360;
%     end
% end
for i0=3:plen
    if ((abs(phase_diff(1,1,(i0-1))+360) < 50 || ...
            abs(phase_diff(1,1,(i0 - 2)) + 360) < 50 || ...
            abs(phase_diff(1,1,(i0))-phase_diff(1,1,(i0-1)))>90 ||...
            abs(phase_diff(1,1,(i0))-phase_diff(1,1,(i0-2)))>90) && ...
            (phase_diff(1,1,(i0))>-180))...
            ||...
            (abs(phase_diff(1,1,(i0)) - phase_diff(1,1,(i0 - 1))) > 300 &&...
            (phase_diff(1,1,(i0)) > -360))
        
        phase_diff(1,1,(i0)) = phase_diff(1,1,(i0)) - 360;
        
    end
end
for i0=3:plen
    if abs(phase_diff(1,1,(i0)) - phase_diff(1,1,(i0 - 1))) > 250
        phase_diff(1,1,(i0)) = phase_diff(1,1,(i0)) - 360;
    end
end
for i0=3:plen
    if abs(phase_diff(1,1,(i0)) - phase_diff(1,1,(i0 - 1))) > 250
        phase_diff(1,1,(i0)) = phase_diff(1,1,(i0)) - 360;
    end
end
for i0=3:plen
    if abs(phase_diff(1,1,(i0)) - phase_diff(1,1,(i0 - 1))) > 250
        phase_diff(1,1,(i0)) = phase_diff(1,1,(i0)) - 360;
    end
end
for i0=3:plen
    if abs(phase_diff(1,1,(i0)) - phase_diff(1,1,(i0 - 1))) > 250
        phase_diff(1,1,(i0)) = phase_diff(1,1,(i0)) - 360;
    end
end
b1=phase_diff;
a=a(:);
b=b(:);
a1=a1(:);
b1=b1(:);
figure;
semilogx(f,20*log10(logamp));grid on;hold on;
semilogx(c_x_pff500.Frequency/2/pi,20*log10(a));
semilogx(c_x_pff_log1000.Frequency/2/pi,20*log10(a1));
legend('sine','c_x_pff500','c_x_pff_log1000')
figure;
semilogx(f,ph);grid on;hold on;
semilogx(c_x_pff500.Frequency/2/pi,b);
semilogx(c_x_pff_log1000.Frequency/2/pi,b1);
legend('sine','c_x_pff500','c_x_pff_log1000')
figure;
plot(f,logamp);grid on;hold on;
plot(c_x_pff500.Frequency/2/pi,a);
plot(c_x_pff_log1000.Frequency/2/pi,a1);
legend('sine','c_x_pff500','c_x_pff_log1000')
figure;
plot(f,ph);grid on;hold on;
plot(c_x_pff500.Frequency/2/pi,b);
plot(c_x_pff_log1000.Frequency/2/pi,b1);
legend('sine','c_x_pff500','c_x_pff_log1000')
