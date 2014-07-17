function run_paradigm_one_gui(varargin)
% RUN_PARADIGM_ONE_GUI M-file for run_paradigm_one_gui.fig
%      RUN_PARADIGM_ONE_GUI, by itself, creates a new RUN_PARADIGM_ONE_GUI or raises the existing
%      singleton*.
%
%      H = RUN_PARADIGM_ONE_GUI returns the handle to a new RUN_PARADIGM_ONE_GUI or the handle to
%      the existing singleton*.
%
%      RUN_PARADIGM_ONE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUN_PARADIGM_ONE_GUI.M with the given input arguments.
%
%      RUN_PARADIGM_ONE_GUI('Property','Value',...) creates a new RUN_PARADIGM_ONE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before run_paradigm_one_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to run_paradigm_one_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help run_paradigm_one_gui

% Last Modified by GUIDE v2.5 21-Aug-2011 12:59:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @run_paradigm_one_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @run_paradigm_one_gui_OutputFcn, ...
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


% --- Executes just before run_paradigm_one_gui is made visible.
function run_paradigm_one_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to run_paradigm_one_gui (see VARARGIN)

% Choose default command line output for run_paradigm_one_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes run_paradigm_one_gui wait for user response (see UIRESUME)
 uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = run_paradigm_one_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 uiresume(handles.figure1);


function bird_num_Callback(hObject, eventdata, handles)
% hObject    handle to bird_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bird_num as text
%        str2double(get(hObject,'String')) returns contents of bird_num as a double

%store the contents of input1_editText as a string. if the string
%is not a number then input will be empty
input = get(hObject,'String');
assignin('base','bird_num',input);
%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','0')  
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function bird_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bird_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function session_num_Callback(hObject, eventdata, handles)
% hObject    handle to session_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of session_num as text
%        str2double(get(hObject,'String')) returns contents of session_num as a double

%store the contents of input1_editText as a string. if the string
%is not a number then input will be empty
input = get(hObject,'String');
assignin('base','session',input);
%checks to see if input is empty. if so, default input1_editText to one
if (isempty(input))
     set(hObject,'String','1')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function session_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to session_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function notes_Callback(hObject, eventdata, handles)
% hObject    handle to notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of notes as text
%        str2double(get(hObject,'String')) returns contents of notes as a double

%store the contents of input1_editText as a string. if the string
%is not a number then input will be empty
input = get(hObject,'String');
assignin('base','notes',input);
%checks to see if input is empty. if so, default input1_editText to empty
if (isempty(input))
     set(hObject,'String','')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function notes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in test.
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of test
%store the contents of input1_editText as a string. if the string
%is not a number then input will be empty
input = get(hObject,'Value');
assignin('base','test',input);
guidata(hObject, handles);


