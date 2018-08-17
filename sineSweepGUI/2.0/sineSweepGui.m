function varargout = sineSweepGui(varargin)
% SINESWEEPGUI MATLAB code for sineSweepGui.fig
%      SINESWEEPGUI, by itself, creates a new SINESWEEPGUI or raises the existing
%      singleton*.
%
%      H = SINESWEEPGUI returns the handle to a new SINESWEEPGUI or the handle to
%      the existing singleton*.
%
%      SINESWEEPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SINESWEEPGUI.M with the given input arguments.
%
%      SINESWEEPGUI('Property','Value',...) creates a new SINESWEEPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sineSweepGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sineSweepGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sineSweepGui

% Last Modified by GUIDE v2.5 27-Mar-2018 14:33:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @sineSweepGui_OpeningFcn, ...
    'gui_OutputFcn',  @sineSweepGui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before sineSweepGui is made visible.
function sineSweepGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sineSweepGui (see VARARGIN)

% Choose default command line output for sineSweepGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sineSweepGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% axis off;
global folder_name;global loopLock sweep ;
folder_name=0;loopLock=0;sweep=0;
global closeflag openflag prbsflag sinesweepflag changerate amprate kindscomp
changerate=0;amprate=0;
closeflag=0;
openflag=0;
prbsflag=0;
sinesweepflag=0;
kindscomp=0;
set(handles.calculating,'string',sprintf('           '));
% axes('Parent',handles.paint,f,...                   %����������
%    'position',[0.06 0.55 0.3 0.17],...
%    'visible','on');
% axes2 = axes('Parent',handles.paint,f,...                   %����������
%    'position',[0.06 0.77 0.3 0.17],...
%    'visible','on');


% --- Outputs from this function are returned to the command line.
function varargout = sineSweepGui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openData.
function openData_Callback(hObject, eventdata, handles)
% hObject    handle to openData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [fname,pname,index]=uigetfile('*.txt','ѡ�������ļ�');
% if index
%     str=[pname fname];

a = findobj(handles.comp,'style','checkbox')
set(a,'Value',0)

