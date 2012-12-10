function varargout = RobotGUI(varargin)
% ROBOTGUI M-file for RobotGUI.fig
%      ROBOTGUI, by itself, creates a new ROBOTGUI or raises the existing
%      singleton*.
%
%      H = ROBOTGUI returns the handle to a new ROBOTGUI or the handle to
%      the existing singleton*.
%
%      ROBOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOTGUI.M with the given input arguments.
%
%      ROBOTGUI('Property','Value',...) creates a new ROBOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RobotGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RobotGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RobotGUI

% Last Modified by GUIDE v2.5 04-May-2007 12:23:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RobotGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RobotGUI_OutputFcn, ...
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

global PhiPrime Stop_Robot;

% --- Executes just before RobotGUI is made visible.
function RobotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RobotGUI (see VARARGIN)

% Clear console
clc;



% Include the other directories from the current working directory 
addpath(sprintf('%s%s', pwd, '\nxtComm'));
addpath(sprintf('%s%s', pwd, '\odometry'));
addpath(sprintf('%s%s', pwd, '\scans'));
addpath(sprintf('%s%s', pwd, '\RWTHMindstormsNXT'));
addpath(sprintf('%s%s', pwd, '\RWTHMindstormsNXT\tools'));

% Choose default command line output for RobotGUI
handles.output = hObject;

% Initialize some variables
handles.comport = '\\.\\COM1';

handles.hSerial = -1;

handles.wheelRadius = 0.027; % wheel radius
handles.wheelbase = 0.142; % wheelbase

handles.sliderRot = 0;  
handles.sliderTrans = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RobotGUI wait for user response (see UIRESUME)
% uiwait(handles.RobotGUI);


% --- Outputs from this function are returned to the command line.
function varargout = RobotGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.hSerial;


% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    % toggle button is pressed
    global PhiPrime Stop_Robot;
    PhiPrime = [0,0];
    Stop_Robot = 1;
    %exit;
elseif button_state == get(hObject,'Min')
    % toggle button is not pressed
end


% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    % toggle button is pressed
    SIMULATE = false;
    
    %% SET COM PORT
    COMPORT = handles.comport;
    
    %% SET INITIAL ROBOT POSITION.
    startPose = [ 0, 0, pi/2 ]; % sets the robot start pose
    
    global PhiPrime Stop_Robot;
    PhiPrime = [0, 0];
    Stop_Robot = 0;


    %% SET ROBOT CONSTANTS.
    robotConst(1) = handles.wheelRadius; % wheel radius
    robotConst(2) = handles.wheelbase/2; % 1/2 wheelbase
    
    %% RUN PROGRAM.
    Main;
elseif button_state == get(hObject,'Min')
    % toggle button is not pressed
end

% --- Executes on selection change in comport.
function comport_Callback(hObject, eventdata, handles)
% hObject    handle to comport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns comport contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comport
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string = string_list{val}; % convert from cell array to string
handles.comport = sprintf('%s%s', '\\.\\', selected_string);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function comport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function wheelRadius_Callback(hObject, eventdata, handles)
% hObject    handle to wheelRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wheelRadius as text
%        str2double(get(hObject,'String')) returns contents of wheelRadius as a double
handles.wheelRadius = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function wheelRadius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wheelRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function wheelbase_Callback(hObject, eventdata, handles)
% hObject    handle to wheelbase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wheelbase as text
%        str2double(get(hObject,'String')) returns contents of wheelbase as a double
handles.wheelbase = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function wheelbase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wheelbase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderRot_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.sliderRot = get(hObject,'Value');

global PhiPrime;
PhiPrime = [handles.sliderTrans - handles.sliderRot, handles.sliderTrans + handles.sliderRot];

% Update handles structure
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function sliderRot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on slider movement.
function sliderTrans_Callback(hObject, eventdata, handles)
% hObject    handle to sliderTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.sliderTrans = get(hObject,'Value');

global PhiPrime;
PhiPrime = [handles.sliderTrans - handles.sliderRot, handles.sliderTrans + handles.sliderRot];

% Update handles structure
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function sliderTrans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes during object deletion, before destroying properties.
function robotGUI_DeleteFcn(hObject, eventdata, handles)

global PhiPrime Stop_Robot;
PhiPrime = [0,0];
Stop_Robot = 1;

% hObject    handle to robotGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


