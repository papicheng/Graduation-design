function theta = RLS(M,N,z,u,method,beta,display)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameter estimation using recursive least squre method
% ʹ�õ�����С���˷�����ARMAģ�Ͳ���,���ع��Ʋ���ֵ
% ==========================����˵��===================================
% �������(return parameters)��
%      theta [vec] -  ����ARMA��������
% �������(input parameters):
%         M  [num] -  AR����
%         N  [num] -  MA����
%         z  [vec] -  �������ݣ����ڹ��Ʋ���
%         u  [vec] -  MA���������У�ʵ�����Ǻ��ѵõ�׼ȷ�����е�
%    method  [cha] -  ʹ�õ���С���˷�����
%            - 'RLS'��������С���˷���The recursive least square method
%            - 'fRLS'�����������ӵ���С���˵����㷨
%            - 'oRLS'��ƫ�����С���˵����㷨
%      beta  [num] -  ��������
%   display  [num] -  �������Ʋ��������仯���ߺ����仯����
%            - '0' ������ͼ
%            - '1' ��ֻ�����������Ʊ仯����
%            - '2' : ͬʱ���������仯���ߺ����仯����
% =============================syntax==================================
% ��ʹ����С���˹���ARMA����֮ǰ��Ӧ��׼���ù۲�����z,MA��������u
% ���û��u,���Զ���ΪAR�������ơ�
% example1 �� a = RLS(2,2,z,u,'RLS',[],[])
%             ʹ�õ�����С���˲������ƣ�AR��MA�����ֱ�Ϊ2,2,���������Ϊ�� 
% example2  : a = RLS(2,2,z,u,'fRLS',0.99,2)
%             ʹ�ô��������ӵ���С���˵����㷨������������Ϊ0.99
%             ͬʱ�������Ʋ������������̺͹���������������
% example3 �� a = RLS(2,2,z,u,'oRLS',[],1)
%             ʹ�ò�����С���˹����㷨
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
    error('���������ar�Ľ���M�������1');
end
if M < N
    error('�趨M��ֵ����N�����޸ģ�');
end

if isempty(u)
    Mk = 0.5*randn(1,n+1)./std(randn(1,n+1));     %������
    warning('MA���������Զ��趨Ϊ������');
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
            fprintf('����ͼ\n');
        case 1
            figure;
            for k=1:len
                plot(i,theta(k,:));
                hold on;
            end
            title('������������������');
        case 2
            figure;
            for k=1:len
                plot(i,theta(k,:));
                hold on;
            end
            title('������������������');
            figure;
            for k=1:len
                plot(i,Pstore(k,:));
                hold on;
            end           
            title('���Ʒ������������');
    end

% print estimated parameters in command window
fprintf('�����ƵĲ���ֵΪ��\n');
for k=1:len
    fprintf('%g\n',theta(k,end));
end

end
