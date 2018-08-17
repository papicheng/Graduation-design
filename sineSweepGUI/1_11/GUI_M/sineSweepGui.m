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

% Last Modified by GUIDE v2.5 07-Jan-2018 15:35:24

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
% axes('Parent',handles.paint,f,...                   %创建坐标轴
%    'position',[0.06 0.55 0.3 0.17],...
%    'visible','on');
% axes2 = axes('Parent',handles.paint,f,...                   %创建坐标轴
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
% [fname,pname,index]=uigetfile('*.txt','选择数据文件');
% if index
%     str=[pname fname];

a = findobj(handles.comp,'style','checkbox')
set(a,'Value',0)

go=0;startplot=0;
set(handles.calculating,'string',sprintf('正在处理...'));
global folder_name;global loopLock;global sweep;%扫频类型
global closeflag openflag prbsflag sinesweepflag
global maghannrate w
clc
if sweep==0%正弦扫频
    folder_name = uigetdir('选择SineSweep数据文件夹');
    if folder_name~=0
        axes(handles.amp) ;
        cla reset
        axes(handles.phase) ;
        cla reset
        set(handles.paint,'Visible','off');
        set(handles.amp,'Visible','off');
        set(handles.phase,'Visible','off');
        hbar=waitbar(0,'请等待>>>>>>>>');
        set(handles.calculating,'string',sprintf('正在处理...'));
        %导入原始数据
        %-------------------------------------------------------------------------%
        fs=4000;%采样频率
        N=4000;%采样点数
        dt=1/fs;
        %         n=2^nextpow2(N);
        set_df=fs/N;%设置频率分辨率
        
        cd(folder_name);
        Allname=struct2cell(dir); %得到上述文件夹下的所有文件名
        %dir命令，可以得到路径内包括文件名在内的文件信息，为struc数据结构。
        %-------------------------------------------------------------------------%
        %逐个读入文件
        [m,n]=size(Allname);
        mag_rate=zeros(1,n-2);
        phase_diff=zeros(1,n-2);
        for i=3:n%前两个不是文件名,3:n
            name=Allname{1,i};
            %-----------从数据名称中分离出输入信号频率和幅度--------------%
            remainder=name;
            parsed='';
            for chopped_i=1:8
                [chopped,remainder]=strtok(remainder,'_');%根据_拆分
                parsed = strvcat(parsed, chopped);
            end
            if i==3
               
                aa=parsed(1,:);
                aa(find(isspace(aa))) = []; %去除所有空格
                bb=parsed(2,:);
                bb(find(isspace(bb))) = []; %去除所有空格
                cc=parsed(3,:);
                cc(find(isspace(cc))) = []; %去除所有空格
                dd=parsed(4,:);
                dd(find(isspace(dd))) = []; %去除所有空格
                savename=[aa,'_',bb,'_',cc,'_',dd,'_'];
                %%%%%%%%%%%%%判断开闭环%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if strcmp(bb,'DAC')==1
                    openflag=1;%开环
                    closeflag=0;
                else
                    openflag=0;%闭环
                    closeflag=1;
                end
                
                %%%%%%%%%%%判断扫频类型%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if strcmp(dd,'SweepSine')==1
                    sinesweepflag=1;%sine
                else
                    sinesweepflag=0;
                    open('sineSweepGui_sub.fig');
                    set(handles.calculating,'string',sprintf('请注意文件类型！'));
                    return;
                end
            end
%             if (loopLock==1&&openflag==1)||(loopLock==0&&openflag==0)
%                 open('sineSweepGui_sub.fig');
%                 set(handles.calculating,'string',sprintf('请注意文件类型！'));
%                 return;
%             end
            
            if sinesweepflag&&(openflag||closeflag)
                str_f=parsed(5,:);
                str_m=parsed(7,:);
                str_f=str_f(regexp(str_f,'\d'));
                str_m=str_m(regexp(str_m,'\d'));
                num_f(i-2)=str2num(str_f);%频率
                num_mag(i-2)=str2num(str_m);%幅度
                
                real_f(i-2)=num_f(i-2);
                frealshow(i-2)=num_f(i-2);
                f_num(i-2)=num_f(i-2)+1;%输入信号频率对应于FFT后序列的位置
                %----------------------------------------------------------%
                data=importdata(name);
                %---判断谁是输入 ------------------------%
                input_row=1;output_row=2;
                xt1=data(:,input_row);ct1=data(:,output_row);
                teinput=xt1(1:20);teouput=ct1(1:20);
                stdx=std(teinput,0);
                stdc=std(teouput,0);
                if stdx<stdc
                    temp=xt1;
                    xt1=ct1;
                    ct1=temp;
                end
                %-------------------------------------------------------------------%
                
                xt1len=length(xt1);
                si=1;jump=0;
                if max(xt1)==0||max(ct1)==0
                    jump=1;%判断是否有有效数据，否则该频率点无效，重复上一个频率点
                end
                
                while xt1(si)==0&&jump==0
                    si=si+1;
                    if si>=xt1len-1
                        jump=1;
                    end
                end
                if jump==0
                    si=si-1;
                    xend=length(xt1);
                    while xt1(xend)==0
                        xend=xend-1;
                    end
                    xt1long=xend-si+1;
                    if xt1long>=4000
                        starti=xend-4000+1;
                        xt=xt1(starti:starti+3999);
                        ct=ct1(starti:starti+3999);
                    end
                    if xt1long==3999
                        xt=xt1(si:si+3999);
                        ct=ct1(si:si+3999);
                    end
                    if xt1long<3999
                        xt=xt1(si:xend);
                        ct=ct1(si:xend);
                        xlong=length(xt);
                        dfin=fs/xlong;
                        f_num(i-2)=round(real_f(i-2)/dfin)+1;
                        frealshow(i-2)=(f_num(i-2)-1)*dfin;
                    end
                    if openflag==1
                        diffct=diff(ct)/dt;
                        ct=[0;diffct];
                    end
                    
                    cthannfftc=fft(ct);
                    cthannfftmag(i-2)=abs(cthannfftc(f_num(i-2)));
                    
                    cthannx=xt;%winhann.*
                    cthannfftx=fft(cthannx);
                    cthannfftmagx(i-2)=abs(cthannfftx(f_num(i-2)));
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    maghannrate(i-2)=cthannfftmag(i-2)/cthannfftmagx(i-2);%幅值比
                    phase_diff(i-2)=(angle(cthannfftc(f_num(i-2)))-angle(cthannfftx(f_num(i-2))))*180/pi;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if phase_diff(i-2)>0
                        phase_diff(i-2)=phase_diff(i-2)-360;
                    end
                end
                if jump==1
                    phase_diff(i-2)=phase_diff(i-3);
                    maghannrate(i-2)=maghannrate(i-3);
                    real_f(i-2)=real_f(i-3);
                    frealshow(i-2)=frealshow(i-3);
                end
            else
                open('sineSweepGui_sub.fig');
                set(handles.calculating,'string',sprintf('请注意文件类型！'));
                return;
            end
            if i==n
                startplot=1;
                pp=0;ppp=0;
        [w,iw]=sort(frealshow);%iw是新序列在旧序列中的位置
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
                    phase_diff(ip)=phase_diff(ip)-360;%只执行一次
                    ppp=1;
                    pp=1;
                end
            end
        end
        stop=1;
        plen=length(phase_diff);
        while stop==1
            for px=2:plen
                phaseabs(px)=abs(phase_diff(px-1)-phase_diff(px));
            end
            if max(phaseabs)<200
                stop=0;
            end
            
            if max(phaseabs)>200
                for px=2:plen
                    if abs(phase_diff(px-1)-phase_diff(px))>200
                        phase_diff(px)=phase_diff(px)-360;
                    end
                end
            end
        end
                
                
                
            end
            sjingdu=i/n*100;
            sjingdu=['正在处理...',num2str(sjingdu),'%'];
             waitbar(i/n,hbar,sjingdu);%------------------------------------------------
        end
    else
        set(handles.calculating,'string',sprintf('             '));
        return;
        
    end
    if startplot==1
        axes(handles.paint) ;
        cla reset
        % linkaxes (ax,'xy')
        
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
        tit=strrep(savename,'_',' ');
        tit=[tit,' Bode Diagram'];
        title(tit);%,'Parent',handles.amp);
        grid on;
        
        axes(handles.phase);
        
        semilogx(w,phase_diff(1:length(w)));%,'Parent',handles.phase);
        zoom on;
        ylabel('Phase(deg)','Parent',handles.phase);
        xlabel('Frequency(Hz)','Parent',handles.phase);
        grid on;
        close(hbar);

        
        filename=0;
        cd('..'); % 跳到上一级路径下
        %------------------------------------------------------------------------------
        result(:,1)=w;
        result(:,2)=magrate;
        result(:,3)=phase_diff;
        a=datestr(now,0);
        a=strrep(a,'-','_');
        a=strrep(a,' ','_');
        a=strrep(a,':','_');
        filename=[savename,a,'.xlsx'];
        xlswrite(filename,result);
        
        set(handles.calculating,'string',sprintf('处理完成！'));
    end
    %     cd('..'); % 跳到上一级路径下
    folder_name=0;
