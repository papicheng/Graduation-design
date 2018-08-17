
boxphase=angle(numcomplex);
boxphase=boxphase*180/pi;
phase_diff=boxphase;
plen=length(phase_diff);
for ii=1:plen
    if phase_diff(ii)>0
        if boxf(ii)<10&&phase_diff(ii)<30
            continue
        end
        phase_diff(ii)=phase_diff(ii)-360;
    end
end
for i0=3:plen
    if ((abs(phase_diff(i0-1)+360) < 50 || ...
            abs(phase_diff(i0 - 2) + 360) < 50 || ...
            abs(phase_diff(i0)-phase_diff(i0-1))>90 ||...
            abs(phase_diff(i0)-phase_diff(i0-2))>90) && ...
            (phase_diff(i0)>-180))...
            ||...
            (abs(phase_diff(i0) - phase_diff(i0 - 1)) > 300 &&...
            (phase_diff(i0) > -360))
        
        phase_diff(i0) = phase_diff(i0) - 360;
        
    end
end
loopflag=5;
while loopflag
    loopflag=loopflag-1;
    for i0=3:plen
        if abs(phase_diff(i0) - phase_diff(i0 - 1)) > 250
            phase_diff(i0) = phase_diff(i0) - 360;
        end
    end
end

figure
semilogx(boxf,phase_diff)
i=1;
while boxf(i)<1000
    i=i+1;
end
faddbox=boxf(i:3:end);
paddbox=phase_diff(i:3:end);
fadd1box=[fsin;faddbox];
padd1box=[phsin;paddbox];

figure
% subplot(2,1,1)
semilogx(fadd1box,padd1box);grid on