go=0;startplot=0;
set(handles.calculating,'string',sprintf('���ڴ���...'));
global folder_name;global loopLock;global sweep;%ɨƵ����
global closeflag openflag prbsflag sinesweepflag
global maghannrate w
clc
if sweep==0%����ɨƵ
    folder_name = uigetdir('ѡ��SineSweep�����ļ���');
    if folder_name~=0
        axes(handles.amp) ;
        cla reset
        axes(handles.phase) ;
        cla reset
        set(handles.paint,'Visible','off');
        set(handles.amp,'Visible','off');
        set(handles.phase,'Visible','off');
        
        set(handles.calculating,'string',sprintf('���ڴ���...'));
        %����ԭʼ����
        %-------------------------------------------------------------------------%
        fs=4000;%����Ƶ��
        N=4000;%��������
        dt=1/fs;
        %         n=2^nextpow2(N);
        set_df=fs/N;%����Ƶ�ʷֱ���
        
        cd(folder_name);
        Allname=struct2cell(dir); %�õ������ļ����µ������ļ���
        %dir������Եõ�·���ڰ����ļ������ڵ��ļ���Ϣ��Ϊstruc���ݽṹ��
        %-------------------------------------------------------------------------%
        %��������ļ�
        [m,n]=size(Allname);
        mag_rate=zeros(1,n-2);
        phase_diff=zeros(1,n-2);
        rowx=1;
        rowy=2;
        for i=3:n%ǰ���������ļ���,3:n
            name=Allname{1,i};
            %-----------�����������з���������ź�Ƶ�ʺͷ���--------------%
            remainder=name;
            parsed='';
            for chopped_i=1:8
                [chopped,remainder]=strtok(remainder,'_');%����_���
                parsed = strvcat(parsed, chopped);
            end
            if i==3
                %%%%%%%%%%%%%�жϿ��ջ�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                cc=parsed(2,:);
                cc(find(isspace(cc))) = []; %ȥ�����пո�
                if strcmp(cc,'RefPos')==1
                    closeflag=1;%�ջ�
                    openflag=0;
                else
                    if strcmp(cc,'DAC')==1
                        openflag=1;%����
                        closeflag=0;
                    else
                        open('sineSweepGui_sub.fig');
                        set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
                        return;
                    end
                end
                %%%%%%%%%%%�ж�ɨƵ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                cc=parsed(4,:);
                cc(find(isspace(cc))) = []; %ȥ�����пո�
                
                if strcmp(cc,'SweepSine')==1
                    sinesweepflag=1;%sine
                else
                    sinesweepflag=0;
                    open('sineSweepGui_sub.fig');
                    set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
                    return;
                end
            end
            if (loopLock==1&&openflag==1)||(loopLock==0&&openflag==0)
                open('sineSweepGui_sub.fig');
                set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
                return;
            end
            
            if sinesweepflag&&(openflag||closeflag)
                str_f=parsed(5,:);
                str_m=parsed(7,:);
                str_f=str_f(regexp(str_f,'\d'));
                str_m=str_m(regexp(str_m,'\d'));
                num_f(i-2)=str2num(str_f);%Ƶ��
                num_mag(i-2)=str2num(str_m);%����
                
                real_f(i-2)=num_f(i-2);
                f_num=num_f(i-2)+1;%�����ź�Ƶ�ʶ�Ӧ��FFT�����е�λ��
                %----------------------------------------------------------%
                data=importdata(name);
                %---�ж�˭������ ����һ����0��ʼ�������������0��ʼ�������ȵ���0��------------------------%
                input_row=1;output_row=2;
                %                 ini=1;injudge=1;
                
                xt1=data(:,input_row);ct1=data(:,output_row);
                teinput=xt1(1:20);teouput=ct1(1:20);
                
                if std(teinput,0)<std(teouput,0)
                    temp=xt1;
                    xt1=ct1;
                    ct1=temp;
                end

                xt1_len=length(xt1);
                xt1_len_half=1900;%ceil(xt1_len/2);
                if loopLock==1&&closeflag==1%�ջ�����
                    %�������ݳ���ȡһ����������
                    if xt1_len<2*N
                        xt1_i=1;
                        while xt1(xt1_i)==0
                            xt1_i=xt1_i+1;
                        end
                        xt=xt1(xt1_i:xt1_i+N-1);
                        ct=ct1(xt1_i:xt1_i+N-1);
                        go=1;
                    else
                        xt=xt1(xt1_len_half:xt1_len_half+N-1);
                        ct=ct1(xt1_len_half:xt1_len_half+N-1);
                        go=1;
                    end
                else
                    if loopLock==0&&openflag==1%��������
                        if xt1_len>2*N
                            xt=xt1(xt1_len_half:xt1_len_half+N-1);
                            ct=ct1(xt1_len_half:xt1_len_half+N);
                            go=1;
                        else
                            xt1_i=1;
                            while xt1(xt1_i)==0
                                xt1_i=xt1_i+1;
                            end
                            xt=xt1(xt1_i:xt1_i+N-1);
                            ct=ct1(xt1_i:xt1_i+N);
                        end
                        diffct=diff(ct)/dt;
                        ct=[0;diffct];
                        go=1;
                    end
                    
                end
                if go==1
                    
                    cthannfftc=fft(ct);
                    cthannfftmag(i-2)=abs(cthannfftc(f_num));
                    
                    cthannx=xt;%winhann.*
                    cthannfftx=fft(cthannx);
                    cthannfftmagx(i-2)=abs(cthannfftx(f_num));
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    maghannrate(i-2)=cthannfftmag(i-2)/cthannfftmagx(i-2);%��ֵ��
                    phase_diff(i-2)=(angle(cthannfftc(f_num))-angle(cthannfftx(f_num)))*180/pi;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if phase_diff(i-2)>0
                        phase_diff(i-2)=phase_diff(i-2)-360;
                    end
                end
            else
                open('sineSweepGui_sub.fig');
                set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
                return;
            end
            if i==n
                startplot=1;
            end
        end
    else
        set(handles.calculating,'string',sprintf('             '));
        return;
        
    end
    if startplot==1
        axes(handles.paint) ;
        cla reset
        % linkaxes (ax,'xy')
        pp=0;ppp=0;
        [w,iw]=sort(real_f);%iw���������ھ������е�λ��
        phase_diff=phase_diff(iw);
        maghannrate=maghannrate(iw);
        magrate=maghannrate;
        maghannrate=20*log10(maghannrate);
        for ip=1:length(iw)
            if ppp==1
                phase_diff(ip)=phase_diff(ip)-360;
            end
            if ip>2
                if pp==0&&phase_diff(ip-1)+360<50&&phase_diff(ip)>-50
                    phase_diff(ip)=phase_diff(ip)-360;%ִֻ��һ��
                    ppp=1;
                    pp=1;
                end
            end
        end
        %         for ip=1:length(iw)-5
        %             [sm,sn]=min(phase_diff(ip:ip+5));
        %             if abs(sm-mean(phase_diff(ip:ip+5)))>50
        %                 phase_diff(ip+sn)=2*phase_diff(ip+sn-1)-phase_diff(ip+sn-2);
        %             end
        %         end
        %         G20lg=20*log10(mag_rate);%bodeͼ��ֵ
        
        %         semilogx(w,maghannrate);%,'Parent',handles.amp);
        %         ylabel('Amplitude(dB)')%,'Parent',handles.amp);
        %         title('Bode Diagram')%,'Parent',handles.amp);
        %         grid on;
        set(handles.amp,'Visible','on') ;
        set(handles.phase,'Visible','on');
        set(handles.paint,'Visible','off');
        axes(handles.paint);
        plot(0,0);
        set(handles.paint,'Visible','off');
        axes(handles.amp);
        
        semilogx(w,maghannrate);%,'Parent',handles.amp);
        zoom on;
        ylabel('Amplitude(dB)')%,'Parent',handles.amp);
        title('Bode Diagram')%,'Parent',handles.amp);
        grid on;
        
        axes(handles.phase);
        
        semilogx(w,phase_diff(1:length(w)));%,'Parent',handles.phase);
        zoom on;
        ylabel('Phase(deg)','Parent',handles.phase);
        xlabel('Frequency(Hz)','Parent',handles.phase);
        grid on;
        
        
        filename=0;
        cd('..'); % ������һ��·����
        if loopLock==1
            [filename,pathname] = uiputfile({'*.xls','excel(*.xls)'}, '��������','�ջ�����ɨƵ');
        else
            [filename,pathname] = uiputfile({'*.xls','excel(*.xls)'}, '��������','��������ɨƵ');
        end
        if filename==0
            %             return
            donothing=1;
        else
            result(:,1)=w;
            result(:,2)=magrate;
            result(:,3)=phase_diff;
            xlswrite(fullfile(pathname,filename),result);
        end
        
        
        set(handles.calculating,'string',sprintf('������ɣ�'));
    end
    %     cd('..'); % ������һ��·����
    folder_name=0;
