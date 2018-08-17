clc
close all
clear
% data=load('Axis1_DAC_ENC_Prbs_Gain_200_065726.txt');

data=load('Axis1_DAC_ENC_Prbs_Gain_700_103753.txt');
M1=data(:,2);
z1=data(:,1);
mi=1;
while M1(mi)==0
    mi=mi+1;
end
M1_len=length(M1);
while M1(M1_len)==0
    M1_len=M1_len-1;
end

M=M1(mi:M1_len);
z=z1(mi:M1_len);

Np=length(M);
Np=3999;
a=200;
fs=4000;
dt=1/fs;
M=[M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M];
u=M;
z=[z z z z z z z z z z z z z z z z z z z z z z z z z z z z z z z];
r=1;
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

%%%%%%%%%%%一次完成算法%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for zi=1:Np
%     Zp(zi)=z(Np+zi-1);
% end
% Zp=Zp';
% for mi=1:Np
%     for mj=1:Np
%         Mp(mi,mj)=M(Np-mi+mj);
%     end
% end
% g1=1/((Np+1)*a*a*dt)*(ones(Np)+eye(Np))*Mp*Zp;
% for gi=1:Np-1
%     g1(gi)=g1(gi+1);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(g);grid on;