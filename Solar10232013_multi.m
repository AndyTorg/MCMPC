function varargout = Solar10232013_multi(varargin)
% SOLAR10232013_MULTI MATLAB code for Solar10232013_multi.fig
%      SOLAR10232013_MULTI, by itself, creates a new SOLAR10232013_MULTI or raises the existing
%      singleton*.
%
%      H = SOLAR10232013_MULTI returns the handle to a new SOLAR10232013_MULTI or the handle to
%      the existing singleton*.
%
%      SOLAR10232013_MULTI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOLAR10232013_MULTI.M with the given input arguments.
%
%      SOLAR10232013_MULTI('Property','Value',...) creates a new SOLAR10232013_MULTI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Solar10232013_multi_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Solar10232013_multi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Solar10232013_multi

% Last Modified by GUIDE v2.5 01-Nov-2013 10:23:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Solar10232013_multi_OpeningFcn, ...
                   'gui_OutputFcn',  @Solar10232013_multi_OutputFcn, ...
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


% --- Executes just before Solar10232013_multi is made visible.
function Solar10232013_multi_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Solar10232013_multi (see VARARGIN)

% Choose default command line output for Solar10232013_multi
handles.output = hObject;
set(handles.btnExportData,'enable','off')
set(handles.btnClearAll,'enable','off')
set(handles.btnDataSelection,'enable','off')
set(handles.comboBoxObj,'enable','off')   
set(findall(handles.uipanelGraph, '-property', 'enable'), 'enable', 'off')
set(findall(handles.uipanelControl, '-property', 'enable'), 'enable', 'off')
handles.xAxis = 1;
handles.yAxis = 1;
handles.lineWidth = 1;
handles.markerStyle = 0;
set(handles.sliderWidth, 'value',handles.lineWidth )
% Update handles structure
guidata(hObject, handles);

function varargout = Solar10232013_multi_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function editWidth_Callback(hObject, eventdata, handles)
handles.solar.width = str2double(get(hObject,'String'));
guidata(hObject, handles);
recalc( hObject, handles );
handles = guidata(hObject); %need to use this line when the guidata(handle,dat) not working , freaking matlab
updatePlot(hObject, eventdata, handles);

function editResistivity_Callback(hObject, eventdata, handles)
% hObject    handle to editResistivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function editOpticalConst_Callback(hObject, eventdata, handles)
handles.solar.OC = str2double(get(hObject,'String'));
guidata(hObject, handles);
recalc( hObject, handles );
handles = guidata(hObject);
updatePlot(hObject, eventdata, handles);

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in comboBoxBulkType.
function comboBoxBulkType_Callback(hObject, eventdata, handles)
 contents=get(hObject,'value')
  if contents == 1
    handles.solar.N_D = str2double(get(handles.editNd,'String')); 
    handles.solar.N_A = handles.solar.N_D  ;
    handles.solar.N_D = 0;
    set(handles.editNa,'string',handles.solar.N_A)
    set(handles.editNd,'string',handles.solar.N_D)
    set(handles.editNd,'enable','off')
    set(handles.editNa,'enable','on')
 else
    handles.solar.N_A = str2double(get(handles.editNa,'String')); 
    handles.solar.N_D = handles.solar.N_A  ;
    handles.solar.N_A = 0;
    set(handles.editNa,'string',handles.solar.N_A)
    set(handles.editNd,'string',handles.solar.N_D)
    set(handles.editNa,'enable','off')
    set(handles.editNd,'enable','on')
  end
guidata(hObject, handles);
recalc( hObject, handles );
handles = guidata(hObject); %need to use this line when the guidata(handle,dat) not working , freaking matlab
updatePlot(hObject, eventdata, handles);

% --- Executes on button press in btnImportData.
function btnImportData_Callback(hObject, eventdata, handles)
solar = PCdat;

if (solar.multipleFiles)
    set(handles.comboBoxObj,'enable','on')    
    for i = 1 : (length(solar.file))
        switch(solar.index)
        case 1
            handles.data(i) = getxlsm(solar,i)
        case 2
            handles.data(i) = getxls(solar,i)
        case 3
            handles.data(i) = getxlsx(solar,i)
        otherwise
        end
    end
    solar = handles.data(1);        
