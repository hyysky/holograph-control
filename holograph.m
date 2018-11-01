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
%% �ı䴰�����Ͻǵ�ͼ��Ϊicon.jpg
javaFrame = get(hObject, 'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('PMO1.jpg'));
%% ��ʼ��
pathstr = fileparts(which(mfilename));
if exist([pathstr '\lamb.mat'], 'file') == 2
    load([pathstr '\lamb.mat']);
else
    startData = imread('green.jpg');
    finishData = imread('red.jpg');
    initData = imread('black.jpg');
    save lamb.mat startData finishData initData;
end
%% ������������������ڳ�ʼ������
hasData = false; 	%���������Ƿ���յ�����
isShow = false;  	%�����Ƿ����ڽ���������ʾ�����Ƿ�����ִ�к���dataDisp
isStopRec = true;  	%�����Ƿ����ˡ�ֹͣ��ʾ����ť
isSaveData = false;  %�����Ƿ�ѡ�ˡ��������ݡ�
isDataMode = false;   %�����Ƿ�������ģʽ
numRec = 0;    	%�����ַ�����
numPro = 0;     %�������ݼ���
strRec = [];   		%�ѽ��յ��ַ���
dataPro = [];        %�Ѵ�������
addrSave = '';      %�������ݱ����ַ
dataFig = zeros(1000,6);
%% �������������ڵĲ�����ʼ��
isShowacom = false; %�����Ƿ����ڽ���������ʾ�����Ƿ�����ִ�к���data_show
hasDataacom = false;%���������Ƿ���յ�����
dataProacom = [];   %�Ѵ�������
dataSaveAnt = [];
addrSaveAnt = '';
addrSave2 = '';     %�������ݱ����ַ
strRecacom = [];
%% ȫϢ�������������ʼ��
isHolograph = false;    %ȫϢ������ʼ��־λ
ROWnum = 0;             %ɨ��������־
isSaveCal = false;      %����У׼�ļ���־λ
isSaveRX = false;       %������Ч�������ݱ�־λ
isScan = false;         %�Ƿ�ɨ���־λ
%% ������������ΪӦ�����ݣ����봰�ڶ�����
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
set(handles.lamb, 'cdata', finishData);%��ʼ������״ָ̬ʾ�ƣ����ڵ�Ĭ��Ϊ��ɫ״̬
set(handles.lamb_mode, 'cdata', initData);%��ʼ��ģʽת��״ָ̬ʾ�ƣ�Ĭ��Ϊ�ڰ�״̬
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


%% �򿪴���
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
        fopen(scom);  %�򿪴���
        scom.Terminator = 'CR';
        fopen(acom);
        fopen(bcom);
        acom=getappdata(handles.figure1, 'acom');
        str = get(acom, 'TransferStatus');
        if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
            c=strcat('#RTREQ 1|',13);
            fprintf(acom,'%s',c,'async');
        end
    catch   % �����ڴ�ʧ�ܣ���ʾ�����ڲ��ɻ�ã���
        set(hObject, 'value', 0);  %���𱾰�ť
        Msg = msgbox('���ڲ��ɻ�ã�');
        pause(1);
        if ishandle(Msg)
            delete(Msg);
        end
        pause(0.5);
        button = questdlg('���ô��ڣ�','����ȷ��','Yes','No','Yes');
        switch button
            case 'Yes'
                instrreset;
                RMsg = msgbox('���������ã��ٴγ��Դ򿪴��ڣ�');
            case 'No'
                return;
        end
        return;
    end
    set(handles.lamb, 'cdata', getappdata(handles.figure1,'startData')); %��������״ָ̬ʾ��
    set(hObject, 'String', '�رմ���');  		%���ñ���ť�ı�Ϊ���رմ��ڡ�
else  %���رմ���
    %% ֹͣ��ɾ����ʱ��
    t = timerfind;
    if ~isempty(t)
        stop(t);
        delete(t);
    end
    %% ֹͣ��ɾ�����ڶ���
    s = instrfind;
    stopasync(s);
    fclose(s);
    delete(s);
    %% Ϩ�𴮿�״ָ̬ʾ��,����Ϊ���򿪴��ڡ�
    set(hObject, 'String', '�򿪴���');
    set(handles.start_rec, 'String', '��ʼ����', 'value', 0);
    set(handles.holograph, 'String', '����ȫϢ', 'value', 0);
    set(handles.lamb, 'cdata', getappdata(handles.figure1,'finishData'));
    set(handles.lamb_mode,'cdata', getappdata(handles.figure1,'initData'));
    setappdata(handles.figure1, 'hasData', false);
    setappdata(handles.figure1,'isShow',false);
    setappdata(handles.figure1,'isDataMode',false);
    setappdata(handles.figure1, 'isStopDisp', true);
end
guidata(hObject, handles);

function dataDisp(obj, event, handles)
%% ��ȡ����
dataPro = getappdata(handles.figure1,'dataPro'); %�����Ѵ�������
hasData = getappdata(handles.figure1, 'hasData'); %�����Ƿ��յ�����
%% ������û�н��յ����ݣ��ȳ��Խ��մ�������
if ~hasData
    bytes(obj, event, handles);
end

%% �����������ݣ���ʾ��������
if hasData && ~isempty(dataPro)
    %% ��������ʾģ��ӻ�����
    %% ��ִ����ʾ����ģ��ʱ�������ܴ������ݣ�����ִ��BytesAvailableFcn�ص�����
    setappdata(handles.figure1, 'isShow', true);
    dataFig = getappdata(handles.figure1,'dataFig');
    
    %% ������ط��Ⱥ���λ
    Amp = sqrt(dataPro(end,4)^2+dataPro(end,5)^2);
    Pha = atan2d(dataPro(end,5),dataPro(end,4));%arctan����
    data = dataPro(end,:);
    data(4) = Amp;
    data(5) = Pha;
    dataFig = [dataFig(2:end,:);data];
    setappdata(handles.figure1,'dataFig',dataFig);
    
    %% ������ʾ
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
    %% ����hasData��־���������������Ѿ���ʾ
    setappdata(handles.figure1, 'hasData', false);
    %% ��������ʾģ�����
    setappdata(handles.figure1, 'isShow', false);
end

%%   ���ڵ�BytesAvailableFcn�ص�����
%%   ���ڽ�������
function bytes(obj, ~, handles)
%% ��ȡģʽת���ƣ���Ϊ��ɫ�������ݣ�����ȴ�
isDataMode = getappdata(handles.figure1,'isDataMode');
if ~isDataMode
    return;
end
%% ��ȡ����
strRec = getappdata(handles.figure1,'strRec');
isStopRec = getappdata(handles.figure1, 'isStopRec'); %�Ƿ����ˡ�ֹͣ��ʾ����ť
isShow = getappdata(handles.figure1, 'isShow');  %�Ƿ�����ִ����ʾ���ݲ���
%% ������ִ��������ʾ�������ݲ����մ�������
if isShow
    return;
end
%% ��ȡ���ڿɻ�ȡ�����ݸ���
n = get(obj, 'BytesAvailable');
%% �����������ݣ�������������
if n
    %% ��ȡ��������
    a = fread(obj, n, 'uchar');
    %% ��û��ֹͣ���գ������յ������ݽ���������洢����ʾ
    if ~isStopRec
        strRec = [strRec;a];
        %% ���²���
        setappdata(handles.figure1, 'strRec', strRec); %����Ҫ��ʾ���ַ���
        %% ��������
        dataFig = getappdata(handles.figure1, 'dataFig');
        strRec = getappdata(handles.figure1, 'strRec'); %��ȡ����Ҫ��ʾ������
        numPro = getappdata(handles.figure1,'numPro');  %��ȡ�����Ѵ������ݵĸ���
        %% �������ݵõ�Idx,Asi,Ari,Ac,Qc�������뵽�м����data�С�
        [dataPro,numPro,str] = processdata(strRec,numPro);
        %% �����Ѵ�������
        setappdata(handles.figure1,'dataPro',dataPro);
        setappdata(handles.figure1,'strRec',str);
        setappdata(handles.figure1,'numPro',numPro);
        setappdata(handles.figure1, 'dataFig', dataFig);
        %% ���ݱ���
        isSaveData = getappdata(handles.figure1,'isSaveData');
        isSaveRX = getappdata(handles.figure1, 'isSaveRX');
        isSaveCal = getappdata(handles.figure1, 'isSaveCal');
        %% �������������������
        if isSaveData
            addrSave = getappdata(handles.figure1,'addrSave');  %��ȡ�ļ������ַ
            fid1 = fopen(addrSave,'a+');%'a');    %�ڴ򿪵��ļ�ĩ���������
            [datarow datacol]= size(dataPro);
            if datarow
                for i = 1:datarow
                    fprintf(fid1,'%13d  %13d  %13d  %13d  %13d  %13.4f  \r\n',dataPro(i,:));
                end
            end
            fclose(fid1);
        end
        %% ����ȫϢ�����ڼ�����
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
        %% ����У׼�ļ�
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
        %% ����hasData����������������������Ҫ��ʾ
        setappdata(handles.figure1, 'hasData', true);
    end
