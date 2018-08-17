clear;
clc;
close all;
sigma=0.5;%input('白噪声标准差设定为? ');
r=3;%input('生成数据周期数（1—3）? ');

%%%%%%%%%%%%%%生成a=1,P=6的M序列%%%%%%%%%%%%%%%%%
M=[0 0 1 0 1 0 0];
Np=2^6-1;
for k=1:252
     if M(7)==0 
        u(k)=1;end;
     if M(7)==1  
        u(k)=-1;end;
     for i=7:-1:2
        M(i)=M(i-1);
     end
     M(1)=M(6)+M(7);
     if M(1)==2 
        M(1)=0;end;
end
% u=u-mean(u);
% for ui=1:r-1
%     u=[u u];
% end
% for pui=1:length(u)
% fid = fopen('Mtest.txt','a+');
%     fprintf(fid,'%g\n',u(pui));       % \n 换行
%     fclose(fid);
% end
stairs(u);title('M');
%%%%%%%%%%%%%%%生成高斯白噪声%%%%%%%%%%%%%%%%%%%%
A=179;  xi=11;  M=2^15;
for k=1:252        
    ksai=0;
    for i=1:12
        xi=A*xi;
        xi=mod(xi,M);
        ksai=ksai+(xi/M);
    end
v(k)=sigma*(ksai-6);
end

%%%%%%%%%%%%%%%%%%理论输出数据%%%%%%%%%%%%%%%%%%%%%%
k=120; T1=8.3; T2=6.2; T0=1;
K=k/(T1*T2);
E1=exp(-T0/T1);
E2=exp(-T0/T2);
x(1)=0;y(1)=0;
for k=2:252
    x(k)=E1*x(k-1)+T1*K*(1-E1)*u(k-1)+T1*K*(T1*(E1-1)+T0)*(u(k)-u(k-1))/T0;
    y(k)=E2*y(k-1)+T2*(1-E2)*x(k-1)+T2*(T2*(E2-1)+T0)*(x(k)-x(k-1))/T0;
end
z=y+v;
% for pzi=1:length(z)
% fid = fopen('Ztest.txt','a+');
%     fprintf(fid,'%g\n',z(pzi)');       % \n 换行
%     fclose(fid);
% end
figure;plot(z);
%%%%%%%%%%%%%%%%%%计算互相关函数%%%%%%%%%%%%%%%%%%
for k=1:Np
    R(k)=0;
    for i=(Np+1):(r+1)*Np
        R(k)=R(k)+u(i-k)*z(i);
    end
    Rmz(k)=R(k)/(r*Np);
end
%%%%%%%%%%%%%%%%%%脉冲响应估计值%%%%%%%%%%%%%%%%%%
for k=1:Np
    g(k)=(Rmz(k)-Rmz(Np-1))*Np/(Np+1);
end

%%%%%%%%%%%%%%%%%%脉冲响应理论值%%%%%%%%%%%%%%%%%%
K=120;
for k=1:Np
g0(k)=K*(exp(-k/T1)-exp(-k/T2))/(T1-T2);
end
%%%%%%%%%%%%%%%%%%脉冲响应估计误差%%%%%%%%%%%%%%%%%%%
G=g0-g;
GG=G.*G;
gg=g0.*g0;
E=sqrt(sum(GG)/sum(gg))
g(end)=g(end-1);
figure
plot(1:Np,g,'r*')
hold on
plot(1:Np,g0,'.')
legend('脉冲响应估计曲线','脉冲响应理论曲线')
n=3;%辨识阶次
L=length(g);

G1=[g(1),g(2),g(3);g(2),g(3),g(4);g(3),g(4),g(5)];
G2=-[g(4);g(5);g(6)];
iG1=inv(G1);
A1=iG1*G2;
A=fliplr(A1);
A2=[1,0,0;A(1),1,0;A(2),A(1),1];
G3=[g(1);g(2);g(3)];
B=A2*G3;
 dsys = tf( B',[1 A'],1 ); %系统传递函数z/(z-1),采样时间1
scsys = d2c( dsys,'tustin' ); %采用双线性变换
[num,den] = tfdata( scsys,'v' );%获得s传函的分子和分母
% g=[g g g];
%%%%%%%%%%%%%%求G1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=1:L%行
%     for j=1:n%列
%         G1(i,j)=g(j+i-1+1);
%     end
% end
% for i=n+1:n+L
%     G2(i)=g(i+1);
% end
% G2=G2';
% G2=-G2;
% iG1=inv(G1);
% A1=iG1*G2;
% A=fliplr(A1);
% A2=eye(n+1);
% for i=2:n+1
%     for j=1:n
%         if i-
%         
% A2=[1,0,0,0;A(1),1,0,0;A(2),A(1),1,0;A(3),A(2),A(1),1];
% G3=[g(1);g(2);g(3);g(4)];
% B=A2*G3;
%%%%%%%%%%%%%%%%%%%%%%计算噪声方差%%%%%%%%%%%%%%%%%
a=0;
for i=1:length(v)
    a=a+v(i);
end
a=a/252;
varv=0;
for i=1:252
    varv=varv+(v(i)-a)^2;
end
varv=varv/252;
%%%%%%%%%%%%%%%%%%%计算过程输出数据方差%%%%%%%%%%%%%%%%
b=0;
for i=1:length(y)
    b=b+y(i);
end
b=b/252;
vary=0;
for i=1:252
    vary=vary+(y(i)-b)^2;
end
vary=vary/252;
%%%%%%%%%%%%%%%%%%%%计算过程信噪比%%%%%%%%%%%%%%%%%%
xinzaobi=sqrt(varv/vary)