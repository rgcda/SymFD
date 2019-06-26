function varargout = SFDExportFigure(varargin)
% SFDEXPORTFIGURE MATLAB code for SFDExportFigure.fig
%      SFDEXPORTFIGURE, by itself, creates a new SFDEXPORTFIGURE or raises the existing
%      singleton*.
%
%      H = SFDEXPORTFIGURE returns the handle to a new SFDEXPORTFIGURE or the handle to
%      the existing singleton*.
%
%      SFDEXPORTFIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SFDEXPORTFIGURE.M with the given input arguments.
%
%      SFDEXPORTFIGURE('Property','Value',...) creates a new SFDEXPORTFIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SFDExportFigure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SFDExportFigure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SFDExportFigure

% Last Modified by GUIDE v2.5 16-Feb-2018 16:55:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SFDExportFigure_OpeningFcn, ...
                   'gui_OutputFcn',  @SFDExportFigure_OutputFcn, ...
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


% --- Executes just before SFDExportFigure is made visible.
function SFDExportFigure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SFDExportFigure (see VARARGIN)

% Choose default command line output for SFDExportFigure
handles.output = hObject;
handles.state = varargin{1};
handles.export = 0;

set(handles.editFolder,'String',handles.state.exportFolder);

set(handles.checkboxFeatureMap,'Value',handles.state.exportFeatureMap);
set(handles.checkboxTangentOrientationMap,'Value',handles.state.exportOrientationMap);
set(handles.checkboxHeightMap,'Value',handles.state.exportHeightMap);
set(handles.checkboxWidthMap,'Value',handles.state.exportWidthMap);
set(handles.checkboxCurvatureMap,'Value',handles.state.exportCurvatureMap);
set(handles.checkboxForPrint,'Value',handles.state.exportForPrint);
set(handles.checkboxOverlay,'Value',handles.state.exportAsOverlay);
set(handles.checkboxThinned,'Value',handles.state.exportThinned);
set(handles.checkboxIncludeColormap,'Value',handles.state.exportWithColormap);
set(handles.checkboxExportVolume,'Value',handles.state.exportVolume);
setPopupMenuStr(handles.popupExportType,handles.state.exportType);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SFDExportFigure wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SFDExportFigure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.state;
varargout{2} = handles.export;
delete(handles.figure1);



% --- Executes on button press in buttonExport.
function buttonExport_Callback(hObject, eventdata, handles)
% hObject    handle to buttonExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles afnd user data (see GUIDATA)
    handles.export = 1;
    guidata(hObject, handles);
    close(handles.figure1);

% --- Executes on button press in checkboxFeatureMap.
function checkboxFeatureMap_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFeatureMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFeatureMap
handles.state.exportFeatureMap = get(hObject,'Value');
guidata(hObject, handles);



% --- Executes on button press in checkboxTangentOrientationMap.
function checkboxTangentOrientationMap_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTangentOrientationMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTangentOrientationMap
handles.state.exportOrientationMap = get(hObject,'Value');
guidata(hObject, handles);



% --- Executes on button press in checkboxHeightMap.
function checkboxHeightMap_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxHeightMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxHeightMap
handles.state.exportHeightMap = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in checkboxCurvatureMap.
function checkboxCurvatureMap_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxCurvatureMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxCurvatureMap
handles.state.exportCurvatureMap = get(hObject,'Value');
guidata(hObject, handles);




% --- Executes on button press in checkboxWidthMap.
function checkboxWidthMap_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxWidthMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxWidthMap
    handles.state.exportWidthMap = get(hObject,'Value');
    guidata(hObject, handles);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    pathname = uigetdir(handles.state.exportFolder,'Select folder ...');    
    if pathname ~= 0
        handles.state.exportFolder = pathname;
    end
    set(handles.editFolder,'String',handles.state.exportFolder);
    guidata(hObject, handles);
    



function editFolder_Callback(hObject, eventdata, handles)
% hObject    handle to editFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFolder as text
%        str2double(get(hObject,'String')) returns contents of editFolder as a double
handles.state.exportFolder = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on button press in checkboxOverlay.
function checkboxForPrint_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxOverlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxOverlay
handles.state.exportForPrint = get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on button press in checkboxIncludeColormap.
function checkboxIncludeColormap_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxIncludeColormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxIncludeColormap
handles.state.exportWithColormap = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in checkboxThinned.
function checkboxThinned_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxThinned (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxThinned
handles.state.exportThinned = get(hObject,'Value');
guidata(hObject, handles);

function checkboxOverlay_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxThinned (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxThinned
handles.state.exportAsOverlay = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in checkboxExportVolume.
function checkboxExportVolume_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxExportVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxExportVolume
handles.state.exportVolume = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on selection change in popupExportType.
function popupExportType_Callback(hObject, eventdata, handles)
% hObject    handle to popupExportType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupExportType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupExportType

handles.state.exportType = extractStrFromPopupMenu(hObject);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupExportType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupExportType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function str = extractStrFromPopupMenu(hMenu)
helpStr = get(hMenu,'String');
str = helpStr{get(hMenu,'Value')};

function setPopupMenuStr(hMenu,str)
helpStr = get(hMenu,'String');
found = 0;
for k = 1:length(helpStr)
    if strcmp(str,helpStr{k})
        found = k;
        break;
    end
end
if found > 0
    set(hMenu,'Value',found);
else
    helpStr{end+1} = str;
    set(hMenu,'String',helpStr)
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License