end

%% ������ǰ�����
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
    %% ���У�������ȡ��ֱ������������
    t = timer('TimerFcn',@TimerFcn,'Period',0.002);
    start(t);
    while t.userdata == 'S'
        break;
    end
    stop(t);
    delete(t);   
    %% ���ݴ���
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
        fid2 = getappdata(handles.figure1,'fid2');  %��ȡ�ļ������ַ
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


%% ��ʱ��t�Ļص�����
function TimerFcn(obj,event)
bcom =  getappdaTA(handles.figure1, 'bcom');
strRecacom = getappdata(handles.figure1,'strRecacom');
n = get(bcom, 'BytesAvailable');
if n
    a = fread(obj, n, 'uchar');
    %% ����Ҫ��ʾ���ַ���
    strRecacom = [strRecacom;a];
    obj.userdata = 'C';
else
    obj.userdata = 'S';
end
setappdata(handles.figure1, 'strRecacom', strRecacom); %����Ҫ��ʾ���ַ���


%% �����������ߵ�����
function dataRec(obj,~,handles)


%% ���ݴ�����ʾ����
function data_show (obj,~, handles)
dataProacom = getappdata(handles.figure1,'dataProacom');
hasDataacom = getappdata(handles.figure1, 'hasDataacom');
%% ���ڽ��յ����ݣ��������ݴ�����ʾ
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
    %% ����hasData��־���������������Ѿ���ʾ
    setappdata(handles.figure1, 'hasDataacom', false);
    %% ��������ʾģ�����
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
    if position1(AZend(ROWnum),AZstart(ROWnum),ADeckAng)                %ָ��λ�ô��ڿ�ʼ�����֮��
        if getappdata(handles.figure1,'isScan')         %�ж��Ƿ���ɨ��
            setappdata(handles.figure1, 'isSaveRX', true)%����ɨ��ģʽʱ�洢ɨ����Ϣ
            setappdata(handles.figure1, 'isSend',false);
            setappdata(handles.figure1,'isSendPDB',false);
        else
            setappdata(handles.figure1, 'isSaveRX', false) %������ɨ��ģʽֹͣ�洢
        end
    else
        setappdata(handles.figure1, 'isSaveRX', false);     %������ɨ�����䣬���洢��Ϣ
    end
    if position2(AZCENTER,ELCENTER,ADeckAng,EDeckAng)              %ָ��λ�ô���ɨ������λ��
        if getappdata(handles.figure1, 'isScan')
            return;
        else
            isCal = getappdata(handles.figure1, 'isCal');    %У����Ϣ�洢��־λ
            if isCal<3                             %У��λС��5ʱ���洢
                setappdata(handles.figure1, 'isSaveCal', true);
                isCal = isCal+1;
            else
                setappdata(handles.figure1, 'isSaveCal', false);%�������ֹͣ�洢У����Ϣ����У���־λ����
                isCal = 0;
                if(ROWnum==ROW+1)                       %ȫϢ������ɾ����ʱ������ȫϢ������־λ��Ϊfalse
                    repeatnum = getappdata(handles.figure1,'repeatnum');
                    REPEAT = getappdata(handles.figure1,'REPEAT');
                    if(repeatnum == REPEAT)
                        setappdata(handles.figure1, 'isHolograph',false);
                        set(handles.holograph, 'String', '����ȫϢ','value',0);
                        setappdata(handles.figure1, 'isStopRec', true);
                        set(handles.start_rec, 'String', '��ʼ����', 'value', 0);
                        fclose all;
                        acom = getappdata(handles.figure1,'acom');
                        str = get(acom, 'TransferStatus');
                        if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
                            p=strcat('#STOP|',13)
                            fprintf(acom,'%s',p,'async');
                        end
                        set(handles.status,'String','ȫϢ��������');
                    else
                        ROWnum = 1;
                        isCal = 0;
                        repeatnum = repeatnum+1;
                        inputstr = strcat('���ڽ��е�', num2str(repeatnum), '��ɨ��');
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
                            set(handles.status,'String','���ڽ�������λ��У��');
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
                elseif(ROWnum<=ROW)                     %ȫϢδ������������������ż������������һ��ɨ������
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
    elseif position(AZendScan(ROWnum),ADeckAng)            %ָ��λ�ô���ɨ�������λ��
        a = getappdata(handles.figure1,'isCalsend');
        if a
            return;
        else
            if rem(ROWnum,2)==1                         %������Ϊɨ���յ㣬��һ������Ƿ���ҪУ��
                ROWnum = ROWnum+1;                      %����ROWnum��ֵ
                setappdata(handles.figure1,'isScan',false);     %ɨ���־λ��Ϊfalse
                setappdata(handles.figure1, 'ROWnum', ROWnum);
                if (rem(ROWnum-1,CALROW)==0 || ROWnum==ROW+1)        %�����Ƿ���Ҫ����У��
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
                        set(handles.status,'String','���ڽ�������λ��У��');
                        setappdata(handles.figure1, 'isCalsend',true);
                    end
                else
                    if getappdata(handles.figure1, 'isSendPDB')
                        return;
                    else
                        acom = getappdata(handles.figure1,'acom');                
                        [AZstartScan1,ELstart1] = transform(AZendScan(ROWnum),EL(ROWnum));     %����ҪУ��ʱ��Ԥ�õ���һ��ɨ������
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
            elseif (rem(ROWnum,2)==0)                       %ż�������λ��Ϊɨ����㣬����ɨ��ָ��
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
                        inputstr = strcat('���ڽ��е�', num2str(ROWnum), '��ɨ��');
                        set(handles.status,'String',inputstr);
                    end
                end
            else
                return;
            end
        end
    elseif position(AZstartScan(ROWnum),ADeckAng)       %ָ��ɨ�迪ʼλ��ʱ
        a = getappdata(handles.figure1,'isCalsend');
        if a
            return;
        else
            if (rem(ROWnum,2)==0)                       %ż���У���λ��Ϊɨ����յ㣬��һ�������Ƿ���ҪУ��
                ROWnum = ROWnum + 1;
                setappdata(handles.figure1,'isScan',false);%ɨ���־λ��Ϊfalse
                setappdata(handles.figure1, 'ROWnum', ROWnum);
                if (rem(ROWnum-1,CALROW)==0 || ROWnum == ROW+1)      %�����Ƿ���ҪУ��
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
                        set(handles.status,'String','���ڽ�������λ��У��');
                        setappdata(handles.figure1, 'isCalsend',true);
                    end
                else
                    if getappdata(handles.figure1, 'isSendPDB')
                        return;
                    else
                        acom = getappdata(handles.figure1,'acom');
                        str = get(acom, 'TransferStatus');
                        [AZstartScan1,ELstart1] = transform(AZstartScan(ROWnum),EL(ROWnum));   %����ҪУ��ʱ��Ԥ�õ���һ��ɨ������
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
            elseif (rem(ROWnum,2)==1)                       %�����У���λ��Ϊɨ�����㣬����ɨ��ָ��
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
                        setappdata(handles.figure1, 'isScan', true);                %��ɨ���־λ��Ϊtrue���������ڽ���ɨ��
                        inputstr = strcat('���ڽ��е�', num2str(ROWnum), '��ɨ��');
                        set(handles.status,'String',inputstr);
                    end
                end
            end
        end
    else
        setappdata(handles.figure1, 'isSaveCal', false);        %����λ�ô�������У����Ϣ����ֹ����������λ�õĶ����������ݵĲ�׼ȷ
    end
