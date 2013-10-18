function varargout = SolarGUI10092013_proportional_aft(varargin)
% SOLARGUI10092013_PROPORTIONAL_AFT MATLAB code for SolarGUI10092013_proportional_aft.fig
%      SOLARGUI10092013_PROPORTIONAL_AFT, by itself, creates a new SOLARGUI10092013_PROPORTIONAL_AFT or raises the existing
%      singleton*.
%
%      H = SOLARGUI10092013_PROPORTIONAL_AFT returns the handle to a new SOLARGUI10092013_PROPORTIONAL_AFT or the handle to
%      the existing singleton*.
%
%      SOLARGUI10092013_PROPORTIONAL_AFT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOLARGUI10092013_PROPORTIONAL_AFT.M with the given input arguments.
%
%      SOLARGUI10092013_PROPORTIONAL_AFT('Property','Value',...) creates a new SOLARGUI10092013_PROPORTIONAL_AFT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SolarGUI10092013_proportional_aft_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SolarGUI10092013_proportional_aft_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SolarGUI10092013_proportional_aft

% Last Modified by GUIDE v2.5 11-Oct-2013 15:46:41

% Begin initialization code - DO NOT EDIT


gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SolarGUI10092013_proportional_aft_OpeningFcn, ...
                   'gui_OutputFcn',  @SolarGUI10092013_proportional_aft_OutputFcn, ...
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


% --- Executes just before SolarGUI10092013_proportional_aft is made visible.
function SolarGUI10092013_proportional_aft_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SolarGUI10092013_proportional_aft (see VARARGIN)
% Choose default command line output for SolarGUI10092013_proportional_aft
handles.output = hObject;
set(handles.btnExportData,'enable','off')
set(handles.btnClearAll,'enable','off')
set(findall(handles.uipanelGraph, '-property', 'enable'), 'enable', 'off')
set(findall(handles.uipanelControl, '-property', 'enable'), 'enable', 'off')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SolarGUI10092013_proportional_aft wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SolarGUI10092013_proportional_aft_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;clc

%add data slection
function btnImportData_Callback(hObject, eventdata, handles)
solar = PCdat;
switch(solar.index)
    case 1
        solar = getxlsm(solar)
    case 2
        solar = getxls(solar)
    case 3
        solar = getxlsx(solar)
    otherwise
end


handles.xOffset = 70;
handles.yOffset = 45;
handles.width = 1050;
handles.height = 500;

figure 
plotyy(solar.time, solar.vpc, solar.time, solar.vref); 
% axes(haxes(1))
xlabel('time(seconds)')
ylabel('Photovoltage|Reference voltage(volts)')
% axes(haxes(2))
% xlabel('time(seconds)')
% ylabel('Reference Voltage(volts)')
% set(line2,'LineStyle','--')
solar = solar.TTrangesel (solar)
close gcf

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


function btnClearAll_Callback(hObject, eventdata, handles)
set(handles.btnExportData,'enable','off')
set(handles.btnImportData,'enable','on')
deselection(handles)
set(findall(handles.uipanelGraph, '-property', 'enable'), 'enable', 'off')
set(findall(handles.uipanelControl, '-property', 'enable'), 'enable', 'off')
set(findall(handles.uipanelControl, '-property', 'enable'), 'visible', 'off')
handles.calc = 0;
handles.solar = 0;
clearplot = plot(0,0);

%value in excel is NaN,issue rose from calc
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
temp = 'A' + i - 1
range = sprintf('%c3', temp)
output = xlswrite('CalcData',handles.calc.(tabs{i}),'Sheet1',range)
end


function toggleSummary_Callback(hObject, eventdata, handles)
deselection(handles)
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
axes(haxes(1))
xlabel('time(seconds)')
ylabel('Illumination(suns)')
axes(haxes(2))
xlabel('time(seconds)')
ylabel('Photoconductance(Siemens)')
set(line2,'LineStyle','--')        
title('Illumination and Photoconductance')

%%%%
plotAugettodN = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [2*handles.xOffset+handles.width/2 2*handles.yOffset+handles.height/2 handles.width/2-handles.xOffset, handles.height/2-handles.yOffset]);
        
plot(plotAugettodN, handles.calc.dN, handles.calc.itau );
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
        