else    
    set(handles.comboBoxObj,'enable','off')
    switch(solar.index)
        case 1
            solar = getxlsm(solar)
        case 2
            solar = getxls(solar)
        case 3
            solar = getxlsx(solar)
        otherwise
    end
    
end

%reminder: update comboBox
%reminder:changes comboBox = update window title, change obj to handles.solar



if (solar.multipleFiles)
    temp = sprintf('solar @ %s',handles.data(1).file{1});
    set(gcf,'name',temp);
    set(handles.comboBoxObj,'string',handles.data(1).file)
else
    temp = sprintf('solar @ %s',solar.file);
    set(gcf,'name',temp);
end
set(handles.btnDataSelection,'enable','on')
handles.xOffset = 70;
handles.yOffset = 45;
set(handles.uipanelPlot,'Units','pixels')
temp = get(handles.uipanelPlot,'Position');

handles.width = temp(3)*0.9;
handles.height = temp(4)*0.9;

set(handles.editBhatA,'string',solar.a)
set(handles.editBhatB,'string',solar.b)
set(handles.editBhatC,'string',solar.c)
set(handles.editDarkVoltage,'string',solar.vdark)
set(handles.editOpticalConst,'string',solar.OC)
set(handles.editWidth,'string',solar.width)
set(handles.btnImportData,'enable','off')
set(handles.btnClearAll,'enable','on')
% all are calculation, going to consolidate into one function
calc.cond = PC_calc.conductivityOFF(solar.vpc, solar.vdark, solar.a, solar.b, solar.c);
list=get(handles.comboBoxMuSetting,'String');
val=get(handles.comboBoxMuSetting,'Value');
handles.mu_mode = list{val};
guidata(hObject, handles);
calc.dN = PC_calc.carriers(calc.cond, solar.width, solar.N_A, solar.N_D, handles.mu_mode);
%using gref for vref_to_sun???
[calc.suns, calc.gen] = PC_calc.generation(solar.vref, solar.gref, solar.OC, solar.width);
list=get(handles.comboBoxTauSetting,'String');
val=get(handles.comboBoxTauSetting,'Value');
handles.tau_mode = list{val};
guidata(hObject, handles);
calc.tau = PC_calc.lifetime(solar.time, calc.dN, calc.gen, handles.tau_mode);
list=get(handles.comboBoxAugerSetting,'String');
val=get(handles.comboBoxAugerSetting,'Value');
handles.auger_mode = list{val};
guidata(hObject, handles);
calc.itau = PC_calc.inversetau (calc.dN, calc.tau, solar.N_A, solar.N_D, handles.auger_mode);

[calc.j0e, calc.tau_b] = PC_calc.emittersat(calc.dN, calc.itau, solar.width, solar.N_A, solar.N_D);
% itau = SRV??

handles.calc = calc;
guidata(hObject, handles);
handles.solar = solar;% pass obj solar data to the GUI handles, so callback can share data
guidata(hObject, handles); % something like submission of data to Obj of GUI from hanldes
toggleRawData_Callback(hObject, eventdata, handles)
set(handles.btnExportData,'enable','on')
set(handles.btnClearAll,'enable','on')
set(findall(handles.uipanelGraph, '-property', 'enable'), 'enable', 'on')
set(findall(handles.uipanelControl, '-property', 'enable'), 'enable', 'on')
set(findall(handles.uipanelControl, '-property', 'enable'), 'visible', 'on')
set(handles.btnExportData,'enable','on')
set(handles.editNa,'string',handles.solar.N_A)
set(handles.editNd,'string',handles.solar.N_D)
if handles.solar.N_D > 0    
    set(handles.editNa,'enable','off')
    set(handles.comboBoxBulkType,'value',2)
else    
    set(handles.editNd,'enable','off')
    set(handles.comboBoxBulkType,'value',1)
end

% --- Executes on button press in btnClearAll.
function btnClearAll_Callback(hObject, eventdata, handles)
set(handles.btnExportData,'enable','off')
set(handles.btnImportData,'enable','on')
graphDeselection(handles)
set(findall(handles.uipanelGraph, '-property', 'enable'), 'enable', 'off')
set(findall(handles.uipanelControl, '-property', 'enable'), 'enable', 'off')
set(findall(handles.uipanelControl, '-property', 'enable'), 'visible', 'off')
handles.calc = 0;
handles.solar = 0;


