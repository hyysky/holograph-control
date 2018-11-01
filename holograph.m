function varargout = holograph(varargin)
% HOLOGRAPH MATLAB code for holograph.fig
%      HOLOGRAPH, by itself, creates a new HOLOGRAPH or raises the existing
%      singleton*.
%
%      H = HOLOGRAPH returns the handle to a new HOLOGRAPH or the handle to
%      the existing singleton*.
%
%      HOLOGRAPH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOLOGRAPH.M with the given input arguments.
%
%      HOLOGRAPH('Property','Value',...) creates a new HOLOGRAPH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before holograph_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to holograph_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help holograph

% Last Modified by GUIDE v2.5 22-Oct-2018 17:01:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @holograph_OpeningFcn, ...
    'gui_OutputFcn',  @holograph_OutputFcn, ...
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

% --- Executes just before holograph is made visible.
function holograph_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to holograph (see VARARGIN)

% Choose default command line output for holograph
handles.output = hObject;
warning off all;
%% 改变窗口左上角的图标为icon.jpg
javaFrame = get(hObject, 'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('PMO1.jpg'));
%% 初始化
pathstr = fileparts(which(mfilename));
if exist([pathstr '\lamb.mat'], 'file') == 2
    load([pathstr '\lamb.mat']);
else
    startData = imread('green.jpg');
    finishData = imread('red.jpg');
    initData = imread('black.jpg');
    save lamb.mat startData finishData initData;
end
%% 与数字相关器相连串口初始化参数
hasData = false; 	%表征串口是否接收到数据
isShow = false;  	%表征是否正在进行数据显示，即是否正在执行函数dataDisp
isStopRec = true;  	%表征是否按下了【停止显示】按钮
isSaveData = false;  %表征是否勾选了【保存数据】
isDataMode = false;   %表征是否处于数据模式
numRec = 0;    	%接收字符计数
numPro = 0;     %处理数据计数
strRec = [];   		%已接收的字符串
dataPro = [];        %已处理数据
addrSave = '';      %接收数据保存地址
dataFig = zeros(1000,6);
%% 与天线相连串口的参数初始化
isShowacom = false; %表征是否正在进行数据显示，即是否正在执行函数data_show
hasDataacom = false;%表征串口是否接收到数据
dataProacom = [];   %已处理数据
dataSaveAnt = [];
addrSaveAnt = '';
addrSave2 = '';     %接收数据保存地址
strRecacom = [];
%% 全息测量所需参数初始化
isHolograph = false;    %全息测量开始标志位
ROWnum = 0;             %扫描行数标志
isSaveCal = false;      %保存校准文件标志位
isSaveRX = false;       %保存有效区间数据标志位
isScan = false;         %是否扫描标志位
%% 将上述参数作为应用数据，存入窗口对象内
setappdata(hObject,'dataFig',dataFig);
setappdata(hObject, 'hasData', hasData);
setappdata(hObject, 'strRec', strRec);
setappdata(hObject, 'numRec', numRec);
setappdata(hObject, 'numPro', numPro);
setappdata(hObject, 'dataPro', dataPro);
setappdata(hObject, 'isShow', isShow);
setappdata(hObject, 'isStopRec', isStopRec);
setappdata(hObject, 'isSaveData', isSaveData);
setappdata(hObject, 'isDataMode', isDataMode);
setappdata(hObject, 'isShowacom', isShowacom);
setappdata(hObject, 'hasDataacom', hasDataacom);
setappdata(hObject,'strRecacom',strRecacom);
setappdata(hObject, 'addrSave', addrSave);
setappdata(hObject, 'addrSave2', addrSave2);
setappdata(hObject, 'addrSaveAnt', addrSaveAnt);
setappdata(hObject, 'dataProacom', dataProacom);
setappdata(hObject, 'dataSaveAnt', dataSaveAnt);
set(handles.lamb, 'cdata', finishData);%初始化串口状态指示灯，串口灯默认为红色状态
set(handles.lamb_mode, 'cdata', initData);%初始化模式转换状态指示灯，默认为黑白状态
setappdata(hObject, 'startData', startData);
setappdata(hObject, 'finishData', finishData);
setappdata(hObject, 'initData', initData);
setappdata(hObject, 'ROWnum', ROWnum);
setappdata(hObject, 'isHolograph', isHolograph);
setappdata(hObject, 'isSaveCal', isSaveCal);
setappdata(hObject, 'isSaveRX', isSaveRX);
setappdata(hObject, 'isScan', isScan);
axes(handles.ASIARI);
title('Asi&Ari');
grid on;
% Update handles structure
guidata(hObject, handles);


%% 打开串口
function serial_open_Callback(hObject, eventdata, handles)
% hObject    handle to serial_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value')
    com_n = sprintf('com%d', get(handles.com2, 'value'));
    com_m = sprintf('com%d', get(handles.com1, 'value'));
    scom = serial(com_n);
    acom = serial(com_m);
    bcom = serial('COM2');
    set(scom, 'BaudRate', 115200, 'Parity', 'none', 'DataBits',...
        8, 'StopBits', 1,'InputBufferSize',512*4,...
        'BytesAvailableFcnCount', 256,'BytesAvailableFcnMode', 'byte', ...
        'BytesAvailableFcn', {@bytes, handles},...
        'TimerPeriod', 0.3, 'timerfcn', {@dataDisp, handles});
    setappdata(handles.figure1,'scom',scom);
    set(acom,'BaudRate',115200,'DataBits',8,'Parity','none','FlowControl',...
        'none','BytesAvailableFcnCount', 72,'BytesAvailableFcnMode', 'byte',...
        'BytesAvailableFcn',{@dataRec,handles},...
        'Timerperiod',0.1,'TimerFcn',{@data_show,handles},'InputBufferSize',512*4);
     setappdata(handles.figure1,'acom',acom);
        set(bcom,'BaudRate',38400,'DataBits',8,'Parity','none','FlowControl',...
        'none','BytesAvailableFcnMode','byte','BytesAvailableFcnCount',...
        256,'BytesAvailableFcn',{@dataRecb,handles},...
        'InputBufferSize',512*4);
    setappdata(handles.figure1,'bcom',bcom);
    try
        fopen(scom);  %打开串口
        scom.Terminator = 'CR';
        fopen(acom);
        fopen(bcom);
        acom=getappdata(handles.figure1, 'acom');
        str = get(acom, 'TransferStatus');
        if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
            c=strcat('#RTREQ 1|',13);
            fprintf(acom,'%s',c,'async');
        end
    catch   % 若串口打开失败，提示“串口不可获得！”
        set(hObject, 'value', 0);  %弹起本按钮
        Msg = msgbox('串口不可获得！');
        pause(1);
        if ishandle(Msg)
            delete(Msg);
        end
        pause(0.5);
        button = questdlg('重置串口？','重置确认','Yes','No','Yes');
        switch button
            case 'Yes'
                instrreset;
                RMsg = msgbox('串口已重置，再次尝试打开串口？');
            case 'No'
                return;
        end
        return;
    end
    set(handles.lamb, 'cdata', getappdata(handles.figure1,'startData')); %点亮串口状态指示灯
    set(hObject, 'String', '关闭串口');  		%设置本按钮文本为“关闭串口”
else  %若关闭串口
    %% 停止并删除定时器
    t = timerfind;
    if ~isempty(t)
        stop(t);
        delete(t);
    end
    %% 停止并删除串口对象
    s = instrfind;
    stopasync(s);
    fclose(s);
    delete(s);
    %% 熄灭串口状态指示灯,设置为【打开串口】
    set(hObject, 'String', '打开串口');
    set(handles.start_rec, 'String', '开始接收', 'value', 0);
    set(handles.holograph, 'String', '开启全息', 'value', 0);
    set(handles.lamb, 'cdata', getappdata(handles.figure1,'finishData'));
    set(handles.lamb_mode,'cdata', getappdata(handles.figure1,'initData'));
    setappdata(handles.figure1, 'hasData', false);
    setappdata(handles.figure1,'isShow',false);
    setappdata(handles.figure1,'isDataMode',false);
    setappdata(handles.figure1, 'isStopDisp', true);
end
guidata(hObject, handles);

function dataDisp(obj, event, handles)
%% 获取参数
dataPro = getappdata(handles.figure1,'dataPro'); %串口已处理数据
hasData = getappdata(handles.figure1, 'hasData'); %串口是否收到数据
%% 若串口没有接收到数据，先尝试接收串口数据
if ~hasData
    bytes(obj, event, handles);
end

%% 若串口有数据，显示串口数据
if hasData && ~isempty(dataPro)
    %% 给数据显示模块加互斥锁
    %% 在执行显示数据模块时，不接受串口数据，即不执行BytesAvailableFcn回调函数
    setappdata(handles.figure1, 'isShow', true);
    dataFig = getappdata(handles.figure1,'dataFig');
    
    %% 计算相关幅度和相位
    Amp = sqrt(dataPro(end,4)^2+dataPro(end,5)^2);
    Pha = atan2d(dataPro(end,5),dataPro(end,4));%arctan函数
    data = dataPro(end,:);
    data(4) = Amp;
    data(5) = Pha;
    dataFig = [dataFig(2:end,:);data];
    setappdata(handles.figure1,'dataFig',dataFig);
    
    %% 数据显示
    set(handles.Ic,'String', dataPro(end,4));
    set(handles.Qc,'String', dataPro(end,5));
    set(handles.ASI, 'String', dataPro(end,2));
    set(handles.ARI, 'String', dataPro(end,3));
    set(handles.AC, 'String', mean(dataFig(:,4)));
    set(handles.phase, 'String',dataPro(end,6));
    [length,high] = size(dataFig);
    axes(handles.ASIARI)
    plot(handles.ASIARI,(1:length),dataFig(:,2),'r',(1:length),dataFig(:,3),'g');
    legend(handles.ASIARI,'ASI','ARI','Location','northeast');
    %% 更新hasData标志，表明串口数据已经显示
    setappdata(handles.figure1, 'hasData', false);
    %% 给数据显示模块解锁
    setappdata(handles.figure1, 'isShow', false);
end

%%   串口的BytesAvailableFcn回调函数
%%   串口接收数据
function bytes(obj, ~, handles)
%% 获取模式转换灯，若为红色接收数据，否则等待
isDataMode = getappdata(handles.figure1,'isDataMode');
if ~isDataMode
    return;
end
%% 获取参数
strRec = getappdata(handles.figure1,'strRec');
isStopRec = getappdata(handles.figure1, 'isStopRec'); %是否按下了【停止显示】按钮
isShow = getappdata(handles.figure1, 'isShow');  %是否正在执行显示数据操作
%% 若正在执行数据显示操作，暂不接收串口数据
if isShow
    return;
end
%% 获取串口可获取的数据个数
n = get(obj, 'BytesAvailable');
%% 若串口有数据，接收所有数据
if n
    %% 读取串口数据
    a = fread(obj, n, 'uchar');
    %% 若没有停止接收，将接收到的数据解算出来，存储并显示
    if ~isStopRec
        strRec = [strRec;a];
        %% 更新参数
        setappdata(handles.figure1, 'strRec', strRec); %更新要显示的字符串
        %% 解析数据
        dataFig = getappdata(handles.figure1, 'dataFig');
        strRec = getappdata(handles.figure1, 'strRec'); %获取串口要显示的数据
        numPro = getappdata(handles.figure1,'numPro');  %获取串口已处理数据的个数
        %% 解析数据得到Idx,Asi,Ari,Ac,Qc，并存入到中间变量data中。
        [dataPro,numPro,str] = processdata(strRec,numPro);
        %% 更新已处理数据
        setappdata(handles.figure1,'dataPro',dataPro);
        setappdata(handles.figure1,'strRec',str);
        setappdata(handles.figure1,'numPro',numPro);
        setappdata(handles.figure1, 'dataFig', dataFig);
        %% 数据保存
        isSaveData = getappdata(handles.figure1,'isSaveData');
        isSaveRX = getappdata(handles.figure1, 'isSaveRX');
        isSaveCal = getappdata(handles.figure1, 'isSaveCal');
        %% 数字相关器单独存数据
        if isSaveData
            addrSave = getappdata(handles.figure1,'addrSave');  %获取文件保存地址
            fid1 = fopen(addrSave,'a+');%'a');    %在打开的文件末端添加数据
            [datarow datacol]= size(dataPro);
            if datarow
                for i = 1:datarow
                    fprintf(fid1,'%13d  %13d  %13d  %13d  %13d  %13.4f  \r\n',dataPro(i,:));
                end
            end
            fclose(fid1);
        end
        %% 保存全息测量期间数据
        if isSaveRX
            ROWnum = getappdata(handles.figure1, 'ROWnum');
            dataSave1 = [];
            [datarow datacol] = size(dataPro);
            for i=1:datarow
                dataSave1(i,:) = [ROWnum,dataPro(i,:)];
            end
            fid1 = getappdata(handles.figure1,'fid1');