else%PRBS
    filename=0;
    [filename, pathname] = uigetfile('*.txt','ѡ��PRBS�����ļ�');
    if isequal(filename,0)
        return;
    else
        cla reset
        axes(handles.paint) ;
        remainder=filename;
        parsed='';
        for chopped_i=1:8
            [chopped,remainder]=strtok(remainder,'_');%����_���
            parsed = strvcat(parsed, chopped);
        end
        %%%%%%%%%%%%%�жϿ��ջ�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cc=parsed(2,:);
        cc(find(isspace(cc))) = []; %ȥ�����пո�
        if strcmp(cc,'RefPos')==1
            closeflag=1;%�ջ�
            openflag=0;
        else
            if strcmp(cc,'DAC')==1
                openflag=1;%����
                closeflag=0;
            else
                open('sineSweepGui_sub.fig');
                set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
                return;
            end
        end
        %%%%%%%%%%%�ж�ɨƵ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cc=parsed(4,:);
        cc(find(isspace(cc))) = []; %ȥ�����пո�
        
        if strcmp(cc,'Prbs')==1
            prbsflag=1;%sine
        else
            prbsflag=0;
            open('sineSweepGui_sub.fig');
            set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
            return;
        end
        if prbsflag==1
            set(handles.calculating,'string',sprintf('���ڴ���...'));
            cd(pathname);
            data=load(filename);
            fs=4000;%����Ƶ��4000hz
            dt=1/fs;%���ݲɼ�ʱ���m������λ����������ͬ
            TN=2^17-1;
            N=4000;
            %---�ж�˭������ ����һ����0��ʼ�������������0��ʼ�������ȵ���0��------------------------%
            input_row=1;output_row=2;
            %             ini=1;injudge=1;
            M1=data(:,input_row);z1=data(:,output_row);
            testin=abs(M1(15:30));
            testout=abs(z1(15:30));
            if std(testin,0)>std(testout,0)
                temp=M1;
                M1=z1;
                z1=temp;
            end
            
            
            %             if injudge==1&&M1(ini)~=0
            %                 mt=M1;
            %                 M1=z1;
            %                 z1=mt;
            %                 injudge=0;
            %             end
            %             if injudge==1
            %                 while M1(ini)==0&&z1(ini)==0
            %                     ini=ini+1;
            %                 end
            %                 if z1(ini)>M1(ini)
            %                     mt=M1;
            %                     M1=z1;
            %                     z1=mt;
            %                 end
            %                 injudge=0;
            %             end
            %-----------------------------------------------------------------------------------%
            
            mi=1;
            while M1(mi)==0
                mi=mi+1;
            end
            endi=length(M1);
            while M1(endi)==0
                endi=endi-1;
            end
            if closeflag==1