% --- Executes on button press in btnExportData.
function btnExportData_Callback(hObject, eventdata, handles)
title = {  handles.mu_mode handles.tau_mode handles.auger_mode }
output = xlswrite('CalcData',title)
tabs = {'time' 'cond' 'dN' 'suns' 'gen' 'tau' 'itau' 'j0e' 'tau_b'}
[ rows columms ] = size(tabs)
temp = 'A' + columms - 1;
range = sprintf('A2:%c2', temp)
output = xlswrite('CalcData',tabs,range)
% method1: failed, value[] will create NaN in excel
% values = [handles.solar.time handles.calc.cond handles.calc.dN handles.calc.suns handles.calc.gen handles.calc.tau handles.calc.itau handles.calc.j0e handles.calc.tau_b]
% [ rows columms ] = size(values)
% temp = 'A' + columms - 1;
% range = sprintf('A3:%c3', temp)
% output = xlswrite('CalcData',values)
% method2:still having NaN in spreadsheet
output = xlswrite('CalcData',handles.solar.time,'Sheet1','A3')
for i = 2:length(tabs)
temp = 'A' + i - 1;
range = sprintf('%c3', temp);
output = xlswrite('CalcData',handles.calc.(tabs{i}),'Sheet1',range)
end

% --- Executes on button press in toggleSummary.
function toggleSummary_Callback(hObject, eventdata, handles)
graphDeselection(handles)
set(handles.toggleSummary,'value', 1)
%AFT ## style modification##
set(handles.toggleSummary,'BackgroundColor',[1 1 0])
%original
% set(handles.toggleSummary,'BackgroundColor',[1 1 0]*.95)
clearPlot(handles.uipanelPlot)
plotSuntoTime = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset 2*handles.yOffset+handles.height/2 handles.width/2-handles.xOffset, handles.height/2-handles.yOffset]);
        
[haxes,line1,line2] =plotyy(handles.solar.time, handles.calc.suns, handles.solar.time, handles.calc.cond); 
if (handles.xAxis)
    if (handles.yAxis)
        set(haxes(1),'XScale','log','YScale','log'); 
        set(haxes(2),'XScale','log','YScale','log'); 
    else
        set(haxes(1),'XScale','log');
        set(haxes(2),'XScale','log');
    end
else
    if (handles.yAxis)
        set(haxes(1),'YScale','log');
        set(haxes(2),'YScale','log');
    else
        set(haxes(1),'XScale','linear','YScale','linear');
        set(haxes(2),'XScale','linear','YScale','linear');
    end
end 

if (handles.markerStyle)
    set(line1, 'Marker','*')
    set(line1, 'linestyle','none')
    set(line2, 'Marker','*')
    set(line2, 'linestyle','none')
else
    set(line1, 'linestyle','-')
    set(line1, 'Marker','none' )
    set(line2, 'Marker','none')
    set(line2, 'linestyle','-')
end


set(line1,'linewidth',handles.lineWidth);
set(line2,'linewidth',handles.lineWidth);
axes(haxes(1))
xlabel('time(seconds)')
ylabel('Illumination(suns)')
axes(haxes(2))
xlabel('time(seconds)')
ylabel('Photoconductance(Siemens)')
       
title('Illumination and Photoconductance')

%%%%
plotAugettodN = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [2*handles.xOffset+handles.width/2 2*handles.yOffset+handles.height/2 handles.width/2-handles.xOffset, handles.height/2-handles.yOffset]);
if (handles.xAxis)
    if (handles.yAxis)
        h = loglog(plotAugettodN, handles.calc.dN, handles.calc.itau )   ;     
    else
        h = semilogx( handles.calc.dN, handles.calc.itau);
    end
else
    if (handles.yAxis)
        h = semilogy(handles.calc.dN, handles.calc.itau);
    else
        h = plot(plotAugettodN, handles.calc.dN, handles.calc.itau );
    end
end    

if (handles.markerStyle)
    set(h,'Marker','*')
    set(h,'linestyle','none')
else
    set(h,'linestyle','-')
    set(h,'Marker','none' )