%             fid = fopen(addrSave1,'a+');
            if datarow
                for i = 1:datarow
                    fprintf(fid1,'%13d  %13d  %13d  %13d  %13d  %13d  %13.4f  \r\n',dataSave1(i,:));
                end
            end
%             fclose(fid);
        end
        %% 保存校准文件
        if isSaveCal
            dataProacom = getappdata(handles.figure1,'dataProacom');
            dAZ = dataProacom(end,3);
            dEL = dataProacom(end,4);
            dataSave2 = [];
            [datarow datacol]= size(dataPro);
            for i=1:datarow
                dataSave2(i,:) = [dataPro(i,:),dAZ,dEL];
            end
            fid3 = getappdata(handles.figure1,'fid3');
%             fid = fopen(addrSave3,'a+');
            if datarow
                for i = 1:datarow
                    if(abs(dAZ)<=0.0006 && abs(dEL)<=0.0006) 
                        fprintf(fid3,'%13d  %13d  %13d  %13d  %13d  %13.4f  %13.4f  %13.4f  \r\n',dataSave2(i,:));
                    end
                end
            end
%             fclose(fid);
        end
        %% 更新hasData参数，表明串口有数据需要显示
        setappdata(handles.figure1, 'hasData', true);
    end
end

%% 接收轴角板数据
function dataRecb(obj,~,handles)
isShowacom = getappdata(handles.figure1, 'isShowacom');
AZCENTER = getappdata(handles.figure1, 'AZCENTER');
ELCENTER = getappdata(handles.figure1, 'ELCENTER');
ROWnum = getappdata(handles.figure1, 'ROWnum');
strRecacom = getappdata(handles.figure1,'strRecacom');
if isShowacom
    return;
