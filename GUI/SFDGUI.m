function varargout = SFDGUI(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SFDGUI_OpeningFcn, ...
    'gui_OutputFcn',  @SFDGUI_OutputFcn, ...
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


% --- Executes just before SFDGUI is made visible.
function SFDGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command ridge arguments to SFDGUI (see VARARGIN)

% Choose default command ridge output for SFDGUI
handles.output = hObject;
handles.state = SFDGUIstate;
handles.state.lastDirData = pwd();
handles.state.lastDirConfig = pwd();
handles.state.exportFigureState = SFDExportFigureState;
handles.state.exportFigureState.exportFolder = pwd();
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);

dcm_obj = datacursormode(hObject);
set(dcm_obj,'UpdateFcn',@SFDDataCursorUpdateFct);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SFDGUI wait for user response (see UIRESUME)
% uiwait(handles.figureSymFD);


% --- Outputs from this function are returned to the command ridge.
function varargout = SFDGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command ridge output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function menuFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuOpenImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuOpenImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.*','Select an image',handles.state.lastDirData);
if filename == 0
    return;
end
handles.state.lastDirData = pathname;
[dummy,handles.state.imageName,fileExt] = fileparts(filename);
if strcmp(fileExt,'.txt')
    handles.state.image = double(dlmread([pathname, filename]));
else
    info = imfinfo([pathname, filename]);
    if isequal(info.ColorType,'grayscale')
        handles.state.image = double(imread([pathname, filename]));
    elseif isequal(info.ColorType,'truecolor')
        handles.state.image = double(rgb2gray(imread([pathname, filename])));
    elseif isequal(info.ColorType,'indexed')
        handles.state.image = imread([pathname, filename]);
        if size(handles.state.image,3) == 3
            handles.state.image = double(rgb2gray(handles.state.image));
        else
            handles.state.image = double(handles.state.image);
        end
    else
        handles.state.image = double(imread([pathname, filename]));
    end
end
handles = updateAxesImage(handles,0);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(handles.figureSymFD,handles);



% --------------------------------------------------------------------
function menuLoadConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to menuLoadConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMaxFeatureWidth_Callback(hObject, eventdata, handles)
% hObject    handle to editMaxFeatureWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMaxFeatureWidth as text
%        str2double(get(hObject,'String')) returns contents of editMaxFeatureWidth as a double
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editMaxFeatureWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMaxFeatureWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMinFeatureWidth_Callback(hObject, eventdata, handles)
% hObject    handle to editMinFeatureWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinFeatureWidth as text
%        str2double(get(hObject,'String')) returns contents of editMinFeatureWidth as a double
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editMinFeatureWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinFeatureWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editScalesPerOctave_Callback(hObject, eventdata, handles)
% hObject    handle to editScalesPerOctave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editScalesPerOctave as text
%        str2double(get(hObject,'String')) returns contents of editScalesPerOctave as a double
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editScalesPerOctave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editScalesPerOctave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupOrientations.
function popupOrientations_Callback(hObject, eventdata, handles)
% hObject    handle to popupOrientations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupOrientations contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupOrientations
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupOrientations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupOrientations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMinContrast_Callback(hObject, eventdata, handles)
% hObject    handle to editMinContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinContrast as text
%        str2double(get(hObject,'String')) returns contents of editMinContrast as a double
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editMinContrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to editAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAlpha as text
%        str2double(get(hObject,'String')) returns contents of editAlpha as a double
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in buttonDetect.
function buttonDetect_Callback(hObject, eventdata, handles)
% hObject    handle to buttonDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = checkIfMoleculeSystemIsUpToDate(handles);
if ~handles.state.moleculeSystemIsUpToDate
    h = waitbar(0.5,'Constructing the molecule System. Please wait ...','windowstyle', 'modal');
    set(h,'windowstyle','normal');
    handles.state.moleculeSystem = SFDgetFeatureDetectionSystem(size(handles.state.image,1),size(handles.state.image,2),handles.state.feature,handles.state.maxFeatureWidth,handles.state.maxFeatureLength,handles.state.minFeatureWidth,handles.state.alpha,handles.state.nOrientations,handles.state.scalesPerOctave,handles.state.evenOddScaleOffset,handles.state.generator,handles.state.orientationOperator);
    handles.state.currScale = 1;
    handles.state.currOrientation = 1;
    handles.state.moleculeSystemIsUpToDate = 1;
    handles = updatePopupMostSignificantScales(handles);
    handles = updateAxesMolecules(handles);
    close(h);