else%PRBS
    filename=0;
    [filename, pathname] = uigetfile('*.txt','选择PRBS数据文件');
    if isequal(filename,0)
        return;
    else
        cla reset
        axes(handles.paint) ;
        remainder=filename;
        parsed='';
        for chopped_i=1:8
            [chopped,remainder]=strtok(remainder,'_');%根据_拆分
            parsed = strvcat(parsed, chopped);
        end
        %%%%%%%%%%%%%判断开闭环%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cc=parsed(2,:);
        cc(find(isspace(cc))) = []; %去除所有空格
        if strcmp(cc,'RefPos')==1
            closeflag=1;%闭环
            openflag=0;
        else
            if strcmp(cc,'DAC')==1
                openflag=1;%开环
                closeflag=0;
            else
                open('sineSweepGui_sub.fig');
                set(handles.calculating,'string',sprintf('请注意文件类型！'));
                return;
            end
        end
        %%%%%%%%%%%判断扫频类型%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cc=parsed(4,:);
        cc(find(isspace(cc))) = []; %去除所有空格
        
        if strcmp(cc,'Prbs')==1
            prbsflag=1;%sine
        else
            prbsflag=0;
            open('sineSweepGui_sub.fig');
            set(handles.calculating,'string',sprintf('请注意文件类型！'));
            return;
        end
        if prbsflag==1
            set(handles.calculating,'string',sprintf('正在处理...'));
            cd(pathname);
            data=load(filename);
            fs=4000;%采样频率4000hz
            dt=1/fs;%数据采集时间和m序列移位脉冲周期相同
            TN=2^17-1;
            N=4000;
            %---判断谁是输入 输入一定从0开始，如果两个都从0开始，输入先到非0数------------------------%
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
            if openflag==1%开环
                zz=diff(z)*4000;
                z=[0;zz];
            end
            
            
            Mfft=fft(M);
            zfft=fft(z);
            Np=length(M);
            %             f = Fs*(0:(Np/2))/Np;
            Mmag2 = abs(Mfft);
            Mmag1 = Mmag2(2:Np/2+1);%注意+1
            zmag2 = abs(zfft);
            zmag1 = zmag2(2:Np/2+1);%注意+1
            magr=zmag1./Mmag1;
            G=20*log10(magr);%bode图幅值
            x=[1:Np/2]*(fs/Np);
            x=x';
            
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
            title('幅频图');
            hold off;
            filename=0;
            if openflag==0
                [filename,pathname] = uiputfile({'*.xls','excel(*.xls)'}, '保存数据','闭环Prbs');
            else
                [filename,pathname] = uiputfile({'*.xls','excel(*.xls)'}, '保存数据','开环Prbs');
            end
            if filename==0
                donothing=1;
            else
                result(:,1)=x;
                result(:,2)=magr;
                xlswrite(fullfile(pathname,filename),result);
            end
            set(handles.calculating,'string',sprintf('处理完成！'));
        else
            open('sineSweepGui_sub.fig');
            set(handles.calculating,'string',sprintf('请注意文件类型！'));
            return;
        end
    end
    cd('..'); % 跳到上一级路径下
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
clear global;%清除全局变量
delete(hObject);%关闭当前窗口


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
% [fname pname]=uiputfile({'*.jpg'},'保存图像');
% str=[pname fname];
% pix=getframe(handles.paint);
% imwrite(pix.cdata,str,'jpg');
% [filename,pathname,filespec]=uiputfile({'*.jpg';'*.png';'*.gif'},'保存图像');
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
%     set(axes2,'units','default','position','default');      %注意，一定要先设置unit属性再设置position，若反过来保存的就是空白图片
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
% p=get(gca,'CurrentPoint') ;%获得句柄
% msgstr = sprintf('x = %3.3f; y = %3.3f',p(1),p(2)); %获得位置
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
        sweep=0;%正弦
        set(handles.dataKind,'Visible','on') ;
        set(handles.selectLoop,'Visible','on') ;
    case 2
        sweep=1;%PRBS
        set(handles.dataKind,'Visible','off') ;
        set(handles.selectLoop,'Visible','off') ;