end
n = get(obj, 'BytesAvailable');
if n
    a = fread(obj, n, 'uchar');
    strRecacom = [strRecacom;a];
    setappdata(handles.figure1,'strRecacom',strRecacom);
    %% 若有，继续读取，直到串口无数据
    t = timer('TimerFcn',@TimerFcn,'Period',0.002);
    start(t);
    while t.userdata == 'S'
        break;
    end
    stop(t);
    delete(t);   
    %% 数据处理
    if find(strRecacom==235,1)
        [dataProacom,dataSaveAnt,ADeckAng,EDeckAng]=processbcom(strRecacom,AZCENTER,ELCENTER,ROWnum);
        setappdata(handles.figure1, 'ADeckAng', ADeckAng);
        setappdata(handles.figure1, 'EDeckAng', EDeckAng);
        setappdata(handles.figure1, 'hasDataacom', true);
        setappdata(handles.figure1, 'dataProacom',dataProacom);
        setappdata(handles.figure1, 'dataSaveAnt',dataSaveAnt);
    end
    isSaveRX = getappdata(handles.figure1,'isSaveRX');
    if isSaveRX
        dataProacom = getappdata(handles.figure1, 'dataProacom');
        fid2 = getappdata(handles.figure1,'fid2');  %获取文件保存地址
        [datarow datacol]= size(dataProacom);
        if datarow
            for i = 1:datarow
                fprintf(fid2,'%13d  %13d  %13.4f  %13.4f  \r\n',dataProacom(i,:));
            end
        end
%         fclose(fid2);
    end
    isSaveData = getappdata(handles.figure1, 'isSaveData');
    isStopRec = getappdata(handles.figure1, 'isStopRec');
    dataSaveAnt = getappdata(handles.figure1, 'dataSaveAnt');
    if isSaveData && ~isStopRec
        addrSaveAnt = getappdata(handles.figure1, 'addrSaveAnt');
        fid = fopen(addrSaveAnt,'a+');
        [datarow datacol] = size(dataSaveAnt);
        if datarow
            for i = 1:datarow
                fprintf(fid,'%13d  %13.4f  %13.4f  \r\n',dataSaveAnt(i,:));
            end
        end
        fclose(fid);
    end
end


%% 定时器t的回调函数
function TimerFcn(obj,event)
bcom =  getappdaTA(handles.figure1, 'bcom');
strRecacom = getappdata(handles.figure1,'strRecacom');
n = get(bcom, 'BytesAvailable');
if n
    a = fread(obj, n, 'uchar');
    %% 更新要显示的字符串
    strRecacom = [strRecacom;a];
    obj.userdata = 'C';
else
    obj.userdata = 'S';
end
setappdata(handles.figure1, 'strRecacom', strRecacom); %更新要显示的字符串


%% 接收来自天线的数据
function dataRec(obj,~,handles)


