function varargout = SolarGUI16092013(varargin)
% SOLARGUI16092013 MATLAB code for SolarGUI16092013.fig
%      SOLARGUI16092013, by itself, creates a new SOLARGUI16092013 or raises the existing
%      singleton*.
%
%      H = SOLARGUI16092013 returns the handle to a new SOLARGUI16092013 or the handle to
%      the existing singleton*.
%
%      SOLARGUI16092013('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOLARGUI16092013.M with the given input arguments.
%
%      SOLARGUI16092013('Property','Value',...) creates a new SOLARGUI16092013 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SolarGUI16092013_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SolarGUI16092013_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SolarGUI16092013

% Last Modified by GUIDE v2.5 26-Sep-2013 23:08:23

% Begin initialization code - DO NOT EDIT


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SolarGUI16092013_OpeningFcn, ...
                   'gui_OutputFcn',  @SolarGUI16092013_OutputFcn, ...
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


% --- Executes just before SolarGUI16092013 is made visible.
function SolarGUI16092013_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SolarGUI16092013 (see VARARGIN)
% Choose default command line output for SolarGUI16092013
handles.output = hObject;
set(handles.btnExportData,'enable','off')
set(handles.btnClearAll,'enable','off')
set(findall(handles.uipanelGraph, '-property', 'enable'), 'enable', 'off')
set(findall(handles.uipanelControl, '-property', 'enable'), 'enable', 'off')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SolarGUI16092013 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SolarGUI16092013_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;clc

function figure1_CreateFcn(hObject, eventdata, handles)
%add data slection
function btnImportData_Callback(hObject, eventdata, handles)
solar = PCdat
solar = getxlsm(solar)
handles.xOffset = 55;
handles.yOffset = 45;
handles.width = 1130;
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
calc.cond = PC_calc.conductivityOFF(solar.vpc, solar.vdark, solar.a, solar.b, solar.c)
list=get(handles.comboBoxMuSetting,'String');
val=get(handles.comboBoxMuSetting,'Value');
mu_mode = list{val}
calc.dN = PC_calc.carriers(calc.cond, solar.width, solar.N_A, solar.N_D, mu_mode)
%using gref for vref_to_sun???
[calc.suns, calc.gen] = PC_calc.generation(solar.vref, solar.gref, solar.OC, solar.width)
list=get(handles.comboBoxTauSetting,'String');
val=get(handles.comboBoxTauSetting,'Value');
mode = list{val}
calc.tau = PC_calc.lifetime(solar.time, calc.dN, calc.gen, mode)
list=get(handles.comboBoxAugerSetting,'String');
val=get(handles.comboBoxAugerSetting,'Value');
mode = list{val}
calc.itau = PC_calc.inversetau (calc.dN, calc.tau, solar.N_A, solar.N_D, mode)

[calc.j0e, calc.tau_b] = PC_calc.emittersat(calc.dN, calc.itau, solar.width, solar.N_A, solar.N_D)
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
set(handles.btnExportData,'enable','on')

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

% --- Executes on button press in btnExportData.
function btnExportData_Callback(hObject, eventdata, handles)
% hObject    handle to btnExportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function toggleSummary_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleSummary,'value', 1)
set(handles.toggleSummary,'BackgroundColor','w')
clearPlot(handles.uipanelPlot)
plotSuntoTime = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset+handles.height/2 handles.width/2-handles.xOffset, handles.height/2-handles.yOffset]);
        
plot(plotSuntoTime, handles.solar.time, handles.calc.suns );
xlabel('Time(seconds)')
ylabel('Illumination(suns)')

%%%%
plotAugettodN = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [2*handles.xOffset+handles.width/2 handles.yOffset+handles.height/2 handles.width/2-handles.xOffset, handles.height/2-handles.yOffset]);
        
plot(plotAugettodN, handles.calc.dN, handles.calc.itau );
xlabel('Minority Carrier,\Deltan(cm^{-3})')
ylabel('Inverse Lifetime - Auger Term(s^{-1})')
%%%
plotSuntoVoc = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width/2-handles.xOffset, handles.height/2-handles.yOffset]);
        