end

% mywaitbar(0,'Please Wait...',handles.figure1);
% TheEndTime = 600; 
% for t = 1:TheEndTime
%        mywaitbar(t/TheEndTime,[num2str(floor(t*100/TheEndTime)),'%'],handles.figure1);
% end

% mywaitbar2(100,50,50);
% mywaitbar3(0,'Please Wait...');
% TheEndTime = 600; 
% for t = 1:TheEndTime
%        mywaitbar(t/TheEndTime,[num2str(floor(t*100/TheEndTime)),'%']);
% end


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
    [filename, pathname] = uigetfile('*.txt','选择PRBS数据文件');
    if isequal(filename,0)
        return;
    else
        cla reset
        axes(handles.paint) ;
        remainder=filename;
        parsed='';
        for chopped_i=1:8
            [chopped,remainder]=strtok(remainder,'_');%根据_拆分
            parsed = strvcat(parsed, chopped);
        end
        %%%%%%%%%%%%%判断开闭环%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cc=parsed(2,:);
        openflag=2;
        closeflag=2;
        cc(find(isspace(cc))) = []; %去除所有空格
        if strcmp(cc,'RefPos')==1
            closeflag=1;%闭环
            openflag=0;
        else
            if strcmp(cc,'DAC')==1
                openflag=1;%开环
                closeflag=0;
            else
                open('sineSweepGui_sub.fig');
                set(handles.calculating,'string',sprintf('请注意文件类型！'));
                return;
            end
        end
        %%%%%%%%%%%判断扫频类型%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cc=parsed(4,:);
        cc(find(isspace(cc))) = []; %去除所有空格
        
        if strcmp(cc,'Prbs')==1
            prbsflag=1;%sine
        else
            prbsflag=0;
            open('sineSweepGui_sub.fig');
            set(handles.calculating,'string',sprintf('请注意文件类型！'));
            return;
        end
        if prbsflag==1
            set(handles.calculating,'string',sprintf('正在处理...'));
            cd(pathname);
            data=load(filename);
            fs=4000;%采样频率4000hz
            dt=1/fs;%数据采集时间和m序列移位脉冲周期相同
            TN=2^17-1;
            N=4000;
            %---判断谁是输入 输入一定从0开始，如果两个都从0开始，输入先到非0数------------------------%
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
            if openflag==1%开环
                zz=diff(z)*4000;
                z=[0;zz];
            end
            
            
            Mfft=fft(M);
            zfft=fft(z);
            Np=length(M);
            %             f = Fs*(0:(Np/2))/Np;
            Mmag2 = abs(Mfft);
            Mmag1 = Mmag2(2:Np/2+1);%注意+1
            zmag2 = abs(zfft);
            zmag1 = zmag2(2:Np/2+1);%注意+1
            magr=zmag1./Mmag1;
            G=20*log10(magr);%bode图幅值
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
            title('幅频对比图');
        else
            open('sineSweepGui_sub.fig');
            set(handles.calculating,'string',sprintf('请注意文件类型！'));
            return;
        end
    end
    cd('..'); % 跳到上一级路径下
    
    
    
    folder_name = uigetdir('选择SineSweep数据文件夹');
    if folder_name~=0
        
        
        set(handles.calculating,'string',sprintf('正在处理...'));
        %导入原始数据
        %-------------------------------------------------------------------------%
        fs=4000;%采样频率
        N=4000;%采样点数
        dt=1/fs;
        %         n=2^nextpow2(N);
        set_df=fs/N;%设置频率分辨率
        
        %-------------------------------------------------------------------------%
        
        cd(folder_name);
        Allname=struct2cell(dir); %得到上述文件夹下的所有文件名
        %dir命令，可以得到路径内包括文件名在内的文件信息，为struc数据结构。
        %-------------------------------------------------------------------------%
        %逐个读入文件
        [m,n]=size(Allname);
        mag_rate=zeros(1,n-2);
        phase_diff=zeros(1,n-2);
        
        for i=3:n%前两个不是文件名,3:n
            
            name=Allname{1,i};
            %-----------从数据名称中分离出输入信号频率和幅度--------------%
            remainder=name;
            parsed='';
            for chopped_i=1:8
                [chopped,remainder]=strtok(remainder,'_');%根据_拆分
                parsed = strvcat(parsed, chopped);
            end
            if i==3
                %%%%%%%%%%%%%判断开闭环%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                cc=parsed(2,:);
                cc(find(isspace(cc))) = []; %去除所有空格
                if strcmp(cc,'RefPos')==1
                    closeflag=1;%闭环
                    openflag=0;
                else
                    if strcmp(cc,'DAC')==1
                        openflag=1;%开环
                        closeflag=0;
                    else
                        open('sineSweepGui_sub.fig');
                        set(handles.calculating,'string',sprintf('请注意文件类型！'));
                        return;
                    end
                end
                %%%%%%%%%%%判断扫频类型%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                cc=parsed(4,:);
                cc(find(isspace(cc))) = []; %去除所有空格
                
                if strcmp(cc,'SweepSine')==1
                    sinesweepflag=1;%sine
                else
                    sinesweepflag=0;
                    open('sineSweepGui_sub.fig');
                    set(handles.calculating,'string',sprintf('请注意文件类型！'));
                    return;
                end
            end
            
            
            if sinesweepflag&&(openflag||closeflag)
                str_f=parsed(5,:);
                str_m=parsed(7,:);
                str_f=str_f(regexp(str_f,'\d'));
                str_m=str_m(regexp(str_m,'\d'));
                num_f(i-2)=str2num(str_f);%频率
                num_mag(i-2)=str2num(str_m);%幅度
                
                real_f(i-2)=num_f(i-2);
                f_num=num_f(i-2)+1;%输入信号频率对应于FFT后序列的位置
                %----------------------------------------------------------%
                data=importdata(name);
                %---判断谁是输入 输入一定从0开始，如果两个都从0开始，输入先到非0数------------------------%
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
                if closeflag==1%闭环数据
                    %根据数据长度取一段数做处理
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
                    if openflag==1%开环数据
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
                    
                    maghannrate(i-2)=cthannfftmag(i-2)/cthannfftmagx(i-2);%幅值比
                end
            else
                open('sineSweepGui_sub.fig');
                set(handles.calculating,'string',sprintf('请注意文件类型！'));
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
        [w,iw]=sort(real_f);%iw是新序列在旧序列中的位置
        maghannrate=maghannrate(iw);
        magrate=maghannrate;
        maghannrate=20*log10(maghannrate);
        
        semilogx(w,maghannrate);%,'Parent',handles.amp);
        
        grid on;zoom on;
    end
    set(handles.calculating,'string',sprintf('处理完成！'));
end