plot(plotTautodN, handles.calc.dN, handles.calc.tau );
xlabel('Minority Carrier,\DeltaN (cm^{-3})')
ylabel('Effective Lifetime, \tau_e_f_f (s^{-1})')
title('Minority Carrier Lifetime vs Minority Carrier Density')

function toggleRawData_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleRawData,'value', 1)
set(handles.toggleRawData,'BackgroundColor','y')
clearPlot(handles.uipanelPlot)
plotRaw = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width-40 handles.height]);
[haxes,line1,line2] =plotyy(handles.solar.time, handles.solar.vpc, handles.solar.time, handles.solar.vref); 
axes(haxes(1))
xlabel('time(seconds)')
ylabel('Photovoltage(volts)')
axes(haxes(2))
xlabel('time(seconds)')
ylabel('Reference Voltage(volts)')
set(line2,'LineStyle','--')

%AFT have removed select data





function toggleTauEffective_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleTauEffective,'value', 1)
set(handles.toggleTauEffective,'BackgroundColor','y')
clearPlot(handles.uipanelPlot)
plotTauEffective = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
        
loglog(plotTauEffective, handles.calc.dN, handles.calc.tau );
xlabel('Minority Carrier,\DeltaN (cm^{-3})')
ylabel('Effective Lifetime, \tau_e_f_f (s^{-1})')
xlim([10e10 10e16])


function toggleJoeSRV_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleJoeSRV,'value', 1)
set(handles.toggleJoeSRV,'BackgroundColor','y')
clearPlot(handles.uipanelPlot)
plotJoeSRV = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
        
loglog(plotJoeSRV, handles.calc.j0e, handles.calc.itau );
xlabel('Emitter Saturation Current Density, j0e (Acm^{-2})')
ylabel('Auger Lifetime, \tau_{Auger} (s^{-1})')
xlim([10e-17 10e-9])


function toggleTauBulk_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleTauBulk,'value', 1)
set(handles.toggleTauBulk,'BackgroundColor','y')
clearPlot(handles.uipanelPlot)
plotTauBulk = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
        
loglog(plotTauBulk, handles.calc.dN, handles.calc.tau_b );
xlabel('Minority Carrier,\DeltaN (cm^{-3})')
ylabel('Bulk Lifetime\tau_{bulk} (s^{-1})')
xlim([10e10 10e16])

function toggleJoeEffective_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleJoeEffective,'value', 1)
set(handles.toggleJoeEffective,'BackgroundColor','y')
clearPlot(handles.uipanelPlot)
plotJoeEffective = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
        
loglog(plotJoeEffective, handles.calc.dN, handles.calc.j0e );
xlabel('Minority Carrier,\DeltaN (cm^{-3})')
ylabel('Emitter Saturation Current Density, j0e (Acm^{-2})')
xlim([10e10 10e16])


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

function editWidth_Callback(hObject, eventdata, handles)
handles.solar.width = str2double(get(hObject,'String'));
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);




function editResistivity_Callback(hObject, eventdata, handles)
% hObject    handle to editResistivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResistivity as text
%        str2double(get(hObject,'String')) returns contents of editResistivity as a double

function editDopingError_Callback(hObject, eventdata, handles)
% hObject    handle to editDopingError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDopingError as text
%        str2double(get(hObject,'String')) returns contents of editDopingError as a double



% --- Executes on button press in checkboxWidthArray.
function checkboxWidthArray_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxWidthArray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxWidthArray



function editOpticalConst_Callback(hObject, eventdata, handles)
handles.solar.OC = str2double(get(hObject,'String'));
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);


function editOpticalConst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOpticalConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editOpticalConstError_Callback(hObject, eventdata, handles)
% hObject    handle to editOpticalConstError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOpticalConstError as text
%        str2double(get(hObject,'String')) returns contents of editOpticalConstError as a double


function editOpticalConstError_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOpticalConstError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in comboBoxBulkType.
function comboBoxBulkType_Callback(hObject, eventdata, handles)
%freeze either Nd or Na when after select type
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

% --- Executes on button press in checkboxVCalibration.
function checkboxVCalibration_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxVCalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxVCalibration


