steps=150;
hwait=waitbar(0,'��ȴ�>>>>>>>>');
step=steps/100;
for k=1:steps
    if steps-k<=5
        waitbar(k/steps,hwait,'�������');
        pause(50);
    else
        PerStr=fix(k/step);
        str=['����������',num2str(PerStr),'%'];
        waitbar(k/steps,hwait,str);
        pause(50);
    end
end
close(hwait);