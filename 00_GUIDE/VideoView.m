function varargout = VideoView(varargin)
% VIDEOVIEW MATLAB code for VideoView.fig
%      VIDEOVIEW, by itself, creates a new VIDEOVIEW or raises the existing
%      singleton*.
%
%      H = VIDEOVIEW returns the handle to a new VIDEOVIEW or the handle to
%      the existing singleton*.
%
%      VIDEOVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDEOVIEW.M with the given input arguments.
%
%      VIDEOVIEW('Property','Value',...) creates a new VIDEOVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VideoView_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VideoView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VideoView

% Last Modified by GUIDE v2.5 28-Nov-2017 15:27:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VideoView_OpeningFcn, ...
                   'gui_OutputFcn',  @VideoView_OutputFcn, ...
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


% --- Executes just before VideoView is made visible.
function VideoView_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VideoView (see VARARGIN)

% Choose default command line output for VideoView
handles.output = hObject;
%handles.folder = varargin{1};


load('Position Data.mat')
vidobj=VideoReader('Raw Video_1.avi');

standbild=imagesc(handles.axes1,read(vidobj,1));
title(cd)
axes(handles.axes2);
timeline({'included' 'excluded'},{[0], [0] },{[vidobj.Duration], [0]});
textLabelframe = sprintf('Frame = %i', 1);
set(handles.text2, 'String', textLabelframe);

textLabelinclude = sprintf('include = %s', "yes");
set(handles.text3, 'String', textLabelinclude);

textLabelmatrix = string(num2str([1 2;1 4;1 5]));
set(handles.text4, 'String', textLabelmatrix);

% for i=1:5:vidobj.Duration
% subplot(1,2,1)
% standbild=imagesc(read(vidobj,i));
% subplot(1,2,2)
% cla
% text(1,1,num2str(i))
% end






% Update handles structure
guidata(hObject, handles);
gatherAndUpdate(handles);
% UIWAIT makes VideoView wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VideoView_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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


% --- Executes on button press in toggle_play.
function toggle_play_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_play


% --- Executes on button press in toggle_include.
function toggle_include_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_include (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_include


% --- Executes on selection change in speed.
function speed_Callback(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns speed contents as cell array
%        contents{get(hObject,'Value')} returns selected item from speed


% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function gatherAndUpdate(handles)
gatheredData=gatherData(handles);
updateAxes(gatheredData,handles);

function gatheredData=gatherData(handles)
gatheredData.play=get(handles.toggle_play, 'value');
gatheredData.include=get(handles.toggle_include, 'value');
gatheredData.speed=char(get(handles.speed, 'string'));
gatheredData.speed=gatheredData.speed(1:end-1);
gatheredData.slider=get(handles.slider1, 'value'));



function updateAxes(gd, handles)
axes(handles.axes1)
load('Position Data.mat')
vidobj=VideoReader('Raw Video_1.avi');

standbild=imagesc(handles.axes1,read(vidobj,1));
title(cd)
axes(handles.axes2);
timeline({'included' 'excluded'},{[0], [0] },{[vidobj.Duration], [0]});
textLabelframe = sprintf('Frame = %i', 1);
set(handles.text2, 'String', textLabelframe);

textLabelinclude = sprintf('include = %s', "yes");
set(handles.text3, 'String', textLabelinclude);

textLabelmatrix = string(num2str([1 2;1 4;1 5]));
set(handles.text4, 'String', textLabelmatrix);