% --- Executes on button press in checkboxSCalibration.
function checkboxSCalibration_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSCalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSCalibration
function clearPlot( handles )
ah = findall(handles,'type','axes'); %find type "axes"(ploting graph) and kill all
if ~isempty(ah)
   delete(ah)
end

% --- Executes on selection change in comboBoxTauSetting.
function comboBoxTauSetting_Callback(hObject, eventdata, handles)
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);

% --- Executes on selection change in comboBoxMuSetting.
function comboBoxMuSetting_Callback(hObject, eventdata, handles)
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);

% --- Executes on selection change in comboBoxAugerSetting.
function comboBoxAugerSetting_Callback(hObject, eventdata, handles)
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);

function editNd_Callback(hObject, eventdata, handles)
handles.solar.N_D = str2double(get(hObject,'String'));
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);

function editNa_Callback(hObject, eventdata, handles)
handles.solar.N_A = str2double(get(hObject,'String'));
recalc( hObject, handles );
updatePlot(hObject, eventdata, handles);


function deselection(handles)

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
% Jowi ### original code ###
% set(handles.toggleSummary,'BackgroundColor', [1 1 1]*0.9)
% set(handles.toggleSummary,'value', 0)
% set(handles.toggleRawData,'BackgroundColor',0.9*[1 1 1])
% set(handles.toggleRawData,'value', 0)
% set(handles.toggleTauEffective,'BackgroundColor',0.9*[1 1 1])
% set(handles.toggleTauEffective,'value', 0)
% set(handles.toggleJoeSRV,'BackgroundColor',0.9*[1 1 1])
% set(handles.toggleJoeSRV,'value', 0)
% set(handles.toggleTauBulk,'BackgroundColor',0.9*[1 1 1])
% set(handles.toggleTauBulk,'value', 0)
% set(handles.toggleJoeEffective,'BackgroundColor',0.9*[1 1 1])
% set(handles.toggleJoeEffective,'value', 0)

function recalc( hObject,  handles )
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
guidata(hObject, handles);

function updatePlot(hObject, eventdata, handles)
a = get(handles.uipanelGraph, 'children');
b = get(a,'value');
c = find([b{1:length(b)}]==1);
switch(c)
    case 6
        toggleSummary_Callback(hObject, eventdata, handles);
    case 3
        toggleRawData_Callback(hObject, eventdata, handles);
    case 2
        toggleTauEffective_Callback(hObject, eventdata, handles);
    case 1 
        toggleJoeSRV_Callback(hObject, eventdata, handles);
    case 4
        toggleTauBulk_Callback(hObject, eventdata, handles);
    case 5
        toggleJoeEffective_Callback(hObject, eventdata, handles);
end

%-----------------------rubbish area ---------------------------------

function editWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editWidthError_Callback(hObject, eventdata, handles)
a= 'change edit'
% Hints: get(hObject,'String') returns contents of editWidthError as text
%        str2double(get(hObject,'String')) returns contents of editWidthError as a double



function editBhatA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBhatA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editDarkVoltage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDarkVoltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function editResistivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResistivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editDopingError_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDopingError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function comboBoxTauSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comboBoxTauSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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



function editBhatB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBhatB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBhatC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBhatC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editNd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editWidthError_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editWidthError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function comboBoxBulkType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comboBoxBulkType (see GCBO)
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


function comboBoxMuSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comboBoxMuSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10


% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton11


% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12


% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton13


% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14


% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton15


% --- Executes on button press in radiobutton16.
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton16


% --- Executes on button press in radiobutton17.
function radiobutton17_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton17


% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton18


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
% axes('units','pixels','position',[20 100 200 24],'visible','off')

%AFT these axes allow you to add latex text to the gui, the don't make it
%look nice in Guide but it works. 
set(hObject, 'visible', 'off')
text(0,0.5,'Average (\mu)','horiz','middle','vert','middle','FontSize', .001)
%  text(0,0.5,'I can display $\pi$','interpreter','latex','horiz','left','vert','middle')


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'visible', 'off')
text(0.5,0.5,'\Sigma','FontSize',8)
% Hint: place code in OpeningFcn to populate axes3


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'visible', 'off')
text(0,0.5,'\Omega /sq ','horiz','middle','vert','middle')
% Hint: place code in OpeningFcn to populate axes4
