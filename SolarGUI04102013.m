function varargout = SolarGUI04102013(varargin)
% SOLARGUI04102013 MATLAB code for SolarGUI04102013.fig
%      SOLARGUI04102013, by itself, creates a new SOLARGUI04102013 or raises the existing
%      singleton*.
%
%      H = SOLARGUI04102013 returns the handle to a new SOLARGUI04102013 or the handle to
%      the existing singleton*.
%
%      SOLARGUI04102013('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOLARGUI04102013.M with the given input arguments.
%
%      SOLARGUI04102013('Property','Value',...) creates a new SOLARGUI04102013 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SolarGUI04102013_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SolarGUI04102013_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SolarGUI04102013

% Last Modified by GUIDE v2.5 04-Oct-2013 07:41:02

% Begin initialization code - DO NOT EDIT


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SolarGUI04102013_OpeningFcn, ...
                   'gui_OutputFcn',  @SolarGUI04102013_OutputFcn, ...
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


% --- Executes just before SolarGUI04102013 is made visible.
function SolarGUI04102013_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SolarGUI04102013 (see VARARGIN)
% Choose default command line output for SolarGUI04102013
handles.output = hObject;
set(handles.btnExportData,'enable','off')
set(handles.btnClearAll,'enable','off')
set(findall(handles.uipanelGraph, '-property', 'enable'), 'enable', 'off')
set(findall(handles.uipanelControl, '-property', 'enable'), 'enable', 'off')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SolarGUI04102013 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SolarGUI04102013_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;clc

function figure1_CreateFcn(hObject, eventdata, handles)
%add data slection
function btnImportData_Callback(hObject, eventdata, handles)
clear all
close all
solar = PCdat;
solar = getxlsm(solar)
handles.xOffset = 70;
handles.yOffset = 45;
handles.width = 1110;
handles.height = 550;


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
set(handles.toggleSummary,'BackgroundColor','w')
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
set(handles.toggleRawData,'BackgroundColor','w')
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

[pointslist,xselect,yselect] = selectdata( 'Label' ,'on' , 'SelectionMode','Rect','Verify','on')
 


function toggleTauEffective_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleTauEffective,'value', 1)
set(handles.toggleTauEffective,'BackgroundColor','w')
clearPlot(handles.uipanelPlot)
plotTauEffective = axes('Parent', handles.uipanelPlot, ...
             'Units', 'pixels', ...
             'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
handles.calc.dN        
loglog(plotTauEffective, handles.calc.dN, handles.calc.tau );
xlabel('Minority Carrier,\DeltaN (cm^{-3})')
ylabel('Effective Lifetime, \tau_e_f_f (s^{-1})')

function toggleJoeSRV_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleJoeSRV,'value', 1)
set(handles.toggleJoeSRV,'BackgroundColor','w')
clearPlot(handles.uipanelPlot)
plotJoeSRV = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
        
loglog(plotJoeSRV, handles.calc.j0e, handles.calc.itau );
xlabel('Emitter Saturation Current Density, j0e (Acm^{-2})')
ylabel('Auger Lifetime, \tau_{Auger} (s^{-1})')

function toggleTauBulk_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleTauBulk,'value', 1)
set(handles.toggleTauBulk,'BackgroundColor','w')
clearPlot(handles.uipanelPlot)
plotTauBulk = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
        
loglog(plotTauBulk, handles.calc.dN, handles.calc.tau_b );
xlabel('Minority Carrier,\DeltaN (cm^{-3})')
ylabel('Bulk Lifetime\tau_{bulk} (s^{-1})')

function toggleJoeEffective_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleJoeEffective,'value', 1)
set(handles.toggleJoeEffective,'BackgroundColor','w')
clearPlot(handles.uipanelPlot)
plotJoeEffective = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
        
loglog(plotJoeEffective, handles.calc.dN, handles.calc.j0e );
xlabel('Minority Carrier,\DeltaN (cm^{-3})')
ylabel('Emitter Saturation Current Density, j0e (Acm^{-2})')


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

function editWidth_Callback(hObject, eventdata, handles)
handles.solar.width = str2double(get(hObject,'String'));
recalc( hObject, handles );


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

recalc( hObject,handles );


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
 
function editDarkVoltage_Callback(hObject, eventdata, handles)
handles.solar.vdark = str2double(get(hObject,'String'));
recalc( hObject, handles );

function editBhatA_Callback(hObject, eventdata, handles)
handles.solar.a = str2double(get(hObject,'String'));
recalc( hObject,  handles );

function editBhatB_Callback(hObject, eventdata, handles)
handles.solar.b = str2double(get(hObject,'String'));
recalc( hObject, handles );


function editBhatC_Callback(hObject, eventdata, handles)
handles.solar.c = str2double(get(hObject,'String'));
recalc( hObject, handles );

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

% --- Executes on selection change in comboBoxMuSetting.
function comboBoxMuSetting_Callback(hObject, eventdata, handles)
recalc( hObject, handles );

% --- Executes on selection change in comboBoxAugerSetting.
function comboBoxAugerSetting_Callback(hObject, eventdata, handles)
recalc( hObject, handles );

function editNd_Callback(hObject, eventdata, handles)
handles.solar.N_D = str2double(get(hObject,'String'));
recalc( hObject, handles );


function editNa_Callback(hObject, eventdata, handles)
handles.solar.N_A = str2double(get(hObject,'String'));
recalc( hObject, handles );


function deselection(handles)
set(handles.toggleSummary,'BackgroundColor', [1 1 1]*0.9)
set(handles.toggleSummary,'value', 0)
set(handles.toggleRawData,'BackgroundColor',0.9*[1 1 1])
set(handles.toggleRawData,'value', 0)
set(handles.toggleTauEffective,'BackgroundColor',0.9*[1 1 1])
set(handles.toggleTauEffective,'value', 0)
set(handles.toggleJoeSRV,'BackgroundColor',0.9*[1 1 1])
set(handles.toggleJoeSRV,'value', 0)
set(handles.toggleTauBulk,'BackgroundColor',0.9*[1 1 1])
set(handles.toggleTauBulk,'value', 0)
set(handles.toggleJoeEffective,'BackgroundColor',0.9*[1 1 1])
set(handles.toggleJoeEffective,'value', 0)

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


