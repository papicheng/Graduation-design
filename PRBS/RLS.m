function theta = RLS(M,N,z,u,method,beta,display)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameter estimation using recursive least squre method
% 使用递推最小二乘法估计ARMA模型参数,返回估计参数值
% ==========================参数说明===================================
% 输出参数(return parameters)：
%      theta [vec] -  返回ARMA参数估计
% 输入参数(input parameters):
%         M  [num] -  AR阶数
%         N  [num] -  MA阶数
%         z  [vec] -  输入数据，用于估计参数
%         u  [vec] -  MA的噪声序列，实际上是很难得到准确的序列的
%    method  [cha] -  使用的最小二乘法类型
%            - 'RLS'：递推最小二乘法，The recursive least square method
%            - 'fRLS'：带遗忘因子的最小二乘递推算法
%            - 'oRLS'：偏差补偿最小二乘递推算法
%      beta  [num] -  遗忘因子
%   display  [num] -  画出估计参数参数变化曲线和误差变化曲线
%            - '0' ：不画图
%            - '1' ：只画出参数估计变化曲线
%            - '2' : 同时画出参数变化曲线和误差变化曲线
% =============================syntax==================================
% 在使用最小二乘估计ARMA参数之前，应该准备好观测序列z,MA噪声序列u
% 如果没有u,将自动视为AR参数估计。
% example1 ： a = RLS(2,2,z,u,'RLS',[],[])
%             使用递推最小二乘参数估计，AR和MA阶数分别为2,2,后两项参数为空 
% example2  : a = RLS(2,2,z,u,'fRLS',0.99,2)
%             使用带遗忘因子的最小二乘递推算法，遗忘因子设为0.99
%             同时画出估计参数的收敛过程和估计误差的收敛过程
% example3 ： a = RLS(2,2,z,u,'oRLS',[],1)
%             使用补偿最小二乘估计算法
% ======================================================================
% Written by zhangwenyu,2013,12,12
% If you have any suggestions, mail me at 13120179@bjtu.edu.cn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = length(z);
len = M+N;

% check arguments
if isempty(method)
    method = 'RLS';
end
if isempty(beta)
    beta = 0.98;
end
if isempty(display)
    display = 1;
end
if M <= 1
    error('输入参数中ar的阶数M必须大于1');
end
if M < N
    error('设定M的值大于N，请修改！');
end

if isempty(u)
    Mk = 0.5*randn(1,n+1)./std(randn(1,n+1));     %白噪声
    warning('MA噪声序列自动设定为白噪声');
else
    Mk = u;
end

% A Mk (colored noise) generate process 
% x = [0 1 0 1 1 0 1 1 1];   
% for i=1:n+len-1
%     temp=xor(x(4),x(9));
%     Mk(i)=x(9);
%     for j=9:-1:2
%         x(j)=x(j-1);
%     end
%     x(1)=temp;
% end

% Initialization settings
P = 2*eye(len);
Pstore = zeros(len,n-1);
for k=1:len
    Pstore(k,1) = P(k,k);
end
theta = zeros(len,n-1);
theta(:,1) = 2;
h = zeros(len,1);

% choose which method to use
switch method 
% RLS method    
    case 'RLS'
    for i = M+1:n
        for p=1:M
            h(p) = -z(i-p);
        end
        for q=1:N
            h(M+q) = Mk(i-q);
        end
        K = P*h*inv(h'*P*h+1);
        theta(:,i-1) = theta(:,i-2)+K*(z(i)-h'*theta(:,i-2));
        P = (eye(len)-K*h')*P;
        for j=1:len 
            Pstore(j,i-1) = P(j,j);
        end
    end
% RLS with forgetting factor
% useful in time-varying parameter estimation   
    case 'fRLS'
    for i = M+1:n
       for p=1:M
           h(p) = -z(i-p);
       end
       for q=1:N
           h(M+q) = Mk(i-q);
       end
       K = P*h*inv(h'*P*h+1);
       theta(:,i-1) = theta(:,i-2)+K*(z(i)-h'*theta(:,i-2));
       P = (eye(len)-K*h')*P/beta;
       for j=1:len 
           Pstore(j,i-1) = P(j,j);
       end  
    end
% RLS with bias compensation method
    case 'oRLS'
        thetaO = zeros(len,n-1);
        thetaO(:,1) = 2;
        D = [eye(M) zeros(M,N);zeros(N,len)];
        J = 0;
    for i = M+1:n
       for p=1:M
           h(p) = -z(i-p);
       end
       for q=1:N
           h(M+q) = Mk(i-q);
       end
       J=J+(z(i-1)-h'*theta(:,i-1))^2/(1+h'*P*h);
       K = P*h*inv(h'*P*h+1);
       theta(:,i-1) = theta(:,i-2)+K*(z(i)-h'*theta(:,i-2));
       P = (eye(len)-K*h')*P/beta;
       for j=1:len 
           Pstore(j,i-1) = P(j,j);
       end
       es=J/((i-1)*(1+(thetaO(:,i-2))'*D*theta(:,i-1)));
       thetaO(:,i-1)=theta(:,i-1)+(i-1)*es*P*D*thetaO(:,i-2);
    end
end

% set display options
    i=1:n-1;  
    switch display
        case 0
            fprintf('不画图\n');
        case 1
            figure;
            for k=1:len
                plot(i,theta(k,:));
                hold on;
            end
            title('待估参数的收敛过程');
        case 2
            figure;
            for k=1:len
                plot(i,theta(k,:));
                hold on;
            end
            title('待估参数的收敛过程');
            figure;
            for k=1:len
                plot(i,Pstore(k,:));
                hold on;
            end           
            title('估计方差的收敛过程');
    end

% print estimated parameters in command window
fprintf('待估计的参数值为：\n');
for k=1:len
    fprintf('%g\n',theta(k,end));
end

end
