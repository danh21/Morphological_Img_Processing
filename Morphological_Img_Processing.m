function varargout = Morphological_Img_Processing(varargin)
% MORPHOLOGICAL_IMG_PROCESSING MATLAB code for Morphological_Img_Processing.fig
%      MORPHOLOGICAL_IMG_PROCESSING, by itself, creates a new MORPHOLOGICAL_IMG_PROCESSING or raises the existing
%      singleton*.
%
%      H = MORPHOLOGICAL_IMG_PROCESSING returns the handle to a new MORPHOLOGICAL_IMG_PROCESSING or the handle to
%      the existing singleton*.
%
%      MORPHOLOGICAL_IMG_PROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MORPHOLOGICAL_IMG_PROCESSING.M with the given input arguments.
%
%      MORPHOLOGICAL_IMG_PROCESSING('Property','Value',...) creates a new MORPHOLOGICAL_IMG_PROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Morphological_Img_Processing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Morphological_Img_Processing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Morphological_Img_Processing

% Last Modified by GUIDE v2.5 30-Sep-2022 18:35:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Morphological_Img_Processing_OpeningFcn, ...
                   'gui_OutputFcn',  @Morphological_Img_Processing_OutputFcn, ...
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




% --- Executes just before Morphological_Img_Processing is made visible.
function Morphological_Img_Processing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Morphological_Img_Processing (see VARARGIN)

% Choose default command line output for Morphological_Img_Processing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Global variables 
global isFileChosen SE;
isFileChosen = 0;
SE = strel('disk', 3);

% UIWAIT makes Morphological_Img_Processing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Morphological_Img_Processing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in chooseFileBtn.
function chooseFileBtn_Callback(hObject, eventdata, handles)
% hObject    handle to chooseFileBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global orgImg currentImg binImg isFileChosen;  
[FileName,PathName] = uigetfile({'*.png*'; '*.jpg*'}, 'Select image file');
if ([FileName,PathName])
    isFileChosen = 1;
    orgImg = imread([PathName,FileName]);
    currentImg = orgImg;
    binImg = im2bw(orgImg, graythresh(orgImg));
    axes(handles.axes1);
    imshow(orgImg);
    xlabel('Original Image');
    set(handles.warning, 'String', '');
    set(handles.numOfObjs, 'String', '0');
else
    if (~isFileChosen)
        set(handles.warning, 'String', 'No File Chosen !!!');
    end
end


% --- Executes on button press in dilationBtn.
function dilationBtn_Callback(hObject, eventdata, handles)
% hObject    handle to dilationBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global binImg currentImg isFileChosen;
if (isFileChosen) 
    SE = [0 1 0; 1 1 1; 0 1 0];
    dilatedImg = imdilate(binImg, SE);
    currentImg = dilatedImg;
    axes(handles.axes1);
    imshow(dilatedImg);
    xlabel('Dilated Image');
else
    set(handles.warning, 'String', 'No File Chosen !!!');
end


% --- Executes on button press in erosionBtn.
function erosionBtn_Callback(hObject, eventdata, handles)
% hObject    handle to erosionBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global binImg SE currentImg isFileChosen;
if (isFileChosen)   
    erodedImg = imerode(binImg, SE);
    currentImg = erodedImg;
    axes(handles.axes1);
    imshow(erodedImg);
    xlabel('Eroded Image');
else
    set(handles.warning, 'String', 'No File Chosen !!!');
end


% --- Executes on button press in objCountBtn.
function objCountBtn_Callback(hObject, eventdata, handles)
% hObject    handle to objCountBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global currentImg isFileChosen;
if (isFileChosen)
    cc = bwconncomp(currentImg, 4);
    set(handles.numOfObjs, 'String', cc.NumObjects);
else
    set(handles.warning, 'String', 'No File Chosen !!!');
end


function numOfObjs_Callback(hObject, eventdata, handles)
% hObject    handle to numOfObjs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numOfObjs as text
%        str2double(get(hObject,'String')) returns contents of numOfObjs as a double


% --- Executes during object creation, after setting all properties.
function numOfObjs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numOfObjs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resetBtn.
function resetBtn_Callback(hObject, eventdata, handles)
% hObject    handle to resetBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global orgImg currentImg isFileChosen;
if (isFileChosen)
    currentImg = orgImg;
    axes(handles.axes1);
    imshow(orgImg);
    xlabel('Original Image');
    set(handles.numOfObjs, 'String', '0');
else
    set(handles.warning, 'String', 'No File Chosen !!!');
end


% --- Executes on button press in openingBtn.
function openingBtn_Callback(hObject, eventdata, handles)
% hObject    handle to openingBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global binImg SE currentImg isFileChosen;
if (isFileChosen)
    openingImg = imopen(binImg, SE);
    currentImg = openingImg;
    axes(handles.axes1);
    imshow(openingImg);
    xlabel('Opening Image');
else
    set(handles.warning, 'String', 'No File Chosen !!!');
end


% --- Executes on button press in closingBtn.
function closingBtn_Callback(hObject, eventdata, handles)
% hObject    handle to closingBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global binImg SE currentImg isFileChosen;
if (isFileChosen)
    closingImg = imclose(binImg, SE);
    currentImg = closingImg;
    axes(handles.axes1);
    imshow(closingImg);
    xlabel('Closing Image');
else
    set(handles.warning, 'String', 'No File Chosen !!!');
end


% --- Executes on button press in binaryBtn.
function binaryBtn_Callback(hObject, eventdata, handles)
% hObject    handle to binaryBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global binImg currentImg isFileChosen;
if (isFileChosen)   
    currentImg = binImg;
    axes(handles.axes1);
    imshow(binImg);
    xlabel('Binary Image');
else
    set(handles.warning, 'String', 'No File Chosen !!!');
end
