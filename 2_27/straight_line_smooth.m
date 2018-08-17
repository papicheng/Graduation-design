function straight_line_smooth(x,yin,yout)
yout=yin;
len=length(yin);
if yout(1)>yout(len)%µ¥µ÷µÝ¼õ
    for i=2:len-1
        if yout(i)<yout(i+1)
            yout(i)=(yout(i-1)-yout(i+1))/(x(i-1)-x(i+1))*(x(i)-x(i+1))+yout(i+1);
        end
    end
end