end


function figure1_CloseRequestFcn(hObject, eventdata, handles)
%   �رմ���ʱ����鶨ʱ���ʹ����Ƿ��ѹر�
%   ��û�йرգ����ȹر�
%% ���Ҷ�ʱ��
t = timerfind;
%% �����ڶ�ʱ������ֹͣ���ر�
if ~isempty(t)
    stop(t);  %����ʱ��û��ֹͣ����ֹͣ��ʱ��
    delete(t);
end
%% ���Ҵ��ڶ���
scoms = instrfind;
%% ����ֹͣ���ر�ɾ�����ڶ���
try
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
end
%% �رմ���
fclose all;
delete(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = holograph_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes on button press in start_rec.
function start_rec_Callback(hObject, eventdata, handles)
%% ���ݡ���ʼ���ա���ť��״̬������isStopRec����
isDataMode = getappdata(handles.figure1,'isDataMode');
if isDataMode %������ģʽ
    if get(hObject, 'value')
        isStopRec = false;
        set(hObject,'String','ֹͣ����');
    else
        isStopRec = true;
        set(hObject,'String','��ʼ����');
    end
else
    isStopRec = true;
    msgbox('�����л�������ģʽ��');
    set(hObject,'value',0); %���𡾿�ʼ���ա���ť
end
setappdata(handles.figure1, 'isStopRec', isStopRec);


% --- Executes on button press in copydata.
%% ��������
function copydata_Callback(hObject, eventdata, handles)
if get(hObject,'value')
    isSaveData = true;
    file1=strcat(date,'-',num2str(hour(now)),'-',num2str(minute(now)));
    [filename1,pathname1] = uiputfile('*.txt','�������Ϊ',file1);
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
%% ����ģʽ
function togglebutton1_Callback(hObject, eventdata, handles)
if get(handles.serial_open,'value')
    if get(hObject,'value')%�����¡�����ģʽ��
        % lamb_mode�ı���ɫΪ��ɫ
        set(handles.lamb_mode,'cdata',getappdata(handles.figure1,'startData'));
        setappdata(handles.figure1,'isDataMode',false);  %�ر�����ģʽ
        %% ��ȡNCOƵ��ֵ
        nco_freq = getappdata(handles.figure1,'FREQ_NCO');
        %% ��ȡ����ʱ��ֵ
        Int_time = getappdata(handles.figure1,'TINT');
        %% ��ȡ����ӳ�ֵ
        send_wait = getappdata(handles.figure1, 'DELAY');
        %% �򴮿ڼĴ�����������
        round_ncofreq = round(nco_freq/125*2^18);
        cfg_acc_cnt = round(Int_time/8.2*1000);
        scom =  getappdata(handles.figure1, 'scom');
        acom = getappdata(handles.figure1, 'acom');
        %% ��ȡ���ڵĴ���״̬��������û������д���ݣ�д������
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
        set(hObject,'value',0);%�ȴ�һ�룬���𡾿���ģʽ����ť
        set(handles.lamb_mode,'cdata',getappdata(handles.figure1,'finishData'));
        setappdata(handles.figure1,'isDataMode',true);  %������ģʽ
        Msg = msgbox('���л����������ģʽ��');
        pause(1);
        if ishandle(Msg)
            delete(Msg);
        end
    end
else  % �����򿪴��ڡ���ťδ���£���ʾ���ȴ򿪴��ڣ���,�����𱾰�ť
    msgbox('���ȴ򿪴��ڣ�');
    set(hObject,'value',0);
    set(handles.lamb_mode,'cdata',getappdata(handles.figure1,'initData')); %��ʾ��Ϊ��ɫ
    setappdata(handles.figure1,'isDataMode',false);
end


% --- Executes on button press in pushbutton6.
%% Ԥ�ù���
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
%% ��������
function TimeClear_Callback(hObject, eventdata, handles)
if get(hObject,'value')
    %% ���߼���������
    acom=getappdata(handles.figure1, 'acom');
    str = get(acom, 'TransferStatus');
    if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
        c=strcat('#TIMECLEAR|',13);
        fprintf(acom,'%s',c,'async');
    end
    %% ���ݽ��ռ����ݴ����ʼ��
    dataFig = zeros(100,5);
    setappdata(handles.figure1,'dataFig',dataFig);
    setappdata(handles.figure1, 'numRec', 0);
    setappdata(handles.figure1,'strRec',[]);
    setappdata(handles.figure1, 'numPro', 0);
    setappdata(handles.figure1, 'dataPro', []);
end

% --- Executes on button press in pushbutton10.
%% ����ָ��
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
set(handles.holograph, 'value', 0, 'String', '����ȫϢ');
set(handles.start_rec, 'String', '��ʼ����', 'value', 0);

% --- Executes on button press in open_set.
%% �����������
function open_set_Callback(hObject, eventdata, handles)
% hObject    handle to open_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.xlsx';'*.xls'},'ѡ���ļ�');
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
%% ȫϵ��������
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
        set(handles.status,'String','���ڽ�������λ��У��');
    end
    setappdata(handles.figure1, 'isHolograph', true);
    set(hObject, 'String', 'ֹͣ', 'value', 1);
    set(handles.start_rec, 'String', 'ֹͣ����', 'value', 1);
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
    set(hObject, 'String', '����ȫϢ');
    setappdata(handles.figure1, 'isStopRec', true);
    set(handles.start_rec, 'String', '��ʼ����', 'value', 0);
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
