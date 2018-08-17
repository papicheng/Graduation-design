function varargout = fig3(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fig3_OpeningFcn, ...
                   'gui_OutputFcn',  @fig3_OutputFcn, ...
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


function fig3_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

function varargout = fig3_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)
fs=41000;
x=0:1/fs:1;
handles.y=2*sin(2*pi*handles.f1*x)+3*sin(2*pi*handles.f2*x)+5*sin(2*pi*handles.f3*x);
plot(handles.axes1,x,handles.y);
grid(handles.axes1);
xlabel(handles.axes1,'Time(s)','fontweight','bold');
ylabel(handles.axes1,'Amplitude','fontweight','bold');
N1=41000;
sample=handles.y(1:N1);
sample=double(sample);
f=linspace(0,fs/2,N1/2);
P=2*fft(sample,N1)/N1;
Pyy=sqrt(P.*conj(P));
plot(handles.axes2,f,Pyy(1:N1/2));
xlabel(handles.axes2,'Freqency(Hz)','fontweight','bold');
ylabel(handles.axes2,'Amplitude','fontweight','bold');
grid(handles.axes2);
guidata(hObject,handles);



function pushbutton2_Callback(hObject, eventdata, handles)
Fs=20000;                            %表示为抽样频率
Wp=2*handles.flp/Fs;                 %归一化的通带截止频率
Ws=2*handles.fls/Fs;                 %归一化的阻带截止频率
Rp=0.5;                              %通带最大衰减（单位：dB） 
Rs=30;                               %阻带最小衰减（单位：dB）
[n,wf]=cheb2ord(Wp,Ws,Rp,Rs);
set(findobj('Tag','N'),'String',num2str(n));
N=n-1;
if handles.rb1==1
    switch handles.type
        case 1 
            b=fir1(N,wf,blackman(n));
        case 2
            b=fir1(N,wf,boxcar(n));
        case 3
            b=fir1(N,wf,hamming(n));
        case 4
            b=fir1(N,wf,hanning(n));
        otherwise
            errordlg('Illegal type','Choose errer');%向界面发送错误的对话框
    end
elseif handles.rb2==1
    switch handles.type
        case 1 
            b=fir1(N,wf,'high',blackman(n+1));%滤波器阶数会自动增加了1
        case 2
            b=fir1(N,wf,'high',boxcar(n+1));
        case 3
            b=fir1(N,wf,'high',hamming(n+1));
        case 4
             b=fir1(N,wf,'high',hanning(n+1));
        otherwise
             errordlg('Illegal type','Choose errer');%向界面发送错误的对话框
    end
elseif handles.rb3==1
    switch handles.type
        case 1 
            b=fir1(N,[wf,wf+0.2],blackman(n));
        case 2
            b=fir1(N,[wf,wf+0.2],boxcar(n));
        case 3
            b=fir1(N,[wf,wf+0.2],hamming(n));
        case 4
             b=fir1(N,[wf,wf+0.2],hanning(n));
        otherwise
             errordlg('Illegal type','Choose errer');%向界面发送错误的对话框
    end
else
    switch handles.type
        case 1 
            b=fir1(N,[wf,wf+0.2],'stop',blackman(n+1));%滤波器阶数会自动增加了1
        case 2
            b=fir1(N,[wf,wf+0.2],'stop',boxcar(n+1));
        case 3
            b=fir1(N,[wf,wf+0.2],'stop',hamming(n+1));
        case 4
            b=fir1(N,[wf,wf+0.2],'stop',hanning(n+1));
        otherwise
            errordlg('Illegal type','Choose errer');%向界面发送错误的对话框
    end
end
y=filter(b,1,handles.y);
plot(handles.axes3,y);
grid(handles.axes3); 
xlabel(handles.axes3,'Time(s)','fontweight','bold');
ylabel(handles.axes3,'Amplitude','fontweight','bold');
Fs=5024;
N=1024;
sample=handles.y(1:N);
sample=double(sample);
f=linspace(0,Fs/2,N/2);
P=2*fft(sample,N)/N;
Pyy=sqrt(P.*conj(P));
plot(handles.axes4,f,Pyy(1:N/2));
grid(handles.axes4);
xlabel(handles.axes4,'Freqency(Hz)','fontweight','bold');
ylabel(handles.axes4,'Amplitude','fontweight','bold');
guidata(hObject,handles);









        
            




%频率的输入
function f1_Callback(hObject, eventdata, handles)
handles.f1=str2double(get(findobj('Tag','f1'),'String'));
guidata(hObject,handles);
function f1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f2_Callback(hObject, eventdata, handles)
handles.f2=str2double(get(findobj('Tag','f2'),'String'));
guidata(hObject,handles);
function f2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function f3_Callback(hObject, eventdata, handles)
handles.f3=str2double(get(findobj('Tag','f3'),'String'));
guidata(hObject,handles);
function f3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%选择低通
function rb1_Callback(hObject, eventdata, handles)
set(findobj('Tag','rb1'),'Value',1);
handles.rb1=1;
set(findobj('Tag','rb2'),'Value',0);
handles.rb2=0;
set(findobj('Tag','rb3'),'Value',0);
handles.rb3=0;
set(findobj('Tag','rb4'),'Value',0);
handles.rb4=0;
guidata(hObject,handles);


%选择高通
function rb2_Callback(hObject, eventdata, handles)
set(findobj('Tag','rb1'),'Value',0);
handles.rb1=0;
set(findobj('Tag','rb2'),'Value',1);
handles.rb2=1;
set(findobj('Tag','rb3'),'Value',0);
handles.rb3=0;
set(findobj('Tag','rb4'),'Value',0);
handles.rb4=0;
guidata(hObject,handles);


%选择带通
function rb3_Callback(hObject, eventdata, handles)
set(findobj('Tag','rb1'),'Value',0);
handles.rb1=0;
set(findobj('Tag','rb2'),'Value',0);
handles.rb2=0;
set(findobj('Tag','rb3'),'Value',1);
handles.rb3=1;
set(findobj('Tag','rb4'),'Value',0);
handles.rb4=0;
guidata(hObject,handles);


%选择带阻
function rb4_Callback(hObject, eventdata, handles)
set(findobj('Tag','rb1'),'Value',0);
handles.rb1=0;
set(findobj('Tag','rb2'),'Value',0);
handles.rb2=0;
set(findobj('Tag','rb3'),'Value',0);
handles.rb3=0;
set(findobj('Tag','rb4'),'Value',1);
handles.rb4=1;
guidata(hObject,handles);

%滤波的选择
function type_Callback(hObject, eventdata, handles)
handles.type=get(findobj('Tag','type'),'Value');
guidata(hObject,handles);
function type_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%参数的输入
function flp_Callback(hObject, eventdata, handles)
handles.flp=str2double(get(findobj('Tag','flp'),'String'));
guidata(hObject,handles);
function flp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fls_Callback(hObject, eventdata, handles)
handles.fls=str2double(get(findobj('Tag','fls'),'String'));
guidata(hObject,handles);
function fls_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function N_Callback(hObject, eventdata, handles)
function N_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