end
%plot(plotAugettodN, handles.calc.dN, handles.calc.itau );
xlabel('Minority Carrier,\DeltaN (cm^{-3})')
ylabel('Auger Lifetime, \tau_{Auger} (s^{-1})')
title('Inverse Lifetime vs. Carrier Density')

%%%
plotSuntoVoc = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width/2-handles.xOffset, handles.height/2-handles.yOffset]);
        
%plot(plotSuntoVoc, handles.calc.dN, handles.calc.suns );
xlabel('Implied Open Circuit Voltage/v')
ylabel('Illumination/suns')
title('Implied V_{oc}')

%%%%
plotTautodN = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [2*handles.xOffset+handles.width/2 handles.yOffset handles.width/2-handles.xOffset, handles.height/2-handles.yOffset]);
if (handles.xAxis)
    if (handles.yAxis)
        h = loglog( plotTautodN, handles.calc.dN, handles.calc.tau );        
    else
        h = semilogx( handles.calc.dN, handles.calc.tau);
    end
else
    if (handles.yAxis)
        h = semilogy(handles.calc.dN, handles.calc.tau);
    else
        h = plot(plotTautodN, handles.calc.dN, handles.calc.tau);
    end
end          

if (handles.markerStyle)
    set(h,'Marker','*')
    set(h,'linestyle','none')
else
    set(h,'linestyle','-')
    set(h,'Marker','none' )
end


set(h,'linewidth',handles.lineWidth);
%loglog(plotTautodN, handles.calc.dN, handles.calc.tau );
xlabel('Minority Carrier,\DeltaN (cm^{-3})')
ylabel('Effective Lifetime, \tau_e_f_f (s^{-1})')
title('Minority Carrier Lifetime vs Minority Carrier Density')
handles.toggle = 1;
guidata(hObject, handles);

% --- Executes on button press in toggleRawData.
function toggleRawData_Callback(hObject, eventdata, handles)
graphDeselection(handles)
set(handles.toggleRawData,'value', 1)
set(handles.toggleRawData,'BackgroundColor','y')
clearPlot(handles.uipanelPlot)
plotRaw = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width-40 handles.height]);
[haxes,line1,line2] =plotyy(handles.solar.time, handles.solar.vpc, handles.solar.time, handles.solar.vref); 
if (handles.xAxis)
    if (handles.yAxis)
        set(haxes(1),'XScale','log','YScale','log'); 
        set(haxes(2),'XScale','log','YScale','log'); 
    else
        set(haxes(1),'XScale','log');
        set(haxes(2),'XScale','log');
    end
else
    if (handles.yAxis)
        set(haxes(1),'YScale','log');
        set(haxes(2),'YScale','log');
    else
        set(haxes(1),'XScale','linear','YScale','linear');
        set(haxes(2),'XScale','linear','YScale','linear');
    end
end 

if (handles.markerStyle)
    set(line1, 'Marker','*')
    set(line1, 'linestyle','none')
    set(line2, 'Marker','*')
    set(line2, 'linestyle','none')
else
    set(line1, 'linestyle','-')
    set(line1, 'Marker','none' )
    set(line2, 'Marker','none')
    set(line2, 'linestyle','-')
end


set(line1,'linewidth',handles.lineWidth);
set(line2,'linewidth',handles.lineWidth);
axes(haxes(1))
xlabel('time(seconds)')
ylabel('Photovoltage(volts)')
axes(haxes(2))
xlabel('time(seconds)')
ylabel('Reference Voltage(volts)')
ylim([-1e-3 1e-3])

handles.toggle = 2;
guidata(hObject, handles);