%% 数据处理及显示函数
function data_show (obj,~, handles)
dataProacom = getappdata(handles.figure1,'dataProacom');
hasDataacom = getappdata(handles.figure1, 'hasDataacom');
%% 串口接收到数据，进行数据处理及显示
if hasDataacom && ~isempty(dataProacom)
    setappdata(handles.figure1, 'isShowacom', true);
    ADeckAng = getappdata(handles.figure1, 'ADeckAng');
    EDeckAng = getappdata(handles.figure1, 'EDeckAng');
    dAZ = dataProacom(end,3);
    dEL = dataProacom(end,4);
    set(handles.AZ_real, 'String',num2str(ADeckAng,'%.4f'));
    set(handles.EL_real, 'String',num2str(EDeckAng,'%.4f'));
    set(handles.AZ_offset, 'String',num2str(dAZ,'%.4f'));
    set(handles.EL_offset, 'String',num2str(dEL,'%.4f'));
    %% 更新hasData标志，表明串口数据已经显示
    setappdata(handles.figure1, 'hasDataacom', false);
    %% 给数据显示模块解锁
    setappdata(handles.figure1, 'isShowacom', false);
end
isHolograph = getappdata(handles.figure1, 'isHolograph');
if isHolograph
    ADeckAng = getappdata(handles.figure1, 'ADeckAng');
    EDeckAng = getappdata(handles.figure1, 'EDeckAng');
    AZCENTER = getappdata(handles.figure1, 'AZCENTER');
    ELCENTER = getappdata(handles.figure1, 'ELCENTER');
    ROWnum = getappdata(handles.figure1, 'ROWnum');
    AZstartScan = getappdata(handles.figure1, 'AZstartScan');
    AZendScan = getappdata(handles.figure1, 'AZendScan');
    EL = getappdata(handles.figure1, 'EL');
    AZstart = getappdata(handles.figure1, 'AZstart');
    AZend = getappdata(handles.figure1, 'AZend');
    ROW = getappdata(handles.figure1, 'ROW');
    CALROW = getappdata(handles.figure1, 'CALROW');
    if position1(AZend(ROWnum),AZstart(ROWnum),ADeckAng)                %指向位置处于开始与结束之间
        if getappdata(handles.figure1,'isScan')         %判断是否在扫描
            setappdata(handles.figure1, 'isSaveRX', true)%处于扫描模式时存储扫描信息
            setappdata(handles.figure1, 'isSend',false);
            setappdata(handles.figure1,'isSendPDB',false);
        else
            setappdata(handles.figure1, 'isSaveRX', false) %若不是扫描模式停止存储
        end
    else
        setappdata(handles.figure1, 'isSaveRX', false);     %不处于扫描区间，不存储信息
    end
    if position2(AZCENTER,ELCENTER,ADeckAng,EDeckAng)              %指向位置处于扫描中心位置
        if getappdata(handles.figure1, 'isScan')
            return;
        else
            isCal = getappdata(handles.figure1, 'isCal');    %校验信息存储标志位
            if isCal<3                             %校验位小于5时，存储
                setappdata(handles.figure1, 'isSaveCal', true);
                isCal = isCal+1;
            else
                setappdata(handles.figure1, 'isSaveCal', false);%其他情况停止存储校验信息，将校验标志位置零
                isCal = 0;
                if(ROWnum==ROW+1)                       %全息结束，删除定时器，将全息测量标志位置为false
                    repeatnum = getappdata(handles.figure1,'repeatnum');
                    REPEAT = getappdata(handles.figure1,'REPEAT');
                    if(repeatnum == REPEAT)
                        setappdata(handles.figure1, 'isHolograph',false);
                        set(handles.holograph, 'String', '开启全息','value',0);
                        setappdata(handles.figure1, 'isStopRec', true);
                        set(handles.start_rec, 'String', '开始接收', 'value', 0);
                        fclose all;
                        acom = getappdata(handles.figure1,'acom');
                        str = get(acom, 'TransferStatus');
                        if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
                            p=strcat('#STOP|',13)
                            fprintf(acom,'%s',p,'async');
                        end
                        set(handles.status,'String','全息测量结束');
                    else
                        ROWnum = 1;
                        isCal = 0;
                        repeatnum = repeatnum+1;
                        inputstr = strcat('正在进行第', num2str(repeatnum), '次扫描');
                        set(handles.status,'String',inputstr);
                        [AZCENTER1,ELCENTER1] = transform(AZCENTER,ELCENTER);
                        az = numformat(AZCENTER1);
                        el = numformat(ELCENTER1);
                        acom=getappdata(handles.figure1, 'acom');
                        str = get(acom, 'TransferStatus');
                        if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
                            s=strcat('#STOP|',13)
                            fprintf(acom,'%s',s,'async');
                            pause(0.5);
                            p=strcat('#PDB',32,az,',',el,'|',13)
                            fprintf(acom,'%s',p,'async');
                            set(handles.status,'String','正在进行中心位置校验');
                            setappdata(handles.figure1, 'isCalsend',true);
                        end
                        setappdata(handles.figure1, 'isScan', false);
                        setappdata(handles.figure1, 'isSaveCal', false);
                        setappdata(handles.figure1, 'isSaveRX', false);
                        setappdata(handles.figure1, 'ROWnum', ROWnum);
                        setappdata(handles.figure1,'repeatnum',repeatnum);
                        setappdata(handles.figure1, 'isCal',isCal);
                        setappdata(handles.figure1, 'isSend',false);
                        setappdata(handles.figure1,'isSendPDB',false);
                        setappdata(handles.figure1, 'isCalsend',true);
                    end
                elseif(ROWnum<=ROW)                     %全息未结束，根据行数的奇偶将天线置于下一行扫描的起点
                    if (rem(ROWnum,2)==1)
                        [AZstartScan1,ELstart1] = transform(AZstartScan(ROWnum),EL(ROWnum));
                        az = numformat(AZstartScan1);
                        el = numformat(ELstart1);
                        acom=getappdata(handles.figure1, 'acom');
                        str = get(acom, 'TransferStatus');
                        if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
                            p=strcat('#PDB',32,az,',',el,'|',13)
                            fprintf(acom,'%s',p,'async');
                        end
                        setappdata(handles.figure1, 'isCalsend',false);
                    elseif (rem(ROWnum,2)==0)
                        [AZstartScan1,ELstart1] = transform(AZendScan(ROWnum),EL(ROWnum));
                        az = numformat(AZstartScan1);
                        el = numformat(ELstart1);
                        acom=getappdata(handles.figure1, 'acom');
                        str = get(acom, 'TransferStatus');
                        if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
                            p=strcat('#PDB',32,az,',',el,'|',13)
                            fprintf(acom,'%s',p,'async');
                        end
                        setappdata(handles.figure1, 'isCalsend',false);
                    end
                else
                    return;
                end
            end
            setappdata(handles.figure1, 'isCal',isCal);
        end
    elseif position(AZendScan(ROWnum),ADeckAng)            %指向位置处于扫描结束点位置
        a = getappdata(handles.figure1,'isCalsend');
        if a
            return;
        else
            if rem(ROWnum,2)==1                         %奇数行为扫描终点，进一步检测是否需要校验
                ROWnum = ROWnum+1;                      %更新ROWnum数值
                setappdata(handles.figure1,'isScan',false);     %扫描标志位设为false
                setappdata(handles.figure1, 'ROWnum', ROWnum);
                if (rem(ROWnum-1,CALROW)==0 || ROWnum==ROW+1)        %检验是否需要进行校验
                    [AZCENTER1,ELCENTER1] = transform(AZCENTER,ELCENTER);
                    az = numformat(AZCENTER1);
                    el = numformat(ELCENTER1);
                    acom=getappdata(handles.figure1, 'acom');
                    str = get(acom, 'TransferStatus');
                    if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
                        s=strcat('#STOP|',13)
                        fprintf(acom,'%s',s,'async');
                        pause(0.5);
                        p=strcat('#PDB',32,az,',',el,'|',13)
                        fprintf(acom,'%s',p,'async');
                        set(handles.status,'String','正在进行中心位置校验');
                        setappdata(handles.figure1, 'isCalsend',true);
                    end
                else
                    if getappdata(handles.figure1, 'isSendPDB')
                        return;
                    else
                        acom = getappdata(handles.figure1,'acom');                
                        [AZstartScan1,ELstart1] = transform(AZendScan(ROWnum),EL(ROWnum));     %不需要校验时，预置到下一行扫描的起点
                        az = numformat(AZstartScan1);
                        el = numformat(ELstart1);
                        acom=getappdata(handles.figure1, 'acom');
                        str = get(acom, 'TransferStatus');
                        if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
                            s=strcat('#STOP|',13)
                            fprintf(acom,'%s',s,'async');
                            pause(0.5);
                            p=strcat('#PDB',32,az,',',el,'|',13)
                            fprintf(acom,'%s',p,'async');
                            setappdata(handles.figure1,'isSendPDB',true);
                        end
                    end
                end
                setappdata(handles.figure1,'isScan',false);
            elseif (rem(ROWnum,2)==0)                       %偶数行则此位置为扫描起点，发送扫描指令
                if getappdata(handles.figure1, 'isSend')
                    return;
                else
                    [AZstartScan1,ELstart1] = transform(AZendScan(ROWnum),EL(ROWnum));
                    [AZendScan1,ELend1] = transform(AZstartScan(ROWnum),EL(ROWnum));
                    AZspeed = getappdata(handles.figure1, 'AZspeed');
                    azstart = numformat(AZstartScan1);
                    azend = numformat(AZendScan1);
                    elstart = numformat(ELstart1);
                    elend = numformat(ELend1);
                    azspeed = numformatb(AZspeed);
                    elspeed = numformatb(0);
                    acom=getappdata(handles.figure1,'acom');
                    str = get(acom, 'TransferStatus');
                    if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
                        s=strcat('#STOP|',13)
                        fprintf(acom,'%s',s,'async');
                        pause(0.5);
                        g=strcat('#SCAN',32,azstart,',',azend,',',elstart,',',elend,',',azspeed,',',elspeed,'|',13)
                        fprintf(acom,'%s',g,'async');
                        setappdata(handles.figure1, 'isSend',true);
                        setappdata(handles.figure1, 'isScan', true);
                        inputstr = strcat('正在进行第', num2str(ROWnum), '行扫描');
                        set(handles.status,'String',inputstr);
                    end
                end
            else
                return;
            end
        end
    elseif position(AZstartScan(ROWnum),ADeckAng)       %指向扫描开始位置时
        a = getappdata(handles.figure1,'isCalsend');
        if a
            return;
        else
            if (rem(ROWnum,2)==0)                       %偶数行，此位置为扫描的终点，进一步检验是否需要校验
                ROWnum = ROWnum + 1;
                setappdata(handles.figure1,'isScan',false);%扫描标志位设为false
                setappdata(handles.figure1, 'ROWnum', ROWnum);
                if (rem(ROWnum-1,CALROW)==0 || ROWnum == ROW+1)      %检验是否需要校验
                    [AZCENTER1,ELCENTER1] = transform(AZCENTER,ELCENTER);
                    az = numformat(AZCENTER1);
                    el = numformat(ELCENTER1);
                    acom=getappdata(handles.figure1, 'acom');
                    str = get(acom, 'TransferStatus');
                    if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
                        s=strcat('#STOP|',13)
                        fprintf(acom,'%s',s,'async');
                        pause(0.5);
                        p=strcat('#PDB',32,az,',',el,'|',13)
                        fprintf(acom,'%s',p,'async');
                        set(handles.status,'String','正在进行中心位置校验');
                        setappdata(handles.figure1, 'isCalsend',true);
                    end
                else
                    if getappdata(handles.figure1, 'isSendPDB')
                        return;
                    else
                        acom = getappdata(handles.figure1,'acom');
                        str = get(acom, 'TransferStatus');
                        [AZstartScan1,ELstart1] = transform(AZstartScan(ROWnum),EL(ROWnum));   %不需要校验时，预置到下一行扫描的起点
                        az = numformat(AZstartScan1);
                        el = numformat(ELstart1);
                        acom=getappdata(handles.figure1, 'acom');
                        str = get(acom, 'TransferStatus');
                        if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
                            s=strcat('#STOP|',13)
                            fprintf(acom,'%s',s,'async');
                            pause(0.5);
                            p=strcat('#PDB',32,az,',',el,'|',13)
                            fprintf(acom,'%s',p,'async');
                            setappdata(handles.figure1,'isSendPDB',true);
                        end
                    end
                end
                setappdata(handles.figure1,'isScan',false);
            elseif (rem(ROWnum,2)==1)                       %奇数行，此位置为扫描的起点，发送扫描指令
                if getappdata(handles.figure1,'isSend')
                    return;
                else
                    [AZstartScan1,ELstart1] = transform(AZstartScan(ROWnum),EL(ROWnum));
                    [AZendScan1,ELend1] = transform(AZendScan(ROWnum),EL(ROWnum));
                    AZspeed = getappdata(handles.figure1, 'AZspeed');
                    azstart = numformat(AZstartScan1);
                    azend = numformat(AZendScan1);
                    elstart = numformat(ELstart1);
                    elend = numformat(ELend1);
                    azspeed = numformatb(AZspeed);
                    elspeed = numformatb(0);
                    acom=getappdata(handles.figure1,'acom');
                    str = get(acom, 'TransferStatus');
                    if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
                        s=strcat('#STOP|',13)
                        fprintf(acom,'%s',s,'async');
                        pause(0.5);
                        g=strcat('#SCAN',32,azstart,',',azend,',',elstart,',',elend,',',azspeed,',',elspeed,'|',13)
                        fprintf(acom,'%s',g,'async');
                        setappdata(handles.figure1, 'isSend',true);
                        setappdata(handles.figure1, 'isScan', true);                %将扫描标志位设为true，表明正在进行扫描
                        inputstr = strcat('正在进行第', num2str(ROWnum), '行扫描');
                        set(handles.status,'String',inputstr);
                    end
                end
            end
        end
    else
        setappdata(handles.figure1, 'isSaveCal', false);        %其他位置处不保存校验信息，防止天线在中心位置的抖动引起数据的不准确
    end
