x1=[32 24 18 13.5];

y1=[675 1050 1580 2487];


p=polyfit(log(x1),log(y1),1)  %����ʽ��ϣ�pΪ����ʽϵ��������1ΪҪ��ϳɵĽ���

x2=10:0.1:50;

y2=exp(polyval(p,log(x2)));
figure;
loglog(x1,y1,'*',x2,y2,'-')
grid on;zoom on;