% --- Executes on button press in toggleTauEffective.
function toggleTauEffective_Callback(hObject, eventdata, handles)
graphDeselection(handles)
set(handles.toggleTauEffective,'value', 1)
set(handles.toggleTauEffective,'BackgroundColor','y')
clearPlot(handles.uipanelPlot)
plotTauEffective = axes('Parent', handles.uipanelPlot, ...
             'Units', 'pixels', ...
             'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
        
if (handles.xAxis)
    if (handles.yAxis)
        h = loglog(plotTauEffective, handles.calc.dN, handles.calc.tau );        
    else
        h = semilogx( handles.calc.dN, handles.calc.tau);
    end
else
    if (handles.yAxis)
        h = semilogy( handles.calc.dN, handles.calc.tau);
    else
        h = plot(plotTauEffective, handles.calc.dN, handles.calc.tau);
    end
end 
if (handles.markerStyle)
    set(h,'Marker','*')
    set(h,'linestyle','none')
else
    set(h,'linestyle','-')
    set(h,'Marker','none' )
end


set(h,'linewidth',handles.lineWidth);
% loglog(plotTauEffective, handles.calc.dN, handles.calc.tau );
ylabel('Effective Lifetime, \tau_e_f_f (s^{-1})')
xlabel('Minority Carrier,\DeltaN (cm^{-3})')
%xlim([10e10 10e16])
handles.toggle = 3;
guidata(hObject, handles);



% --- Executes on button press in toggleJoeSRV.
function toggleJoeSRV_Callback(hObject, eventdata, handles)
graphDeselection(handles)
set(handles.toggleJoeSRV,'value', 1)
set(handles.toggleJoeSRV,'BackgroundColor','y')
clearPlot(handles.uipanelPlot)
plotJoeSRV = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
if (handles.xAxis)
    if (handles.yAxis)
        h = loglog(plotJoeSRV, handles.calc.j0e, handles.calc.itau) ;       
    else
        h = semilogx( handles.calc.j0e, handles.calc.itau);
    end
else
    if (handles.yAxis)
        h = semilogy( handles.calc.j0e, handles.calc.itau );
    else
        h = plot(plotJoeSRV, handles.calc.j0e, handles.calc.itau);
    end
end             

if (handles.markerStyle)
    set(h,'Marker','*')
    set(h,'linestyle','none')
else
    set(h,'linestyle','-')
    set(h,'Marker','none' )
end


set(h,'linewidth',handles.lineWidth);
%loglog(plotJoeSRV, handles.calc.j0e, handles.calc.itau );
xlabel('Emitter Saturation Current Density, j0e (Acm^{-2})')
ylabel('Auger Lifetime, \tau_{Auger} (s^{-1})')
%xlim([10e-17 10e-9])
handles.toggle = 4;
guidata(hObject, handles);


% --- Executes on button press in toggleTauBulk.
function toggleTauBulk_Callback(hObject, eventdata, handles)
graphDeselection(handles)
set(handles.toggleTauBulk,'value', 1)
set(handles.toggleTauBulk,'BackgroundColor','y')
clearPlot(handles.uipanelPlot)
plotTauBulk = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
if (handles.xAxis)
    if (handles.yAxis)
        h = loglog(plotTauBulk, handles.calc.dN, handles.calc.tau_b);        
    else
        h = semilogx(handles.calc.dN, handles.calc.tau_b);
    end
else
    if (handles.yAxis)
        h = semilogy(handles.calc.dN, handles.calc.tau_b);
    else
        h = plot(plotTauBulk, handles.calc.dN, handles.calc.tau_b);
    end
end              
if (handles.markerStyle)
    set(h,'Marker','*')
    set(h,'linestyle','none')
else
    set(h,'linestyle','-')
    set(h,'Marker','none' )
end


set(h,'linewidth',handles.lineWidth);
%loglog(plotTauBulk, handles.calc.dN, handles.calc.tau_b );
xlabel('Minority Carrier,\DeltaN (cm^{-3})')
ylabel('Bulk Lifetime\tau_{bulk} (s^{-1})')
%xlim([10e10 10e16])
handles.toggle = 5;
guidata(hObject, handles);


% --- Executes on button press in toggleJoeEffective.
function toggleJoeEffective_Callback(hObject, eventdata, handles)
graphDeselection(handles)
set(handles.toggleJoeEffective,'value', 1)
set(handles.toggleJoeEffective,'BackgroundColor','y')
clearPlot(handles.uipanelPlot)
plotJoeEffective = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);

if (handles.xAxis)
    if (handles.yAxis)
        h = loglog(plotJoeEffective, handles.calc.dN, handles.calc.j0e) ;       
    else
        h = semilogx( handles.calc.dN, handles.calc.j0e);
    end
else
    if (handles.yAxis)
       h = semilogy( handles.calc.dN, handles.calc.j0e);
    else
       h = plot(plotJoeEffective, handles.calc.dN, handles.calc.j0e );
    end