end


function figure1_CloseRequestFcn(hObject, eventdata, handles)
%   关闭窗口时，检查定时器和串口是否已关闭
%   若没有关闭，则先关闭
%% 查找定时器
t = timerfind;
%% 若存在定时器对象，停止并关闭
if ~isempty(t)
    stop(t);  %若定时器没有停止，则停止定时器
    delete(t);
end
%% 查找串口对象
scoms = instrfind;
%% 尝试停止、关闭删除串口对象
try
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
end
%% 关闭窗口
fclose all;
delete(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = holograph_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes on button press in start_rec.
function start_rec_Callback(hObject, eventdata, handles)
%% 根据【开始接收】按钮的状态，更新isStopRec参数
isDataMode = getappdata(handles.figure1,'isDataMode');
if isDataMode %若数据模式
    if get(hObject, 'value')
        isStopRec = false;
        set(hObject,'String','停止接收');
    else
        isStopRec = true;
        set(hObject,'String','开始接收');
    end
else
    isStopRec = true;
    msgbox('请先切换至控制模式！');
    set(hObject,'value',0); %弹起【开始接收】按钮
end
setappdata(handles.figure1, 'isStopRec', isStopRec);


% --- Executes on button press in copydata.
%% 保存数据
function copydata_Callback(hObject, eventdata, handles)
if get(hObject,'value')
    isSaveData = true;
    file1=strcat(date,'-',num2str(hour(now)),'-',num2str(minute(now)));
    [filename1,pathname1] = uiputfile('*.txt','数据另存为',file1);
    filename2 = strcat(date,'-',num2str(hour(now)),'-',num2str(minute(now)),'-ANT.txt');
    addrSave = fullfile([pathname1,filename1]);
    addrSaveAnt = fullfile([pathname1,filename2]);
else
    isSaveData = false;
    addrSave = '';
    addrSaveAnt = '';
end
setappdata(handles.figure1, 'isSaveData', isSaveData);
setappdata(handles.figure1, 'addrSave', addrSave);
setappdata(handles.figure1, 'addrSaveAnt', addrSaveAnt);



% --- Executes on button press in lamb_mode.
function lamb_mode_Callback(hObject, ~, handles)
% hObject    handle to lamb_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton1.
%% 控制模式
function togglebutton1_Callback(hObject, eventdata, handles)
if get(handles.serial_open,'value')
    if get(hObject,'value')%若按下【控制模式】
        % lamb_mode的背景色为绿色
        set(handles.lamb_mode,'cdata',getappdata(handles.figure1,'startData'));
        setappdata(handles.figure1,'isDataMode',false);  %关闭数据模式
        %% 读取NCO频率值
        nco_freq = getappdata(handles.figure1,'FREQ_NCO');
        %% 获取积分时间值
        Int_time = getappdata(handles.figure1,'TINT');
        %% 获取输出延迟值
        send_wait = getappdata(handles.figure1, 'DELAY');
        %% 向串口寄存器发送数据
        round_ncofreq = round(nco_freq/125*2^18);
        cfg_acc_cnt = round(Int_time/8.2*1000);
        scom =  getappdata(handles.figure1, 'scom');
        acom = getappdata(handles.figure1, 'acom');
        %% 获取串口的传输状态，若串口没有正在写数据，写入数据
        str = get(scom, 'TransferStatus');
        stra = get(acom, 'TransferStatus');
        if (~(strcmp(str, 'write') || strcmp(str, 'read&write'))) && ( ~(strcmp(stra, 'write') || strcmp(stra, 'read&write')))
            writereg(scom,2,hex2dec('84000000'));
            writereg(scom,2,bitor(hex2dec('84000000'),round_ncofreq));
            writereg(scom,4,bitor(hex2dec('80000000'),cfg_acc_cnt));
            writereg(scom,2,bitor(hex2dec('a4000000'),round_ncofreq));
            writereg(scom,2,bitor(hex2dec('24000000'),round_ncofreq));
            writereg(scom,2,bitor(hex2dec('64000000'),round_ncofreq));
            writereg(scom,2,bitor(hex2dec('44000000'),round_ncofreq));
            c=strcat('#TIMECLEAR|',13);
            fprintf(acom,'%s',c,'async');
            writereg(scom,0,send_wait);
            writereg(scom,0,bitor(hex2dec('40000000'), send_wait));
        end
%         pause(1);
        set(hObject,'value',0);%等待一秒，弹起【控制模式】按钮
        set(handles.lamb_mode,'cdata',getappdata(handles.figure1,'finishData'));
        setappdata(handles.figure1,'isDataMode',true);  %打开数据模式
        Msg = msgbox('已切换至数据输出模式！');
        pause(1);
        if ishandle(Msg)
            delete(Msg);
        end
    end
else  % 若【打开串口】按钮未按下，提示“先打开串口！”,并弹起本按钮
    msgbox('请先打开串口！');
    set(hObject,'value',0);
    set(handles.lamb_mode,'cdata',getappdata(handles.figure1,'initData')); %提示灯为黑色
    setappdata(handles.figure1,'isDataMode',false);
end


% --- Executes on button press in pushbutton6.
%% 预置功能
function pushbutton6_Callback(hObject, eventdata, handles)
a0=str2double(get(handles.AZ,'String'));
b0=str2double(get(handles.EL,'String'));
[a0,b0] = transform(a0,b0);
a=numformat(a0);
b=numformat(b0);
acom=getappdata(handles.figure1, 'acom');
str = get(acom, 'TransferStatus');
if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
    c=strcat('#PDB',32,a,',',b,'|',13);
    fprintf(acom,'%s',c,'async');
end
setappdata(handles.figure1, 'isSaveData', true);

% --- Executes on button press in TimeClear.
%% 计数清零
function TimeClear_Callback(hObject, eventdata, handles)
if get(hObject,'value')
    %% 天线计数器清零
    acom=getappdata(handles.figure1, 'acom');
    str = get(acom, 'TransferStatus');
    if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
        c=strcat('#TIMECLEAR|',13);
        fprintf(acom,'%s',c,'async');
    end
    %% 数据接收及数据处理初始化
    dataFig = zeros(100,5);
    setappdata(handles.figure1,'dataFig',dataFig);
    setappdata(handles.figure1, 'numRec', 0);
    setappdata(handles.figure1,'strRec',[]);
    setappdata(handles.figure1, 'numPro', 0);
    setappdata(handles.figure1, 'dataPro', []);
end

% --- Executes on button press in pushbutton10.
%% 待机指令
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
acom=getappdata(handles.figure1, 'acom');
str = get(acom, 'TransferStatus');
if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
    c=strcat('#STOP|',13);
    fprintf(acom,'%s',c,'async');
end
fclose all;
setappdata(handles.figure1,'isHolograph', false);
set(handles.holograph, 'value', 0, 'String', '开启全息');
set(handles.start_rec, 'String', '开始接收', 'value', 0);

% --- Executes on button press in open_set.
%% 载入输入参数
function open_set_Callback(hObject, eventdata, handles)
% hObject    handle to open_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.xlsx';'*.xls'},'选择文件');
file=strcat(pathname,filename);
[data,txt]=xlsread(file);
AZCENTER = data(1);
ELCENTER = data(2);
FREQ_RF = data(3);
FREQ_NCO= data(4);
R = data(5);
COLKOS = data(6);
ROWKOS = data(7);
REPEAT = data(8);
COL = data(9);
ROW = data(10);
TINT = data(11);
CALROW = data(12);
CALINTTIME = data(13);
DELAY = data(14);
c = 299792458;
D = 1200;
lambda = c/(FREQ_RF*10^6);
ELscan = 180/pi*ROW*ROWKOS*lambda/D;
ELstart = ELCENTER-ELscan/2;
EL = zeros(1,ROW+1);
AZscan = zeros(1,ROW+1);
AZstart = zeros(1,ROW+1);
AZstartScan = zeros(1,ROW+1);
AZend = zeros(1,ROW+1);
AZendScan = zeros(1,ROW+1);
for j=1:ROW+1
    EL(j) = ELstart + (j-1)*ELscan/(ROW-1);
end
for i =1:ROW+1
    AZscan(i) = 180/pi*COL*COLKOS*lambda/(D*cos(EL(i)*pi/180));
    AZstart(i) = AZCENTER-AZscan(i)/2;
    AZstartScan(i) = AZstart(i)-1;
    AZend(i) = AZCENTER+AZscan(i)/2;
    AZendScan(i) = AZend(i)+1;
end
% AZspeed = (AZscan*1000)/((COL-1)*TINT)
AZspeed = 1;
set(handles.AZ, 'String',num2str(AZCENTER,'%.4f'));
set(handles.EL, 'String',num2str(ELCENTER,'%.4f'));
setappdata(handles.figure1, 'AZscan',AZscan);
setappdata(handles.figure1, 'AZstart',AZstart);
setappdata(handles.figure1, 'AZstartScan',AZstartScan);
setappdata(handles.figure1, 'AZendScan', AZendScan);
setappdata(handles.figure1, 'AZend',AZend);
setappdata(handles.figure1, 'AZspeed',AZspeed);
setappdata(handles.figure1,'data',data);
setappdata(handles.figure1,'txt',txt);
setappdata(handles.figure1, 'EL',EL);
setappdata(handles.figure1, 'AZCENTER', AZCENTER);
setappdata(handles.figure1, 'ELCENTER', ELCENTER);
setappdata(handles.figure1, 'FREQ_NCO', FREQ_NCO);
setappdata(handles.figure1, 'COLKOS', COLKOS);
setappdata(handles.figure1, 'ROWKOS', ROWKOS);
setappdata(handles.figure1, 'REPEAT', REPEAT);
setappdata(handles.figure1, 'COL', COL);
setappdata(handles.figure1, 'ROW', ROW);
setappdata(handles.figure1, 'TINT', TINT);
setappdata(handles.figure1, 'CALROW', CALROW);
setappdata(handles.figure1, 'DELAY', DELAY);


% --- Executes on button press in holograph.
%% 全系测量程序
function holograph_Callback(hObject, eventdata, handles)
if get(hObject,'value')
    AZCENTER = getappdata(handles.figure1, 'AZCENTER');
    ELCENTER = getappdata(handles.figure1, 'ELCENTER');
    data = getappdata(handles.figure1,'data');
    txt = getappdata(handles.figure1,'txt');
    txt = char(txt);
    ROWnum = 1;
    isCal = 0;
    repeatnum = 1;
    d = day(now);
    m = month(now);
    h = hour(now);
    min = minute(now);
    if(d<10)
        d = strcat('0',num2str(d));
    else
        d = num2str(d);
    end
    if(m<10)
        m = strcat('0',num2str(m));
    else
        m = num2str(m);
    end
    if(h<10)
        h = strcat('0',num2str(h));
    else
        h = num2str(h);
    end
    if(min<10)
        min = strcat('0',num2str(min));
    else
        min = num2str(min);
    end
    filename1=strcat(num2str(year(now)),m,d,'_',h,min,'_RX.txt');
    filename2=strcat(num2str(year(now)),m,d,'_',h,min,'_ANT.txt');
    filename3=strcat(num2str(year(now)),m,d,'_',h,min,'_CAL.txt');
    filename4=strcat(num2str(year(now)),m,d,'_',h,min,'_PAR.txt');
    pathname = 'E:\holograph2018-4-3\data\';
    addrSave1 = fullfile([pathname,filename1]);
    addrSave2 = fullfile([pathname,filename2]);
    addrSave3 = fullfile([pathname,filename3]);
    addrSave4 = fullfile([pathname,filename4]);
    fid = fopen(addrSave4,'a+');
    for i=1:length(data)
        fprintf(fid,'%s',txt(i,:));
        fprintf(fid,'%.4f  \r\n',data(i));
    end;
    fclose(fid);
    [AZCENTER1,ELCENTER1] = transform(AZCENTER,ELCENTER);
    az = numformat(AZCENTER1);
    el = numformat(ELCENTER1);
    acom=getappdata(handles.figure1, 'acom');
    str = get(acom, 'TransferStatus');
    if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
        c=strcat('#PDB',32,az,',',el,'|',13);
        fprintf(acom,'%s',c,'async');
        set(handles.status,'String','正在进行中心位置校验');
    end
    setappdata(handles.figure1, 'isHolograph', true);
    set(hObject, 'String', '停止', 'value', 1);
    set(handles.start_rec, 'String', '停止接收', 'value', 1);
    setappdata(handles.figure1, 'isStopRec', false);
else
    fclose all;
    ROWnum = 0;
    repeatnum = 0;
    addrSave1 = '';
    addrSave2 = '';
    addrSave3 = '';
    isCal = 0;
    acom=getappdata(handles.figure1, 'acom');
    str = get(acom, 'TransferStatus');
    if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
        c=strcat('#STOP|',13);
        fprintf(acom,'%s',c,'async');
    end
    setappdata(handles.figure1, 'isHolograph', false);
    set(hObject, 'String', '开启全息');
    setappdata(handles.figure1, 'isStopRec', true);
    set(handles.start_rec, 'String', '开始接收', 'value', 0);
end
fid1 = fopen(addrSave1, 'a+');
fid2 = fopen(addrSave2, 'a+');
fid3 = fopen(addrSave3, 'a+');
setappdata(handles.figure1,'fid1',fid1);
setappdata(handles.figure1, 'fid2',fid2);
setappdata(handles.figure1, 'fid3',fid3);
setappdata(handles.figure1, 'isScan', false);
setappdata(handles.figure1, 'isSaveCal', false);
setappdata(handles.figure1, 'isSaveRX', false);
setappdata(handles.figure1, 'ROWnum', ROWnum);
setappdata(handles.figure1,'repeatnum',repeatnum);
setappdata(handles.figure1, 'isCal',isCal);
setappdata(handles.figure1, 'isSend',false);
setappdata(handles.figure1,'isSendPDB',false);
setappdata(handles.figure1, 'isCalsend',true);

function ncofreq_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ncofreq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Integration_time_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Integration_time_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function send_wait_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function send_wait_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in com1.
function com1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function com1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in com2.
function com2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function com2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in lamb.
function lamb_Callback(hObject, eventdata, handles)

% --- Executes on button press in opendata.
function opendata_Callback(hObject, eventdata, handles)

function ASI_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ASI_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function AC_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function AC_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ARI_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ARI_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function phase_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function phase_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function AZ_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function AZ_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function EL_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function EL_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function AZ_real_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function AZ_real_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function EL_real_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function EL_real_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function AZ_offset_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function AZ_offset_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function EL_offset_Callback(hObject, eventdata, handles)

function EL_offset_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Ic_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Ic_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Qc_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Qc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ASIARI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ASIARI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate ASIARI



function status_Callback(hObject, eventdata, handles)
% hObject    handle to status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of status as text
%        str2double(get(hObject,'String')) returns contents of status as a double


% --- Executes during object creation, after setting all properties.
function status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