%                 N=endi-mi+1;
               if endi-mi>8192
                  N=8192;
               end
            end
            M=M1(mi:mi+N-1);
            z=z1(mi:mi+N-1);
            if openflag==1%����
                zz=diff(z)*4000;
                z=[0;zz];
            end
            
            
            Mfft=fft(M);
            zfft=fft(z);
            Np=length(M);
            %             f = Fs*(0:(Np/2))/Np;
            Mmag2 = abs(Mfft);
            Mmag1 = Mmag2(2:Np/2+1);%ע��+1
            zmag2 = abs(zfft);
            zmag1 = zmag2(2:Np/2+1);%ע��+1
            magr=zmag1./Mmag1;
            G=20*log10(magr);%bodeͼ��ֵ
            x=[1:Np/2]*(fs/Np);
            x=x';
            %{
            for i=1:20
                y2=polyfit(x,G,i);
                Y=polyval(y2,x);%������Ϻ�����x����ֵ��
                s(i)=sum((Y-G).^2);
            end
            [m,n]=min(s);
            y2=polyfit(x,G,n);
            Y=polyval(y2,x);%������Ϻ�����x����ֵ��
            %}
            
            %             plot(x,Y,'Parent',handles.paint);
            %             hold on;
            axes(handles.amp);
            plot(0,0);
            axes(handles.phase);
            plot(0,0);
            axes(handles.paint);
            semilogx(x,G,'Parent',handles.paint);
            zoom on;grid on;
            set(handles.amp,'Visible','off') ;
            set(handles.phase,'Visible','off');
            set(handles.paint,'Visible','on');
            xlabel('Frequency(Hz)');
            ylabel('Amplitude(dB)');
            title('��Ƶͼ');
            hold off;
            filename=0;
            if openflag==0
                [filename,pathname] = uiputfile({'*.xls','excel(*.xls)'}, '��������','�ջ�Prbs');
            else
                [filename,pathname] = uiputfile({'*.xls','excel(*.xls)'}, '��������','����Prbs');
            end
            if filename==0
                %             return
                donothing=1;
            else
                result(:,1)=x;
                result(:,2)=magr;
                xlswrite(fullfile(pathname,filename),result);
            end
            set(handles.calculating,'string',sprintf('������ɣ�'));
            %%%%%%%%%%%%%%����a=1,P=6��M����%%%%%%%%%%%%%%%%%
            %{
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
u=u-mean(u);
%%%%%%%%%%%%%%%���ɸ�˹������%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%�����������%%%%%%%%%%%%%%%%%%%%%%
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
            %}
            
            %     %%%%%%%%%%%%%%%%%%���㻥��غ���%%%%%%%%%%%%%%%%%%
            %     r=1;
            %     for k=1:Np
            %         R(k)=0;
            %         for i=(Np+1):(r+1)*Np
            %             R(k)=R(k)+M(i-k)*z(i);
            %         end
            %         Rmz(k)=R(k)/(r*Np);
            %     end
            %     %%%%%%%%%%%%%%%%%%������Ӧ����ֵ%%%%%%%%%%%%%%%%%%
            %     for k=1:Np
            %         g(k)=(Rmz(k)-Rmz(Np-1))*Np/(Np+1)/(a*a)/dt;
            %     end
            %{
  %%%%%%%%%%%һ������㷨%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for zi=1:Np
        Zp(zi)=z(Np+zi-1);
    end
    Zp=Zp';
    for mi=1:Np
        for mj=1:Np
            Mp(mi,mj)=M(Np-mi+mj);
        end
    end
    g1=1/((Np+1)*a*a*dt)*(ones(Np)+eye(Np))*Mp*Zp;
    for gi=1:Np-1
        g1(gi)=g1(gi+1);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     plot(g,'Parent',handles.paint);
%     hold on;
    plot(g1,'Parent',handles.paint);
%     set(h,maker,'ko');
%     hold on;
%     plot(1:Np,g0,'g+','Parent',handles.paint);
    grid on;
    title('������Ӧ��������');
    
            %}
        else
            open('sineSweepGui_sub.fig');
            set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
            return;
        end
    end
    cd('..'); % ������һ��·����
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
clear global;%���ȫ�ֱ���
delete(hObject);%�رյ�ǰ����


