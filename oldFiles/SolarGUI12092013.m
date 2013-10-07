function varargout = SolarGUI12092013(varargin)
% SOLARGUI12092013 MATLAB code for SolarGUI12092013.fig
%      SOLARGUI12092013, by itself, creates a new SOLARGUI12092013 or raises the existing
%      singleton*.
%
%      H = SOLARGUI12092013 returns the handle to a new SOLARGUI12092013 or the handle to
%      the existing singleton*.
%
%      SOLARGUI12092013('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOLARGUI12092013.M with the given input arguments.
%
%      SOLARGUI12092013('Property','Value',...) creates a new SOLARGUI12092013 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SolarGUI12092013_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SolarGUI12092013_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SolarGUI12092013

% Last Modified by GUIDE v2.5 16-Sep-2013 01:26:19

% Begin initialization code - DO NOT EDIT


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SolarGUI12092013_OpeningFcn, ...
                   'gui_OutputFcn',  @SolarGUI12092013_OutputFcn, ...
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


% --- Executes just before SolarGUI12092013 is made visible.
function SolarGUI12092013_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SolarGUI12092013 (see VARARGIN)
% Choose default command line output for SolarGUI12092013
handles.output = hObject;
set(handles.btnExportData,'enable','off')
set(handles.btnClearAll,'enable','off')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SolarGUI12092013 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SolarGUI12092013_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;clc


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)

% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in toggleSummary.
function toggleSummary_Callback(hObject, eventdata, handles)
haxes2 = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [15.8 15.846 480.2 480.846]);
        plot(haxes2, 1:200, sin((1:200)./12));
% hObject    handle to toggleSummary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleSummary


% --- Executes on button press in toggleJoeEffective.
function toggleJoeEffective_Callback(hObject, eventdata, handles)
haxes2 = axes('Parent', handles.uipanelPlot, ...
            'Units', 'pixels', ...
            'Position', [300.8 15.846 480.2 480.846]);
        plot(haxes2, 1:200, cos((1:200)./12));
% hObject    handle to toggleJoeEffective (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleJoeEffective


% --- Executes on button press in toggleTauBulk.
function toggleTauBulk_Callback(hObject, eventdata, handles)
% excelObject = actxserver('Excel.Application');
% filePattern = fullfile('C:\Users\Jowy\Documents\MATLAB\Solar', '*.*')
% xlsFiles = dir(filePattern)
% for k = 1:length(xlsFiles)
%   baseFileName = xlsFiles(k).name;
%   fullFileName = fullfile('C:\Users\Jowy\Documents\MATLAB\Solar', baseFileName);
%   fprintf(1, 'Now reading %s\n', fullFileName);
%   excelWorkbook = excelObject.workbooks.Open(fullFileName);
%   worksheets = excelObject.sheets;
%   numberOfSheets = worksheets.Count;
%   int l = 1
%   for sheetIndex  = 1 : numberOfSheets 
%     l
%     l= l +1
%       % Do whatever you want to do.
%   end
% end
% % excelObject.Quit;
% hObject    handle to toggleTauBulk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleTauBulk


% --- Executes on button press in toggleRawData.
function toggleRawData_Callback(hObject, eventdata, handles)
ah = findall(handles.uipanelPlot,'type','axes')
if ~isempty(ah)
   delete(ah)
end
% hObject    handle to toggleRawData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleRawData


% --- Executes on button press in toggleTauEffedtive.
function toggleTauEffedtive_Callback(hObject, eventdata, handles)
% hObject    handle to toggleTauEffedtive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleTauEffedtive


% --- Executes on button press in toggleJoeSRV.
function toggleJoeSRV_Callback(hObject, eventdata, handles)
% hObject    handle to toggleJoeSRV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleJoeSRV


% --- Executes on button press in btnImportData.
function btnImportData_Callback(hObject, eventdata, handles)
% hObject    handle to btnImportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [filename, pathname, filterindex] = uigetfile('*.*', 'Pick a MATLAB code file');
obj = PCdat()
filename
 pathname
 filterindex
 whos 
 if filterindex == 1
    path = [ pathname filename ];
    [status,sheets,xlFormat] = xlsfinfo(path) 
    length(sheets)
 end
 
[num,txt,raw] = xlsread(path,3)
a = strfind(txt,'voltage')
%startIndex = regexpi(txt,'voltage')
[startIndex,endIndex ] = regexpi(txt,'voltage')
[ c d ] = size(startIndex); 
ttl = c *d 
for i = 1 : ttl
    if find(startIndex{i} == 1)
    location = i
    end
end



% --- Executes on button press in btnClearAll.
function btnClearAll_Callback(hObject, eventdata, handles)
set(handles.btnExportData,'enable','off')
% hObject    handle to btnClearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnExportData.
function btnExportData_Callback(hObject, eventdata, handles)
% hObject    handle to btnExportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnTest.
function btnTest_Callback(hObject, eventdata, handles)
%uiopen('matlab') 
 [filename, pathname, filterindex] = uigetfile('*.*', 'Pick a MATLAB code file');
 filename
 pathname
 filterindex
 whos 
 if filterindex == 1
    path = [ pathname filename ];
    [status,sheets,xlFormat] = xlsfinfo(path) 
    length(sheets)
 end
% hObject    handle to btnTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
set(handles.labelTest,'string','width')

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
% hObject    handle to editWidthError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
% hObject    handle to comboBoxBulkType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
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