end   

if (handles.markerStyle)
    set(h,'Marker','*')
    set(h,'linestyle','none')
else
    set(h,'linestyle','-')
    set(h,'Marker','none' )
end


set(h,'linewidth',handles.lineWidth);
%loglog(plotJoeEffective, handles.calc.dN, handles.calc.j0e );
xlabel('Minority Carrier,\DeltaN (cm^{-3})')
ylabel('Emitter Saturation Current Density, j0e (Acm^{-2})')
%xlim([10e10 10e16])
handles.toggle = 6;
guidata(hObject, handles);


function editNd_Callback(hObject, eventdata, handles)
handles.solar.N_D = str2double(get(hObject,'String'));
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);

function editNa_Callback(hObject, eventdata, handles)
handles.solar.N_A = str2double(get(hObject,'String'));
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);


% --- Executes on selection change in comboBoxMuSetting.
function comboBoxMuSetting_Callback(hObject, eventdata, handles)
guidata(hObject, handles);
recalc( hObject, handles );
handles = guidata(hObject); %need to use this line when the guidata(handle,dat) not working , freaking matlab
updatePlot(hObject, eventdata, handles);


function comboBoxAugerSetting_Callback(hObject, eventdata, handles)
guidata(hObject, handles);
recalc( hObject, handles );
handles = guidata(hObject); %need to use this line when the guidata(handle,dat) not working , freaking matlab
updatePlot(hObject, eventdata, handles);

function comboBoxTauSetting_Callback(hObject, eventdata, handles)
guidata(hObject, handles);
recalc( hObject, handles );
handles = guidata(hObject); %need to use this line when the guidata(handle,dat) not working , freaking matlab
updatePlot(hObject, eventdata, handles);

function editDarkVoltage_Callback(hObject, eventdata, handles)
handles.solar.vdark = str2double(get(hObject,'String'));
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);

function editBhatA_Callback(hObject, eventdata, handles)
handles.solar.a = str2double(get(hObject,'String'));
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);

function editBhatB_Callback(hObject, eventdata, handles)
handles.solar.b = str2double(get(hObject,'String'));
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);

function editBhatC_Callback(hObject, eventdata, handles)
handles.solar.c = str2double(get(hObject,'String'));
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);

function checkboxSCalibration_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSCalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function checkboxVCalibration_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxVCalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function editDopingError_Callback(hObject, eventdata, handles)
% hObject    handle to editDopingError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function radiobuttonLine_Callback(hObject, eventdata, handles)
handles.markerStyle = 0;
guidata(hObject, handles);
updatePlot(hObject, eventdata, handles);

function radiobuttonMarker_Callback(hObject, eventdata, handles)
handles.markerStyle = 1;
guidata(hObject, handles);
updatePlot(hObject, eventdata, handles);

function sliderWidth_Callback(hObject, eventdata, handles)
handles.lineWidth = get(handles.sliderWidth,'value');
guidata(hObject, handles);
updatePlot(hObject, eventdata, handles);

function radiobuttonLinearX_Callback(hObject, eventdata, handles)
handles.xAxis = 0;
guidata(hObject, handles);
updatePlot(hObject, eventdata, handles);

% --- Executes on button press in radiobuttonLogX.
function radiobuttonLogX_Callback(hObject, eventdata, handles)
handles.xAxis = 1;
guidata(hObject, handles);
updatePlot(hObject, eventdata, handles);


% --- Executes on button press in radiobuttonLinearY.
function radiobuttonLinearY_Callback(hObject, eventdata, handles)
handles.yAxis = 0;
guidata(hObject, handles);
updatePlot(hObject, eventdata, handles);


% --- Executes on button press in radiobuttonLogY.
function radiobuttonLogY_Callback(hObject, eventdata, handles)
handles.yAxis = 1;
guidata(hObject, handles);
updatePlot(hObject, eventdata, handles);