end
h = waitbar(0.5,'Detecting features. Please wait ...','windowstyle', 'modal');
set(h,'windowstyle','normal');
minHeight = -Inf;
maxHeight = Inf;
if handles.state.onlyPositiveOrNegativeFeatures == -1
    maxHeight = 0;
end
if handles.state.onlyPositiveOrNegativeFeatures == 1
    minHeight = 0;
end

[handles.state.featureMap,handles.state.orientationMap,handles.state.heightMap,handles.state.widthMap] = SFDgetFeatures(handles.state.image,handles.state.moleculeSystem,handles.state.minContrast,handles.state.scalesUsedForMostSignificantSearch,minHeight,maxHeight);
handles = thinFeatureMapToLines(handles);
handles.state.curvatureMap = SFDgetCurvatureMap(handles.state.orientationMapThinned);
%handles.state.curvatureMap(handles.state.featureMap<eps) = NaN;
handles = updateAxesFeature(handles);

close(h);
guidata(hObject,handles);
% --- Executes on button press in buttonGenerateSystem.

% --- Executes on button press in buttonScaleDec.
function buttonScaleDec_Callback(hObject, eventdata, handles)
% hObject    handle to buttonScaleDec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state.currScale = max(handles.state.currScale - 1,1);
handles = updateAxesMolecules(handles);
guidata(hObject,handles);


% --- Executes on button press in buttonScaleInc.
function buttonScaleInc_Callback(hObject, eventdata, handles)
% hObject    handle to buttonScaleInc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state.currScale = min(handles.state.currScale + 1,handles.state.moleculeSystem.nScales);
handles = updateAxesMolecules(handles);
guidata(hObject,handles);

% --- Executes on button press in buttonOriDec.
function buttonOriDec_Callback(hObject, eventdata, handles)
% hObject    handle to buttonOriDec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state.currOrientation = max(handles.state.currOrientation - 1,1);
handles = updateAxesMolecules(handles);
guidata(hObject,handles);


% --- Executes on button press in buttonOriInc.
function buttonOriInc_Callback(hObject, eventdata, handles)
% hObject    handle to buttonOriInc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state.currOrientation = min(handles.state.currOrientation + 1,handles.state.moleculeSystem.nOris);
handles = updateAxesMolecules(handles);
guidata(hObject,handles);

% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1



function editOffset_Callback(hObject, eventdata, handles)
% hObject    handle to editOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOffset as text
%        str2double(get(hObject,'String')) returns contents of editOffset as a double
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes on selection change in popupMostSignificantScales.
function popupMostSignificantScales_Callback(hObject, eventdata, handles)
% hObject    handle to popupMostSignificantScales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupMostSignificantScales contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupMostSignificantScales

handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editOffset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuFeature.
function popupmenuFeature_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuFeature contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuFeature
handles = readGUIData(handles);
handles = updateGUI(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenuFeature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function menuSaveConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user defined functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = updateAxesImage(handles,overlay)
if isempty(handles.state.image)
    return;
end
axes(handles.axesImage);
img = handles.state.image;
if overlay && ~(strcmpi(handles.state.feature,'blobs') && handles.state.showThinned)
    if handles.state.showThinned 
        imgRgb = SFDrgbFromMap(handles.state.featureMapThinned,'red','auto',img);
    else
        imgRgb = SFDrgbFromMap(handles.state.featureMap,'red','auto',img);
    end;
else
    imgRgb = ind2rgb(gray2ind(mat2gray(img),256),gray(256));
end
hImg = image(imgRgb);
hTitle = title(handles.state.imageName);
set(hTitle,'interpreter','none');
set(hImg,'UserData',img);

axis equal;
axis tight;
set(handles.axesImage,'XTick',[1,size(handles.state.image,2)]);
set(handles.axesImage,'YTick',[1,size(handles.state.image,1)]);
if overlay && handles.state.showThinned && strcmpi(handles.state.feature,'blobs')
    [~,cmap] = SFDrgbFromMap(handles.state.widthMapThinned,'parula','auto');   
    SFDplotDetectedBlobs( handles.axesImage, handles.state.widthMapThinned,handles.state.widthMapThinned, cmap )
end

function handles = updateAxesFeature(handles)
if isempty(handles.state.featureMap)
    return;
end

axes(handles.axesFeature);
if handles.state.showOrientationsWidhtsOrHeightsOrCurvature == 1
    if handles.state.showThinned
        img = (handles.state.orientationMapThinned);
        imgRgb = SFDrgbFromMap(handles.state.orientationMapThinned,'angle',[0,Inf]);
    else
        img = (handles.state.orientationMap);
        imgRgb = SFDrgbFromMap(handles.state.orientationMap,'angle',[0,Inf]);
    end
elseif handles.state.showOrientationsWidhtsOrHeightsOrCurvature == 2
    if handles.state.showThinned
        img = handles.state.widthMapThinned;
        [imgRgb,cmap] = SFDrgbFromMap(handles.state.widthMapThinned,'parula','auto');
    else
        img = handles.state.widthMap;
        imgRgb = SFDrgbFromMap(handles.state.widthMap,'parula','auto');
    end
    
    
elseif handles.state.showOrientationsWidhtsOrHeightsOrCurvature == 3
    if handles.state.showThinned
        img = handles.state.heightMapThinned;
        imgRgb = SFDrgbFromMap(handles.state.heightMapThinned,'parula','auto');
    else
        img = handles.state.heightMap;
        imgRgb = SFDrgbFromMap(handles.state.heightMap,'parula','auto');
    end
elseif handles.state.showOrientationsWidhtsOrHeightsOrCurvature == 4
    img = handles.state.curvatureMap;
    imgRgb = SFDrgbFromMap(img,'parula',[0,1/5]);
else
    if handles.state.showThinned
        img = handles.state.featureMapThinned;
    else
        img = handles.state.featureMap;
    end
    imgRgb = ind2rgb(gray2ind(mat2gray(img),256),gray(256));
end
hImg = image(imgRgb);
set(hImg,'UserData',img);
set(hImg,'UserData',img);
if handles.state.onlyPositiveOrNegativeFeatures == -1
    hTitle = title([handles.state.imageName,': ', handles.state.feature,' with negative height']);
elseif handles.state.onlyPositiveOrNegativeFeatures == 1
    hTitle = title([handles.state.imageName,': ', handles.state.feature,' with positive height']);
else
    hTitle = title([handles.state.imageName,': ', handles.state.feature]);
end
set(hTitle,'interpreter','none');
axis equal;
axis tight;
set(handles.axesFeature,'XTick',[1,size(handles.state.image,2)]);
set(handles.axesFeature,'YTick',[1,size(handles.state.image,1)]);

% if handles.state.showOrientationsWidhtsOrHeightsOrCurvature == 2 && strcmpi(handles.state.feature,'blobs')
%     SFDplotDetectedBlobs( handles.axesFeature, handles.state.widthMapThinned, cmap )
% end
handles = updateAxesImage(handles,handles.state.overlay);


function handles = updateAxesMolecules(handles)

axes(handles.axesMoleculeSymmetry1);
moleculeIdx = handles.state.currOrientation + (handles.state.currScale-1)*(handles.state.moleculeSystem.nOris);
img = real(fftshift(ifft2(ifftshift(handles.state.moleculeSystem.molecules(:,:,moleculeIdx)))));
imgRgb = ind2rgb(gray2ind(mat2gray(img),256),jet(256));
hImg = image(imgRgb);
set(hImg,'UserData',img);
ctr = floor(size(handles.state.image)/2) +1;
l = floor(max(handles.state.maxFeatureWidth,handles.state.maxFeatureLength));
axis(handles.axesMoleculeSymmetry1,[ctr(2)-l,ctr(2)+l,ctr(1)-l,ctr(1)+l]);
set(handles.axesMoleculeSymmetry1,'XTick',[ctr(2)-l,ctr(2)+l]);
set(handles.axesMoleculeSymmetry1,'YTick',[ctr(1)-l,ctr(1)+l]);
axis(handles.axesMoleculeSymmetry1,'square');
set(handles.textCurrScale,'String',['scale: ',num2str(handles.state.currScale)]);
axes(handles.axesMoleculeSymmetry2);
img = real(fftshift(ifft2(ifftshift(handles.state.moleculeSystem.molecules(:,:,moleculeIdx+handles.state.moleculeSystem.nMolecules/2)))));
imgRgb = ind2rgb(gray2ind(mat2gray(img),256),jet(256));
hImg = image(imgRgb);
set(hImg,'UserData',img);
axis(handles.axesMoleculeSymmetry2,[ctr(2)-l,ctr(2)+l,ctr(1)-l,ctr(1)+l]);
set(handles.axesMoleculeSymmetry2,'XTick',[ctr(2)-l,ctr(2)+l]);
set(handles.axesMoleculeSymmetry2,'YTick',[ctr(1)-l,ctr(1)+l]);
axis(handles.axesMoleculeSymmetry2,'square');

set(handles.textCurrOri,'String',['ori: ',num2str(handles.state.currOrientation)]);

function [handles] = updatePopupMostSignificantScales(handles)
if isstruct(handles.state.moleculeSystem)
    nScales =  handles.state.moleculeSystem.nScales;
    oldStr = get(handles.popupMostSignificantScales,'String');
    for k = 1:(nScales + 3)
        if k < 4
            newStr{k} = oldStr{k};
        else
            newStr{k} = num2str(k-3);
        end
    end
    set(handles.popupMostSignificantScales,'String',newStr);
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

function handles = readGUIData(handles)
handles.state.generator = extractStrFromPopupMenu(handles.popupmenuGenerator);
handles.state.orientationOperator = extractStrFromPopupMenu(handles.popupmenuOrientationOperator);
handles.state.maxFeatureWidth = (str2num(get(handles.editMaxFeatureWidth,'String')));
handles.state.minFeatureWidth = (str2num(get(handles.editMinFeatureWidth,'String')));
handles.state.maxFeatureLength = (str2num(get(handles.editMaxFeatureLength,'String')));
handles.state.scalesPerOctave = (str2num(get(handles.editScalesPerOctave,'String')));
handles.state.nOrientations = 2^(get(handles.popupOrientations,'Value'));
handles.state.alpha = str2num(get(handles.editAlpha,'String'));
handles.state.feature = extractStrFromPopupMenu(handles.popupmenuFeature);
handles.state.minContrast = str2double(get(handles.editMinContrast,'String'));
handles.state.evenOddScaleOffset = str2num(get(handles.editOffset,'String'));
handles.state.scalesUsedForMostSignificantSearch = extractStrFromPopupMenu(handles.popupMostSignificantScales);
handles.state.thinningThreshold = str2double(get(handles.editThinningThreshold,'String'));
handles.state.minComponentLength = str2double(get(handles.editMinComponentLength,'String'));
handles.state.onlyPositiveOrNegativeFeatures = (get(handles.popupmenuHeights,'Value')-1);
if handles.state.onlyPositiveOrNegativeFeatures == 2, handles.state.onlyPositiveOrNegativeFeatures = -1; end;

handles = updatePopupMostSignificantScales(handles);
if all(isstrprop(handles.state.scalesUsedForMostSignificantSearch,'digit'))
    handles.state.scalesUsedForMostSignificantSearch = str2num(handles.state.scalesUsedForMostSignificantSearch);
end
handles.state.overlay = get(handles.toggleOverlay,'Value') == 1;
handles.state.showOrientationsWidhtsOrHeightsOrCurvature = get(handles.toggleShowOrientations,'Value') + 2*(get(handles.toggleShowWidths,'Value')) + 3*(get(handles.toggleShowHeights,'Value')) + 4*(get(handles.toggleShowCurvature,'Value'));
handles.state.showThinned = get(handles.toggleShowThinned,'Value') == 1;

function handles = updateGUI(handles)
setPopupMenuStr(handles.popupmenuGenerator,handles.state.generator);
setPopupMenuStr(handles.popupmenuOrientationOperator,handles.state.orientationOperator);
set(handles.editMaxFeatureWidth,'String',num2str(handles.state.maxFeatureWidth));
set(handles.editMinFeatureWidth,'String',num2str(handles.state.minFeatureWidth));
set(handles.editMaxFeatureLength,'String',num2str(handles.state.maxFeatureLength));
set(handles.editScalesPerOctave,'String',num2str(handles.state.scalesPerOctave));
set(handles.popupOrientations,'Value',log2(handles.state.nOrientations));
set(handles.editAlpha,'String',num2str(handles.state.alpha));
set(handles.editThinningThreshold,'String',num2str(handles.state.thinningThreshold));
set(handles.editMinComponentLength,'String',num2str(handles.state.minComponentLength));


setPopupMenuStr(handles.popupmenuFeature,handles.state.feature);
if handles.state.onlyPositiveOrNegativeFeatures == -1
    set(handles.popupmenuHeights,'Value',3);
else
    set(handles.popupmenuHeights,'Value',handles.state.onlyPositiveOrNegativeFeatures + 1);
end


set(handles.editMinContrast,'String',num2str(handles.state.minContrast));
set(handles.editOffset,'String',num2str(handles.state.evenOddScaleOffset));
[handles] = updatePopupMostSignificantScales(handles);
if ischar(handles.state.scalesUsedForMostSignificantSearch)
    switch handles.state.scalesUsedForMostSignificantSearch
        case 'all'
            set(handles.popupMostSignificantScales,'Value',1);
        case 'highest'
            set(handles.popupMostSignificantScales,'Value',3);
        case 'lowest'
            set(handles.popupMostSignificantScales,'Value',2);
        otherwise
            set(handles.popupMostSignificantScales,'Value',1);
    end
else
    set(handles.popupMostSignificantScales,'Value',handles.state.scalesUsedForMostSignificantSearch+3);
end

function handles = checkIfMoleculeSystemIsUpToDate(handles)
handles.state.moleculeSystemIsUpToDate = 1;
if isstruct(handles.state.moleculeSystem)
    if      ~strcmp(handles.state.generator,handles.state.moleculeSystem.generator) || ...
            ~strcmp(handles.state.orientationOperator,handles.state.moleculeSystem.orientationOperator) || ...
            handles.state.maxFeatureWidth ~=handles.state.moleculeSystem.maxFeatureWidth ||...
            handles.state.minFeatureWidth ~=handles.state.moleculeSystem.minFeatureWidth ||...
            handles.state.maxFeatureLength ~=handles.state.moleculeSystem.maxFeatureLength ||...
            handles.state.alpha ~=handles.state.moleculeSystem.alpha ||...
            handles.state.scalesPerOctave ~=handles.state.moleculeSystem.scalesPerOctave ||...
            (strcmp(handles.state.moleculeSystem.orientationOperator,'shear') && handles.state.nOrientations + 6 ~= handles.state.moleculeSystem.nOris) ||...
            (~strcmp(handles.state.moleculeSystem.orientationOperator,'shear') && handles.state.nOrientations ~= handles.state.moleculeSystem.nOris) ||...
            handles.state.evenOddScaleOffset ~=handles.state.moleculeSystem.evenOddScaleOffset ||...
            ~strcmp(handles.state.feature,handles.state.moleculeSystem.feature) || ...
            ~isequal(size(handles.state.image),handles.state.moleculeSystem.size)
        handles.state.moleculeSystemIsUpToDate = 0;
    end
else
    handles.state.moleculeSystemIsUpToDate = 0;
end

function handles = thinFeatureMapToLines(handles)

handles.state.featureMapThinned = SFDthinFeatureMap(handles.state.featureMap,handles.state.thinningThreshold,handles.state.minComponentLength,handles.state.feature);
handles.state.orientationMapThinned = handles.state.orientationMap;
handles.state.orientationMapThinned(~handles.state.featureMapThinned) = NaN;
handles.state.widthMapThinned = handles.state.widthMap;
handles.state.widthMapThinned(~handles.state.featureMapThinned) = NaN;
handles.state.heightMapThinned = handles.state.heightMap;
handles.state.heightMapThinned(~handles.state.featureMapThinned) = NaN;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in toggleOverlay.
function toggleOverlay_Callback(hObject, eventdata, handles)
% hObject    handle to toggleOverlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleOverlay
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
handles = updateAxesFeature(handles);
guidata(hObject, handles);


% --- Executes on button press in toggleShowOrientations.
function toggleShowOrientations_Callback(hObject, eventdata, handles)
% hObject    handle to toggleShowOrientations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleShowOrientations
if get(hObject,'Value') == 1
    set(handles.toggleShowWidths,'Value',0);
    set(handles.toggleShowHeights,'Value',0);
    set(handles.toggleShowCurvature,'Value',0);
end
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
handles = updateAxesFeature(handles);
guidata(hObject, handles);

% --- Executes on button press in toggleShowCurvature.
function toggleShowCurvature_Callback(hObject, eventdata, handles)
% hObject    handle to toggleShowCurvature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    set(handles.toggleShowWidths,'Value',0);
    set(handles.toggleShowHeights,'Value',0);
    set(handles.toggleShowOrientations,'Value',0);
end
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
handles = updateAxesFeature(handles);
guidata(hObject, handles);

% --- Executes on button press in toggleShowWidths.
function toggleShowWidths_Callback(hObject, eventdata, handles)
% hObject    handle to toggleShowWidths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleShowWidths
if get(hObject,'Value') == 1
    set(handles.toggleShowOrientations,'Value',0);
    set(handles.toggleShowHeights,'Value',0);
    set(handles.toggleShowCurvature,'Value',0);
end
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
handles = updateAxesFeature(handles);
guidata(hObject, handles);

% --- Executes on button press in toggleShowHeights.
function toggleShowHeights_Callback(hObject, eventdata, handles)
% hObject    handle to toggleShowHeights (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleShowHeights
if get(hObject,'Value') == 1
    set(handles.toggleShowWidths,'Value',0);
    set(handles.toggleShowOrientations,'Value',0);
    set(handles.toggleShowCurvature,'Value',0);
end
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
handles = updateAxesFeature(handles);
guidata(hObject, handles);

% --------------------------------------------------------------------


% --- Executes on button press in toggleShowThinned.
function toggleShowThinned_Callback(hObject, eventdata, handles)
% hObject    handle to toggleShowThinned (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleShowThinned
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
handles = updateAxesFeature(handles);
guidata(hObject, handles);



function editThinningThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to editThinningThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editThinningThreshold as text
%        str2double(get(hObject,'String')) returns contents of editThinningThreshold as a double
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editThinningThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editThinningThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonEnlargeEdges.
function buttonEnlargeEdges_Callback(hObject, eventdata, handles)
% hObject    handle to buttonEnlargeEdges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hFigure = figure; % Open a new figure with handle f1
hAxes = copyobj(handles.axesFeature,hFigure); % Copy axes object h into figure f1
set(hAxes,'Units','normalized');
set(hAxes,'Position',[0.1 0.1 0.8 0.8]);
set(hFigure,'units','normalized','outerposition',[0 0 1 1]);

% --- Executes on button press in buttonEnlargeImage.
function buttonEnlargeImage_Callback(hObject, eventdata, handles)
% hObject    handle to buttonEnlargeImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hFigure = figure; % Open a new figure with handle f1
hAxes = copyobj(handles.axesImage,hFigure); % Copy axes object h into figure f1
set(hAxes,'Units','normalized');
set(hAxes,'Position',[0.1 0.1 0.8 0.8]);
set(hFigure,'units','normalized','outerposition',[0 0 1 1]);




% --- Executes during object creation, after setting all properties.
function popupMostSignificantScales_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupMostSignificantScales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMaxFeatureWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%  Copyright (c) 2016. Rafael Reisenhofer
%
%  Part of CoShREM Toolbox v1.1
%  Built Mon, 11/01/2016
%  This is Copyrighted Material



function editMaxFeatureLength_Callback(hObject, eventdata, handles)
% hObject    handle to editMaxFeatureLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMaxFeatureLength as text
%        str2double(get(hObject,'String')) returns contents of editMaxFeatureLength as a double
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editMaxFeatureLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMaxFeatureLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuHeights.
function popupmenuHeights_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuHeights (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuHeights contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuHeights
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenuHeights_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuHeights (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuGenerator.
function popupmenuGenerator_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuGenerator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuGenerator contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuGenerator
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenuGenerator_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuGenerator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuOrientationOperator.
function popupmenuOrientationOperator_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuOrientationOperator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuOrientationOperator contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuOrientationOperator
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenuOrientationOperator_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuOrientationOperator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_loadImage.
function button_loadImage_Callback(hObject, eventdata, handles)
% hObject    handle to button_loadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
menuOpenImage_Callback(hObject, eventdata, handles);


% --- Executes on button press in button_loadConfiguration.
function button_loadConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to button_loadConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.mat','Load configuration ...',handles.state.lastDirConfig);
if filename == 0
    return;
end
handles.state.lastDirConfig = pathname;
config = load([pathname,filename]);
handles.state.feature = config.feature;
handles.state.generator = config.generator;
handles.state.maxFeatureWidth = config.maxFeatureWidth ;
handles.state.maxFeatureLength = config.maxFeatureLength;
handles.state.minFeatureWidth = config.minFeatureWidth;
handles.state.scalesPerOctave = config.scalesPerOctave;
handles.state.nOrientations = config.nOrientations;
handles.state.alpha = config.alpha;
handles.state.minContrast = config.minContrast;
handles.state.evenOddScaleOffset = config.evenOddScaleOffset ;
if isfield(config, 'scalesUsedForPivotSearch')
    handles.state.scalesUsedForMostSignificantSearch = config.scalesUsedForPivotSearch;
else
    handles.state.scalesUsedForMostSignificantSearch = config.scalesUsedForMostSignificantSearch;
end
handles.state.onlyPositiveOrNegativeFeatures = config.onlyPositiveOrNegativeFeatures;
handles.state.orientationOperator = config.orientationOperator;
if isfield(config, 'thinningThreshold')
    handles.state.thinningThreshold = config.thinningThreshold;
end
if isfield(config, 'minComponentLength')
    handles.state.minComponentLength = config.minComponentLength;
end

handles = updateGUI(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(handles.figureSymFD,handles);


% --- Executes on button press in button_exportFeatures.
function button_exportFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to button_exportFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.state.exportFigureState,export] = SFDExportFigure(handles.state.exportFigureState);
if export
    if strcmpi(handles.state.exportFigureState.exportType,'mat')
        handles.state.exportFigureState.exportAsOverlay = false;
    end
    if handles.state.exportFigureState.exportVolume
        handles = checkIfMoleculeSystemIsUpToDate(handles);
    if ~handles.state.moleculeSystemIsUpToDate
        h = waitbar(0.5,'Constructing the molecule System. Please wait ...','windowstyle', 'modal');
        set(h,'windowstyle','normal');
        handles.state.moleculeSystem = SFDgetFeatureDetectionSystem(size(handles.state.image,1),size(handles.state.image,2),handles.state.feature,handles.state.maxFeatureWidth,handles.state.maxFeatureLength,handles.state.minFeatureWidth,handles.state.alpha,handles.state.nOrientations,handles.state.scalesPerOctave,handles.state.evenOddScaleOffset,handles.state.generator,handles.state.orientationOperator);
        handles.state.currScale = 1;
        handles.state.currOrientation = 1;
        handles.state.moleculeSystemIsUpToDate = 1;
        handles = updatePopupMostSignificantScales(handles);
        handles = updateAxesMolecules(handles);
        close(h);
    end
    h = waitbar(0.5,'Detecting features. Please wait ...','windowstyle', 'modal');
    set(h,'windowstyle','normal');
    minHeight = -Inf;
    maxHeight = Inf;
    if handles.state.onlyPositiveOrNegativeFeatures == -1
        maxHeight = 0;
    end
    if handles.state.onlyPositiveOrNegativeFeatures == 1
        minHeight = 0;
    end

    featureVolume = SFDgetFeatureVolumes(handles.state.image,handles.state.moleculeSystem,handles.state.minContrast,handles.state.scalesUsedForMostSignificantSearch,minHeight,maxHeight);

    SFDExportVolume(featureVolume,handles.state.feature,handles.state.exportFigureState.exportFolder,handles.state.imageName);
    close(h);
    end

    if handles.state.exportFigureState.exportFeatureMap
        if handles.state.exportFigureState.exportThinned
            map = handles.state.featureMapThinned;
            thinnedStr = '_thinned';
        else
            map = handles.state.featureMap;           
            thinnedStr = '';
        end
        maxVal = 'auto';
        fullnameStr = '';
        mapType = 'feature';    
        if handles.state.exportFigureState.exportThinned && strcmpi(handles.state.feature,'blobs')&& ~strcmpi(handles.state.exportFigureState.exportType,'mat')
            mapType = 'blob';
            map = handles.state.widthMapThinned;
        end
        if handles.state.exportFigureState.exportAsOverlay
            fullname = [handles.state.exportFigureState.exportFolder,filesep,handles.state.imageName,'_',handles.state.feature,fullnameStr,thinnedStr,'_overlay'];
            printOptions.exportType = handles.state.exportFigureState.exportType;
            SFDexportMap(map,maxVal,mapType,fullname,'',printOptions,handles.state.image);        
        else
            fullname = [handles.state.exportFigureState.exportFolder,filesep,handles.state.imageName,'_',handles.state.feature,fullnameStr,thinnedStr];
            printOptions.exportType = handles.state.exportFigureState.exportType;
            SFDexportMap(map,maxVal,mapType,fullname,'',printOptions);          
        end
    end
    if handles.state.exportFigureState.exportOrientationMap
        if handles.state.exportFigureState.exportThinned
            map = handles.state.orientationMapThinned;
            thinnedStr = '_thinned';
        else
            map = handles.state.orientationMap;           
            thinnedStr = '';
        end
        maxVal = 'auto';
        fullnameStr = '_tangentOrientations';
        mapType = 'angle';    
        if handles.state.exportFigureState.exportAsOverlay
            fullname = [handles.state.exportFigureState.exportFolder,filesep,handles.state.imageName,'_',handles.state.feature,fullnameStr,thinnedStr,'_overlay'];
            printOptions.exportType = handles.state.exportFigureState.exportType;
            SFDexportMap(map,maxVal,mapType,fullname,'',printOptions,handles.state.image);        
        else
            fullname = [handles.state.exportFigureState.exportFolder,filesep,handles.state.imageName,'_',handles.state.feature,fullnameStr,thinnedStr];
            printOptions.exportType = handles.state.exportFigureState.exportType;
            SFDexportMap(map,maxVal,mapType,fullname,'',printOptions);          
        end 
    end
    if handles.state.exportFigureState.exportHeightMap
        if handles.state.exportFigureState.exportThinned
            map = handles.state.heightMapThinned;
            thinnedStr = '_thinned';
        else
            map = handles.state.heightMap;           
            thinnedStr = '';
        end
        maxVal = 'auto';
        fullnameStr = '_heights';
        mapType = 'height';    
        if handles.state.exportFigureState.exportAsOverlay
            fullname = [handles.state.exportFigureState.exportFolder,filesep,handles.state.imageName,'_',handles.state.feature,fullnameStr,thinnedStr,'_overlay'];
            printOptions.exportType = handles.state.exportFigureState.exportType;
            SFDexportMap(map,maxVal,mapType,fullname,'',printOptions,handles.state.image);        
        else
            fullname = [handles.state.exportFigureState.exportFolder,filesep,handles.state.imageName,'_',handles.state.feature,fullnameStr,thinnedStr];
            printOptions.exportType = handles.state.exportFigureState.exportType;
            SFDexportMap(map,maxVal,mapType,fullname,'',printOptions);          
        end 
    end
    if handles.state.exportFigureState.exportWidthMap
        if handles.state.exportFigureState.exportThinned
            map = handles.state.widthMapThinned;
            thinnedStr = '_thinned';
        else
            map = handles.state.widthMap;           
            thinnedStr = '';
        end
        maxVal = 'auto';
        fullnameStr = '_widths';
        mapType = 'width';    
        if handles.state.exportFigureState.exportThinned && strcmpi(handles.state.feature,'blobs') && ~strcmpi(handles.state.exportFigureState.exportType,'mat')
            mapType = 'blob';
            map = handles.state.widthMapThinned;
        end
        if handles.state.exportFigureState.exportAsOverlay
            fullname = [handles.state.exportFigureState.exportFolder,filesep,handles.state.imageName,'_',handles.state.feature,fullnameStr,thinnedStr,'_overlay'];
            printOptions.exportType = handles.state.exportFigureState.exportType;
            SFDexportMap(map,maxVal,mapType,fullname,'',printOptions,handles.state.image);        
        else
            fullname = [handles.state.exportFigureState.exportFolder,filesep,handles.state.imageName,'_',handles.state.feature,fullnameStr,thinnedStr];
            printOptions.exportType = handles.state.exportFigureState.exportType;
            SFDexportMap(map,maxVal,mapType,fullname,'',printOptions);          
        end 
    end
    if handles.state.exportFigureState.exportCurvatureMap
        minMax= [0,1/5];
        thinnedStr = '';
        fullnameStr = '_curvatures';
        mapType = 'curv';
        map = handles.state.curvatureMap;    
        if handles.state.exportFigureState.exportAsOverlay
            fullname = [handles.state.exportFigureState.exportFolder,filesep,handles.state.imageName,'_',handles.state.feature,fullnameStr,thinnedStr,'_overlay'];
            printOptions.exportType = handles.state.exportFigureState.exportType;
            SFDexportMap(map,minMax,mapType,fullname,'',printOptions,handles.state.image);        
        else
            fullname = [handles.state.exportFigureState.exportFolder,filesep,handles.state.imageName,'_',handles.state.feature,fullnameStr,thinnedStr];            
            printOptions.exportType = handles.state.exportFigureState.exportType;
            SFDexportMap(map,minMax,mapType,fullname,'',printOptions);          
        end 
    end
end
guidata(hObject, handles);

% --- Executes on button press in button_saveConfiguration.
function button_saveConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to button_saveConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uiputfile('*.mat','Save configuration ...',[handles.state.lastDirConfig,filesep,handles.state.imageName,'_config']);
if filename == 0
    return;
end
handles.state.lastDirConfig = pathname;

configuration.feature = handles.state.feature;
configuration.generator = handles.state.generator;
configuration.maxFeatureWidth = handles.state.maxFeatureWidth ;
configuration.maxFeatureLength = handles.state.maxFeatureLength;
configuration.minFeatureWidth = handles.state.minFeatureWidth;
configuration.scalesPerOctave = handles.state.scalesPerOctave;
configuration.nOrientations = handles.state.nOrientations;
configuration.alpha = handles.state.alpha;
configuration.minContrast = handles.state.minContrast;
configuration.evenOddScaleOffset = handles.state.evenOddScaleOffset ;
configuration.scalesUsedForMostSignificantSearch = handles.state.scalesUsedForMostSignificantSearch;
configuration.onlyPositiveOrNegativeFeatures = handles.state.onlyPositiveOrNegativeFeatures;
configuration.orientationOperator = handles.state.orientationOperator;
configuration.thinningThreshold = handles.state.thinningThreshold;
configuration.minComponentLength = handles.state.minComponentLength;



save([pathname,filename],'-struct','configuration');
guidata(hObject, handles);



function editMinComponentLength_Callback(hObject, eventdata, handles)
% hObject    handle to editMinComponentLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinComponentLength as text
%        str2double(get(hObject,'String')) returns contents of editMinComponentLength as a double
handles = readGUIData(handles);
handles = checkIfMoleculeSystemIsUpToDate(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editMinComponentLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinComponentLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License