%plot(plotSuntoVoc, handles.calc.dN, handles.calc.suns );
xlabel('Implied Open Circuit Voltage/v')
ylabel('Illumination/suns')
%%%%
plotTautodN = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [2*handles.xOffset+handles.width/2 handles.yOffset handles.width/2-handles.xOffset, handles.height/2-handles.yOffset]);
        
plot(plotTautodN, handles.calc.dN, handles.calc.tau );
xlabel('Minority Carrier/cm^-^3')
ylabel('Minority Carrier Lifetime/s')



function toggleJoeEffective_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleJoeEffective,'value', 1)
set(handles.toggleJoeEffective,'BackgroundColor','w')
clearPlot(handles.uipanelPlot)
plotJoeEffective = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
        
%plot(plotJoeEffective, handles.calc.dN, handles.calc.tau_b );
xlabel('Minority Carrier/unit')
ylabel('Joe_e_f_f /s')



% --- Executes on button press in toggleTauBulk.
function toggleTauBulk_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleTauBulk,'value', 1)
set(handles.toggleTauBulk,'BackgroundColor','w')
clearPlot(handles.uipanelPlot)
plotTauBulk = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
        
plot(plotTauBulk, handles.calc.dN, handles.calc.tau_b );
xlabel('Minority Carrier/unit')
ylabel('Tau_b_u_l_k /s')

%add data selection later
function toggleRawData_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleRawData,'value', 1)
set(handles.toggleRawData,'BackgroundColor','w')
clearPlot(handles.uipanelPlot)
plotRaw = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width handles.height]);
plot(plotRaw, handles.solar.time, handles.solar.vpc); 
xlabel('time/s')
ylabel('photovoltage/v')

function toggleTauEffective_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleTauEffective,'value', 1)
set(handles.toggleTauEffective,'BackgroundColor','w')
clearPlot(handles.uipanelPlot)
plotTauEffective = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
        
plot(plotTauEffective, handles.calc.dN, handles.calc.tau );
xlabel('Minority Carrier/unit')
ylabel('Tau_e_f_f /s')

function toggleJoeSRV_Callback(hObject, eventdata, handles)
deselection(handles)
set(handles.toggleJoeSRV,'value', 1)
set(handles.toggleJoeSRV,'BackgroundColor','w')
clearPlot(handles.uipanelPlot)
plotJoeSRV = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [handles.xOffset handles.yOffset handles.width, handles.height]);
        
plot(plotJoeSRV, handles.calc.j0e, handles.calc.itau );
xlabel('j0e')
ylabel('itau')

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

function editWidth_Callback(hObject, eventdata, handles)
% hObject    handle to editWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
width = str2double(get(hObject,'String'))


% Hints: get(hObject,'String') returns contents of editWidth as text
%        str2double(get(hObject,'String')) returns contents of editWidth as a double


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



function editWidthError_Callback(hObject, eventdata, handles)
a= 'change edit'
% Hints: get(hObject,'String') returns contents of editWidthError as text
%        str2double(get(hObject,'String')) returns contents of editWidthError as a double


% --- Executes during object creation, after setting all properties.
function editWidthError_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editWidthError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editResistivity_Callback(hObject, eventdata, handles)
% hObject    handle to editResistivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResistivity as text
%        str2double(get(hObject,'String')) returns contents of editResistivity as a double


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



function editDopingError_Callback(hObject, eventdata, handles)
% hObject    handle to editDopingError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDopingError as text
%        str2double(get(hObject,'String')) returns contents of editDopingError as a double


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


% --- Executes on button press in checkboxWidthArray.
function checkboxWidthArray_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxWidthArray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxWidthArray



function editOpticalConst_Callback(hObject, eventdata, handles)
% hObject    handle to editOpticalConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOpticalConst as text
%        str2double(get(hObject,'String')) returns contents of editOpticalConst as a double


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



