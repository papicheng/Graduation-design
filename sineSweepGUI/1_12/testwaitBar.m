steps=150;
hwait=waitbar(0,'请等待>>>>>>>>');
step=steps/100;
for k=1:steps
    if steps-k<=5
        waitbar(k/steps,hwait,'即将完成');
        pause(50);
    else
        PerStr=fix(k/step);
        str=['正在运行中',num2str(PerStr),'%'];
        waitbar(k/steps,hwait,str);
        pause(50);
    end
end
close(hwait);