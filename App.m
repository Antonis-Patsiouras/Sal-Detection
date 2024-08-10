function varargout = App(varargin)
% APP MATLAB code for App.fig
%      APP, by itself, creates a new APP or raises the existing
%      singleton*.
%
%      H = APP returns the handle to a new APP or the handle to
%      the existing singleton*.
%
%      APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APP.M with the given input arguments.
%
%      APP('Property','Value',...) creates a new APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before App_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to App_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help App

% Last Modified by GUIDE v2.5 14-May-2018 04:44:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @App_OpeningFcn, ...
                   'gui_OutputFcn',  @App_OutputFcn, ...
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


% --- Executes just before App is made visible.
function App_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to App (see VARARGIN)

% Choose default command line output for App
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes App wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = App_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% 

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);

[filename , path] = uigetfile({'*.jpg;*.tif;*.png;*.gif'},'File Selector');

set(handles.figure1,'FileName',path);
img = imread([path,filename]);
set(handles.axes1,'Units','pixels');
axes(handles.axes1);
imshow(img);
set(handles.axes1,'Units','normalized');
set(handles.figure1,'Name',filename);

set(handles.axes2,'Units','pixels');
axes(handles.axes2);
histogram(img);
set(handles.axes2,'Units','normalized');

%% 

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[imsHC,S] = H (handles.figure1.FileName,handles.figure1.Name);

cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);

set(handles.axes3,'Units','pixels');
axes(handles.axes3);
imshow(imsHC);
set(handles.axes3,'Units','normalized');

set(handles.uitable,'Data',S);

set(handles.axes2,'Units','pixels');
axes(handles.axes2);
histogram(imsHC)
set(handles.axes2,'Units','normalized');

%% 

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%[imsRC,imgs] = RC_Saliency_Contrast(handles.figure1.FileName,handles.figure1.Name);
[imsRC,imgs,S] = RSal (handles.figure1.FileName,handles.figure1.Name);

cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);

set(handles.axes3,'Units','pixels');
axes(handles.axes3);
imshow(imsRC);
set(handles.axes3,'Units','normalized');

set(handles.axes4,'Units','pixels');
axes(handles.axes4);
imshow(imgs);
set(handles.axes4,'Units','normalized');

set(handles.uitable,'Data',S);

set(handles.axes2,'Units','pixels');
axes(handles.axes2);
histogram(imsRC);
set(handles.axes2,'Units','normalized');

%% 

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imsave(handles.output);
%% 

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close();

%% 

% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open 'Theory_paper.pdf' 



% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.output);