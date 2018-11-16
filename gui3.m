function varargout = gui3(varargin)
% GUI3 MATLAB code for gui3.fig
%      GUI3, by itself, creates a new GUI3 or raises the existing
%      singleton*.
%
%      H = GUI3 returns the handle to a new GUI3 or the handle to
%      the existing singleton*.
%
%      GUI3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI3.M with the given file arguments.
%
%      GUI3('Property','Value',...) creates a new GUI3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui3

% Last Modified by GUIDE v2.5 05-Aug-2015 14:10:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui3_OpeningFcn, ...
                   'gui_OutputFcn',  @gui3_OutputFcn, ...
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


% --- Executes just before gui3 is made visible.
function gui3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui3 (see VARARGIN)

axes(handles.logo);
set(gca,'color','none')
imshow('cranfield_logo.jpg');

% Choose default command line output for gui3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file as text
%        str2double(get(hObject,'String')) returns contents of file as a double


% --- Executes during object creation, after setting all properties.
function file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in input_button.
function input_button_Callback(hObject, eventdata, handles)
% hObject    handle to input_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname] = uigetfile('*.csv','Select the Data input file');
handles = guidata(hObject);
handles.filename = [pathname filename];  %%any handle where value is to be stored
set(handles.file,'string',filename);

header = {'Time (s)', '\phi (deg)', '\theta (deg)', '\psi (deg)', ...
    'p (deg/s)', 'q (deg/s)', 'r (deg/s)', 'a_x (m/s^2)', 'a_y (m/s^2)',...
    'a_z (m/s^2)', 'V_e (m/s)', 'H_p (m)', 'T (C)', 'P (Pa)', ...
    '\delta_a (deg)', '\delta_e (deg)', '\delta_r (deg)', '\tau (%)'};

temp = importdata(handles.filename);
time = temp.data(:,1);
phi = (temp.data(:,2));
theta = (temp.data(:,3));
psi = (temp.data(:,4));
p = (temp.data(:,5));
q = (temp.data(:,6));
r = (temp.data(:,7));
a_x = temp.data(:,8);
a_y = temp.data(:,9);
a_z = temp.data(:,10);
airspeed = temp.data(:,11);
Hp = temp.data(:,12);
Temp = temp.data(:,13);
Pressure = temp.data(:,14);
aileron = (temp.data(:,15));
elevator = (temp.data(:,16));
rudder = (temp.data(:,17));
throttle = temp.data(:,18);

hh = strfind(filename, '-');
hh = hh(1);
if strcmp(filename(1:hh-1),'sppo') || strcmp(filename(1:hh-1),'elevator') || strcmp(filename(1:hh-1),'phugoid')
    inputIndex = 16;
elseif strcmp(filename(1:hh-1),'dutch') || strcmp(filename(1:hh-1),'rudder')
    inputIndex = 17;
elseif strcmp(filename(1:hh-1),'roll') || strcmp(filename(1:hh-1),'aileron')
    inputIndex = 15;
else
    inputIndex = 16;
end

clear temp

A = [time,  phi,  theta,  psi, p, ...
    q, r, a_x, a_y, a_z, ...
    airspeed, Hp, Temp, Pressure, ...
    aileron, elevator, rudder, ...
    throttle];

for ii = [inputIndex,6,11,12]
    if ii == 11
        ax(ii) = subplot(4,1,4, 'Parent', handles.plots);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
        xlabel(['{\it ' header{1} '}']);
    elseif ii == inputIndex
        ax(ii) = subplot(4,1,1, 'Parent', handles.plots);
        plot(ax(ii),A(:,1),A(:,ii),'r-','LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
    elseif ii == 12
        ax(ii) = subplot(4,1,2, 'Parent', handles.plots);
        plot(ax(ii),A(:,1),A(:,ii),'r-','LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
    else
        ax(ii) = subplot(4,1,ii-3, 'Parent', handles.plots);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
    end
end