function btnDataSelection_Callback(hObject, eventdata, handles)
figure 
solar = handles.solar;
plotyy(solar.time, solar.vpc, solar.time, solar.vref); 
% axes(haxes(1))
xlabel('time(seconds)')
ylabel('Photovoltage|Reference voltage(volts)')
% axes(haxes(2))
% xlabel('time(seconds)')
% ylabel('Reference Voltage(volts)')
% set(line2,'LineStyle','--')
solar = solar.TTrangesel (solar);
close gcf
handles.solar = solar;
guidata(hObject, handles);
handles = guidata(hObject);
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);



% --- Executes on selection change in comboBoxObj.
function comboBoxObj_Callback(hObject, eventdata, handles)
n = get(handles.comboBoxObj,'value')
solar = handles.data(n)
temp = sprintf('solar @ %s',handles.solar.file{n});
set(gcf,'name',temp);


set(handles.editBhatA,'string',solar.a)
set(handles.editBhatB,'string',solar.b)
set(handles.editBhatC,'string',solar.c)
set(handles.editDarkVoltage,'string',solar.vdark)
set(handles.editOpticalConst,'string',solar.OC)
set(handles.editWidth,'string',solar.width)
set(handles.btnImportData,'enable','off')
set(handles.btnClearAll,'enable','on')
% all are calculation, going to consolidate into one function
calc.cond = PC_calc.conductivityOFF(solar.vpc, solar.vdark, solar.a, solar.b, solar.c);
list=get(handles.comboBoxMuSetting,'String');
val=get(handles.comboBoxMuSetting,'Value');
handles.mu_mode = list{val};
guidata(hObject, handles);
calc.dN = PC_calc.carriers(calc.cond, solar.width, solar.N_A, solar.N_D, handles.mu_mode);
%using gref for vref_to_sun???
[calc.suns, calc.gen] = PC_calc.generation(solar.vref, solar.gref, solar.OC, solar.width);
list=get(handles.comboBoxTauSetting,'String');
val=get(handles.comboBoxTauSetting,'Value');
handles.tau_mode = list{val};
guidata(hObject, handles);
calc.tau = PC_calc.lifetime(solar.time, calc.dN, calc.gen, handles.tau_mode);
list=get(handles.comboBoxAugerSetting,'String');
val=get(handles.comboBoxAugerSetting,'Value');
handles.auger_mode = list{val};
guidata(hObject, handles);
calc.itau = PC_calc.inversetau (calc.dN, calc.tau, solar.N_A, solar.N_D, handles.auger_mode);

[calc.j0e, calc.tau_b] = PC_calc.emittersat(calc.dN, calc.itau, solar.width, solar.N_A, solar.N_D);
% itau = SRV??

handles.calc = calc;
guidata(hObject, handles);
handles.solar = solar;% pass obj solar data to the GUI handles, so callback can share data
guidata(hObject, handles); % something like submission of data to Obj of GUI from hanldes
handles = guidata(hObject);
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);


function editMovingAverage_Callback(hObject, eventdata, handles)
temp = get(handles.radiobuttonMovingAverage,'value');
handles = guidata(hObject);
old = handles.oldData;

if (temp)
    temp = str2double(get(hObject,'String'));
    movingAverage(old, temp, hObject, handles )
    handles = guidata(hObject);
    handles.solar.vref = handles.newData;
    guidata(hObject, handles); % something like submission of data to Obj of GUI from hanldes
    handles = guidata(hObject);
    recalc( hObject, handles );
    updatePlot(hObject, eventdata, handles);    
end

function editLowPass_Callback(hObject, eventdata, handles)
% temp = get(handles.radiobuttonLowPass,'value');
% handles = guidata(hObject);
% old = handles.oldData;
% if (temp)
%     temp = str2double(get(hObject,'String'));
%     d=fdesign.lowpass('N,Fc',10,temp,48000);
%     designmethods(d); 
%     Hd = design(d);
%     fvtool(Hd);
%     handles.solar.vref = filter(Hd,old);
%     guidata(hObject, handles); % something like submission of data to Obj of GUI from hanldes
%     handles = guidata(hObject);
%     recalc( hObject, handles );
%     updatePlot(hObject, eventdata, handles); 
% end




function radiobuttonMovingAverage_Callback(hObject, eventdata, handles)
handles.oldData = handles.solar.vref;
guidata(hObject, handles);


% --- Executes on button press in radiobuttonLowPass.
function radiobuttonLowPass_Callback(hObject, eventdata, handles)
handles.oldData = handles.solar.vref;
guidata(hObject, handles);


