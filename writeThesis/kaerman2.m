clear all
N=200;
w=0.1*randn(1,N);
x(1)=0;
a=1;
x(1)=25;
V=randn(1,N);  %  ��������
q1=std(V);    %  std��A����������������ı�׼���ʱ���Ե���N-1��
Rvv=q1.^2;    %  ������������
q2=std(x);    %  ���ݱ�׼��
Rxx=q2.^2;    %  ���ݷ���
q3=std(w);    %  ����������׼��
Qww=q3.^2;    %  ������������

c=0.2;
Y=x+V;
p(1)=1;
Bs(1)=0;
for t=2:N
x(t)=x(t-1);
p1(t)=p(t-1)+Qww;
Kg(t)=p1(t)/(p1(t)+Rvv);
Bs(t)=x(t)+Kg(t)*(Y(t)-x(t-1));
p(t)=p1(t)-Kg(t)*p1(t);
end
t=1:N;
plot(t,Bs, 'r' ,t,Y, 'g ',t,x,' b' );