function editOpticalConstError_Callback(hObject, eventdata, handles)
% hObject    handle to editOpticalConstError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOpticalConstError as text
%        str2double(get(hObject,'String')) returns contents of editOpticalConstError as a double


% --- Executes during object creation, after setting all properties.
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
% Hints: contents = cellstr(get(hObject,'String')) returns comboBoxBulkType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comboBoxBulkType


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



function editDarkVoltage_Callback(hObject, eventdata, handles)
% hObject    handle to editDarkVoltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDarkVoltage as text
%        str2double(get(hObject,'String')) returns contents of editDarkVoltage as a double


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



function editBhatA_Callback(hObject, eventdata, handles)
% hObject    handle to editBhatA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBhatA as text
%        str2double(get(hObject,'String')) returns contents of editBhatA as a double


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



function editBhatB_Callback(hObject, eventdata, handles)
% hObject    handle to editBhatB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBhatB as text
%        str2double(get(hObject,'String')) returns contents of editBhatB as a double


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



function editBhatC_Callback(hObject, eventdata, handles)
% hObject    handle to editBhatC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBhatC as text
%        str2double(get(hObject,'String')) returns contents of editBhatC as a double


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
% hObject    handle to comboBoxTauSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns comboBoxTauSetting contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comboBoxTauSetting


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


% --- Executes on selection change in comboBoxMuSetting.
function comboBoxMuSetting_Callback(hObject, eventdata, handles)
% hObject    handle to comboBoxMuSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns comboBoxMuSetting contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comboBoxMuSetting


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


% --- Executes on selection change in comboBoxAugerSetting.
function comboBoxAugerSetting_Callback(hObject, eventdata, handles)
% hObject    handle to comboBoxAugerSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns comboBoxAugerSetting contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comboBoxAugerSetting


% --- Executes during object creation, after setting all properties.
function comboBoxAugerSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comboBoxAugerSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1Nd_Callback(hObject, eventdata, handles)
% hObject    handle to edit1Nd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1Nd as text
%        str2double(get(hObject,'String')) returns contents of edit1Nd as a double


% --- Executes during object creation, after setting all properties.
function edit1Nd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1Nd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editNa_Callback(hObject, eventdata, handles)
% hObject    handle to editNa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNa as text
%        str2double(get(hObject,'String')) returns contents of editNa as a double


% --- Executes during object creation, after setting all properties.
function editNa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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

function recalc(handles, variables)
% case
% 0 for combobox
%width
% OC
% dark voltage
% Nd
% Na
   
    

calc.cond = PC_calc.conductivityOFF(solar.vpc, solar.vdark, solar.a, solar.b, solar.c)
list=get(handles.comboBoxMuSetting,'String');
val=get(handles.comboBoxMuSetting,'Value');
mu_mode = list{val}
calc.dN = PC_calc.carriers(calc.cond, solar.width, solar.N_A, solar.N_D, mu_mode)
%using gref for vref_to_sun???
[calc.suns, calc.gen] = PC_calc.generation(solar.vref, solar.gref, solar.OC, solar.width)
list=get(handles.comboBoxTauSetting,'String');
val=get(handles.comboBoxTauSetting,'Value');
mode = list{val}
calc.tau = PC_calc.lifetime(solar.time, calc.dN, calc.gen, mode)
list=get(handles.comboBoxAugerSetting,'String');
val=get(handles.comboBoxAugerSetting,'Value');
mode = list{val}
calc.itau = PC_calc.inversetau (calc.dN, calc.tau, solar.N_A, solar.N_D, mode)

[calc.j0e, calc.tau_b] = PC_calc.emittersat(calc.dN, calc.itau, solar.width, solar.N_A, solar.N_D)
% itau = SRV??

handles.calc = calc;
guidata(hObject, handles);
handles.solar = solar;% pass obj solar data to the GUI handles, so callback can share data
guidata(hObject, handles); % something like submission of data to Obj of GUI from hanldes