% --- Executes on selection change in selectLoop.
function selectLoop_Callback(hObject, eventdata, handles)
% hObject    handle to selectLoop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectLoop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectLoop
global loopLock sweep
sel=get(hObject,'value');
switch sel
    case 1
        loopLock=0;
        
        %         set(handles.paint,'Visible','off') ;
        %         set(handles.amp,'Visible','on') ;
        %         set(handles.phase,'Visible','on') ;
    case 2
        loopLock=1;
        %         set(handles.paint,'Visible','on') ;
        %         set(handles.amp,'Visible','off') ;
        %         set(handles.phase,'Visible','off') ;
end

% --- Executes during object creation, after setting all properties.
function selectLoop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectLoop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_pic.
function save_pic_Callback(hObject, eventdata, handles)
% hObject    handle to save_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [fname pname]=uiputfile({'*.jpg'},'����ͼ��');
% str=[pname fname];
% pix=getframe(handles.paint);
% imwrite(pix.cdata,str,'jpg');
% [filename,pathname,filespec]=uiputfile({'*.jpg';'*.png';'*.gif'},'����ͼ��');
%
% if filename==0
%
%     return
%
% else
%
%    hnewfig=figure;
%
%     axes2=copyobj(handles.paint,hnewfig);
%
%     set(axes2,'units','default','position','default');      %ע�⣬һ��Ҫ������unit����������position��������������ľ��ǿհ�ͼƬ
%
%     saveas(hnewfig,fullfile(pathname,filename));
%
%     delete(hnewfig)
%
% end
[filename,pathname,filespec]=uiputfile({'*.jpg';'*.png';'*.gif'},'Save Image');

if filename==0
    
    return
    
else
    
    saveas(handles.paint,fullfile(pathname,filename));
    
end


% --- Executes on mouse press over axes background.
function paint_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to paint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(gcf,'WindowButtonDownFcn',@ButttonDownFcn);
% pt = get(gca,'CurrentPoint','Parent',handles.paint);
% x = pt(1,1);
% y = pt(1,2);
% fprintf('x=%f,y=%fn',x,y);



% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% p=get(gca,'CurrentPoint') ;%��þ��
% msgstr = sprintf('x = %3.3f; y = %3.3f',p(1),p(2)); %���λ��
% xianshi= uicontrol('style','text','position',[100 100 100 20],'string',msgstr);


% --- Executes on selection change in selectSweep.
function selectSweep_Callback(hObject, eventdata, handles)
% hObject    handle to selectSweep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectSweep contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectSweep
global sweep;
sel=get(hObject,'value');
switch sel
    case 1
        sweep=0;%����
        set(handles.dataKind,'Visible','on') ;
        set(handles.selectLoop,'Visible','on') ;
    case 2
        sweep=1;%PRBS
        set(handles.dataKind,'Visible','off') ;
        set(handles.selectLoop,'Visible','off') ;
end

% --- Executes during object creation, after setting all properties.
function selectSweep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectSweep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in comp.
function comp_Callback(hObject, eventdata, handles)
% hObject    handle to comp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of comp
global kindscomp openflag
val=get(hObject,'value');
if val==1
    kindscomp=1;
else
    kindscomp=0;