function btnTest_Callback(hObject, eventdata, handles)
temp = get(handles.editMovingAverage,'value')

function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function clearPlot( handles )
ah = findall(handles,'type','axes'); %find type "axes"(ploting graph) and kill all
if ~isempty(ah)
   delete(ah)
end

function graphDeselection(handles)
% AFT have changed in order to have yellow buttons
set(handles.toggleSummary,'BackgroundColor', 'y')
set(handles.toggleSummary,'value', 0)
set(handles.toggleRawData,'BackgroundColor','y')
set(handles.toggleRawData,'value', 0)
set(handles.toggleTauEffective,'BackgroundColor','y')
set(handles.toggleTauEffective,'value', 0)
set(handles.toggleJoeSRV,'BackgroundColor','y')
set(handles.toggleJoeSRV,'value', 0)
set(handles.toggleTauBulk,'BackgroundColor','y')
set(handles.toggleTauBulk,'value', 0)
set(handles.toggleJoeEffective,'BackgroundColor','y')
set(handles.toggleJoeEffective,'value', 0)

function recalc( hObject, handles )
handles.calc.cond = PC_calc.conductivityOFF(handles.solar.vpc, handles.solar.vdark, handles.solar.a, handles.solar.b, handles.solar.c);
list=get(handles.comboBoxMuSetting,'String');
val=get(handles.comboBoxMuSetting,'Value');
mu_mode = list{val}
handles.calc.dN = PC_calc.carriers(handles.calc.cond, handles.solar.width, handles.solar.N_A, handles.solar.N_D, mu_mode);
%using gref for vref_to_sun???
[handles.calc.suns, handles.calc.gen] = PC_calc.generation(handles.solar.vref, handles.solar.gref, handles.solar.OC, handles.solar.width);
list=get(handles.comboBoxTauSetting,'String');
val=get(handles.comboBoxTauSetting,'Value');
mode = list{val}
handles.calc.tau = PC_calc.lifetime(handles.solar.time, handles.calc.dN, handles.calc.gen, mode);
list=get(handles.comboBoxAugerSetting,'String');
val=get(handles.comboBoxAugerSetting,'Value');
mode = list{val}
handles.calc.itau = PC_calc.inversetau (handles.calc.dN, handles.calc.tau, handles.solar.N_A, handles.solar.N_D, mode);
[handles.calc.j0e, handles.calc.tau_b] = PC_calc.emittersat(handles.calc.dN, handles.calc.itau, handles.solar.width, handles.solar.N_A, handles.solar.N_D);
% itau = SRV??
sprintf('recalc')
guidata(hObject, handles);



function updatePlot(hObject, eventdata, handles)
temp = handles.toggle;
switch( temp )
    case 1
        toggleSummary_Callback(hObject, eventdata, handles);
    case 2
        toggleRawData_Callback(hObject, eventdata, handles);
    case 3
        toggleTauEffective_Callback(hObject, eventdata, handles);
    case 4 
        toggleJoeSRV_Callback(hObject, eventdata, handles);
    case 5
        toggleTauBulk_Callback(hObject, eventdata, handles);
    case 6
        toggleJoeEffective_Callback(hObject, eventdata, handles);
end
sprintf('updateplot')

function movingAverage(oldData, window, hObject, handles )
    for i = 1:length(oldData)
        temp = 0
        for j = 0 : window
            if ((i+j)<=length(oldData))
            temp = temp + oldData(i + j)
            end
        end
        if window > 0
            handles.newData(i) = temp / window;
        end
    end
 guidata(hObject, handles);   
%-------------------------------------------------------------------------------------------------------


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editResistivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResistivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editOpticalConst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOpticalConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function comboBoxBulkType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comboBoxBulkType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editNd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editDopingError_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDopingError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function comboBoxAugerSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comboBoxAugerSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function sliderWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function comboBoxTauSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comboBoxTauSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editDarkVoltage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDarkVoltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editBhatA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBhatA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editBhatB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBhatB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editBhatC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBhatC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function comboBoxObj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comboBoxObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editNa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function comboBoxMuSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comboBoxMuSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editMovingAverage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMovingAverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function editLowPass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLowPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
