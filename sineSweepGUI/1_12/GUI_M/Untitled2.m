% syms w zeta
% [solv,solu]=solve([abs((w*w/(-630*630+2*zeta*w*1i*630+w*w)))==0.70794578,abs((w*w/(-1000*1000+2*zeta*w*1i*1000+w*w)))==0.501187233627272],[zeta,w])
wn=1000;
figure
bode(wn*wn,[1,2*wn,wn*wn])
grid on


% [solv,solu]=solve('630=w*sqrt(1-2*zeta*zeta+sqrt(2-4*zeta*zeta+4*zeta^4))','abs((w*w/(1000*1000+2*zeta*w*1i*1000+w*w)))=0.5011',[zeta,w])

g1=tf(10^6,[1,2000,10^6])
g2=tf([1,0.2,1],[10,1000,0])
g=g1*g2
g=zpk(g)
[z1,p,k]=zpkdata(g)

g3=tf(10^5*[1,0.2,1],[1,100,0]);