end
if kindscomp==1
    
    
    filename=0;
    [filename, pathname] = uigetfile('*.txt','ѡ��PRBS�����ļ�');
    if isequal(filename,0)
        return;
    else
        cla reset
        axes(handles.paint) ;
        remainder=filename;
        parsed='';
        for chopped_i=1:8
            [chopped,remainder]=strtok(remainder,'_');%����_���
            parsed = strvcat(parsed, chopped);
        end
         %%%%%%%%%%%%%�жϿ��ջ�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cc=parsed(2,:);
        openflag=2;
        closeflag=2;
        cc(find(isspace(cc))) = []; %ȥ�����пո�
        if strcmp(cc,'RefPos')==1
            closeflag=1;%�ջ�
            openflag=0;
        else
            if strcmp(cc,'DAC')==1
                openflag=1;%����
                closeflag=0;
            else
                open('sineSweepGui_sub.fig');
                set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
                return;
            end
        end
        %%%%%%%%%%%�ж�ɨƵ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cc=parsed(4,:);
        cc(find(isspace(cc))) = []; %ȥ�����пո�
        
        if strcmp(cc,'Prbs')==1
            prbsflag=1;%sine
        else
            prbsflag=0;
            open('sineSweepGui_sub.fig');
            set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
            return;
        end
        if prbsflag==1
            set(handles.calculating,'string',sprintf('���ڴ���...'));
            cd(pathname);
            data=load(filename);
            fs=4000;%����Ƶ��4000hz
            dt=1/fs;%���ݲɼ�ʱ���m������λ����������ͬ
            TN=2^17-1;
            N=4000;
            %---�ж�˭������ ����һ����0��ʼ�������������0��ʼ�������ȵ���0��------------------------%
            input_row=1;output_row=2;
            %             ini=1;injudge=1;
            M1=data(:,input_row);z1=data(:,output_row);
            testin=abs(M1(15:30));
            testout=abs(z1(15:30));
            if std(testin,0)>std(testout,0)
                temp=M1;
                M1=z1;
                z1=temp;
            end
            mi=1;
            while M1(mi)==0
                mi=mi+1;
            end
            endi=length(M1);
            while M1(endi)==0
                endi=endi-1;
            end
            if closeflag==1
%                 N=endi-mi+1;
               if endi-mi>8192
                  N=8192;
               end
            end
                
            M=M1(mi:mi+N-1);
            z=z1(mi:mi+N-1);
            if openflag==1%����
                zz=diff(z)*4000;
                z=[0;zz];
            end
            
            
            Mfft=fft(M);
            zfft=fft(z);
            Np=length(M);
            %             f = Fs*(0:(Np/2))/Np;
            Mmag2 = abs(Mfft);
            Mmag1 = Mmag2(2:Np/2+1);%ע��+1
            zmag2 = abs(zfft);
            zmag1 = zmag2(2:Np/2+1);%ע��+1
            magr=zmag1./Mmag1;
            G=20*log10(magr);%bodeͼ��ֵ
            x=[1:Np/2]*(fs/Np);
            x=x';
            
            axes(handles.amp);
            plot(0,0);
            axes(handles.phase);
            plot(0,0);
            axes(handles.paint);
            semilogx(x,G,'Parent',handles.paint);
            zoom on;grid on;hold on;
            set(handles.amp,'Visible','off') ;
            set(handles.phase,'Visible','off');
            set(handles.paint,'Visible','on');
            xlabel('Frequency(Hz)');
            ylabel('Amplitude(dB)');
            title('��Ƶ�Ա�ͼ');
        else
            open('sineSweepGui_sub.fig');
            set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
            return;
        end
    end
    cd('..'); % ������һ��·����
    
    
    
    folder_name = uigetdir('ѡ��SineSweep�����ļ���');
    if folder_name~=0
        
        
        set(handles.calculating,'string',sprintf('���ڴ���...'));
        %����ԭʼ����
        %-------------------------------------------------------------------------%
        fs=4000;%����Ƶ��
        N=4000;%��������
        dt=1/fs;
        %         n=2^nextpow2(N);
        set_df=fs/N;%����Ƶ�ʷֱ���
        
        %-------------------------------------------------------------------------%
        
        cd(folder_name);
        Allname=struct2cell(dir); %�õ������ļ����µ������ļ���
        %dir������Եõ�·���ڰ����ļ������ڵ��ļ���Ϣ��Ϊstruc���ݽṹ��
        %-------------------------------------------------------------------------%
        %��������ļ�
        [m,n]=size(Allname);
        mag_rate=zeros(1,n-2);
        phase_diff=zeros(1,n-2);
        
        for i=3:n%ǰ���������ļ���,3:n
            
            name=Allname{1,i};
            %-----------�����������з���������ź�Ƶ�ʺͷ���--------------%
            remainder=name;
            parsed='';
            for chopped_i=1:8
                [chopped,remainder]=strtok(remainder,'_');%����_���
                parsed = strvcat(parsed, chopped);
            end
            if i==3
                %%%%%%%%%%%%%�жϿ��ջ�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                cc=parsed(2,:);
                cc(find(isspace(cc))) = []; %ȥ�����пո�
                if strcmp(cc,'RefPos')==1
                    closeflag=1;%�ջ�
                    openflag=0;
                else
                    if strcmp(cc,'DAC')==1
                        openflag=1;%����
                        closeflag=0;
                    else
                        open('sineSweepGui_sub.fig');
                        set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
                        return;
                    end
                end
                %%%%%%%%%%%�ж�ɨƵ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                cc=parsed(4,:);
                cc(find(isspace(cc))) = []; %ȥ�����пո�
                
                if strcmp(cc,'SweepSine')==1
                    sinesweepflag=1;%sine
                else
                    sinesweepflag=0;
                    open('sineSweepGui_sub.fig');
                    set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
                    return;
                end
            end
            
            
            if sinesweepflag&&(openflag||closeflag)
                str_f=parsed(5,:);
                str_m=parsed(7,:);
                str_f=str_f(regexp(str_f,'\d'));
                str_m=str_m(regexp(str_m,'\d'));
                num_f(i-2)=str2num(str_f);%Ƶ��
                num_mag(i-2)=str2num(str_m);%����
                
                real_f(i-2)=num_f(i-2);
                f_num=num_f(i-2)+1;%�����ź�Ƶ�ʶ�Ӧ��FFT�����е�λ��
                %----------------------------------------------------------%
                data=importdata(name);
                %---�ж�˭������ ����һ����0��ʼ�������������0��ʼ�������ȵ���0��------------------------%
                input_row=1;output_row=2;
                %                 ini=1;injudge=1;
                
                xt1=data(:,input_row);ct1=data(:,output_row);
                teinput=xt1(1:20);teouput=ct1(1:20);
                
                if std(teinput,0)<std(teouput,0)
                    temp=xt1;
                    xt1=ct1;
                    ct1=temp;
                end
                
                xt1_len=length(xt1);
                xt1_len_half=1900;%ceil(xt1_len/2);
                if closeflag==1%�ջ�����
                    %�������ݳ���ȡһ����������
                    if xt1_len<2*N
                        xt1_i=1;
                        while xt1(xt1_i)==0
                            xt1_i=xt1_i+1;
                        end
                        xt=xt1(xt1_i:xt1_i+N-1);
                        ct=ct1(xt1_i:xt1_i+N-1);
                        go=1;
                    else
                        xt=xt1(xt1_len_half:xt1_len_half+N-1);
                        ct=ct1(xt1_len_half:xt1_len_half+N-1);
                        go=1;
                    end
                else
                    if openflag==1%��������
                        if xt1_len>2*N
                            xt=xt1(xt1_len_half:xt1_len_half+N-1);
                            ct=ct1(xt1_len_half:xt1_len_half+N);
                            go=1;
                        else
                            xt1_i=1;
                            while xt1(xt1_i)==0
                                xt1_i=xt1_i+1;
                            end
                            xt=xt1(xt1_i:xt1_i+N-1);
                            ct=ct1(xt1_i:xt1_i+N);
                        end
                        diffct=diff(ct)/dt;
                        ct=[0;diffct];
                        go=1;
                    end
                    
                end
                if go==1
                    
                    cthannfftc=fft(ct);
                    cthannfftmag(i-2)=abs(cthannfftc(f_num));
                    
                    cthannx=xt;%winhann.*
                    cthannfftx=fft(cthannx);
                    cthannfftmagx(i-2)=abs(cthannfftx(f_num));
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    maghannrate(i-2)=cthannfftmag(i-2)/cthannfftmagx(i-2);%��ֵ��
                end
            else
                open('sineSweepGui_sub.fig');
                set(handles.calculating,'string',sprintf('��ע���ļ����ͣ�'));
                return;
            end
            if i==n
                startplot=1;
            end
        end
    else
        set(handles.calculating,'string',sprintf('             '));
        return;
        
    end
    if startplot==1
        axes(handles.paint) ;
        [w,iw]=sort(real_f);%iw���������ھ������е�λ��
        maghannrate=maghannrate(iw);
        magrate=maghannrate;
        maghannrate=20*log10(maghannrate);
        
        semilogx(w,maghannrate);%,'Parent',handles.amp);
        
        grid on;zoom on;
    end
        set(handles.calculating,'string',sprintf('������ɣ�'));
end


% --- Executes during object creation, after setting all properties.
function calculating_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calculating (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
