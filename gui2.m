function varargout = gui2(varargin)
% GUI2 MATLAB code for gui2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2

% Last Modified by GUIDE v2.5 09-Jul-2015 11:19:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui2_OutputFcn, ...
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


% --- Executes just before gui2 is made visible.
function gui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2 (see VARARGIN)

axes(handles.logo);
set(gca,'color','none')
imshow('cranfield_logo.jpg');
set(handles.status,'string','Status');

% Choose default command line output for gui2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui2_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in input.
function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.mat','Select the Data input file');
handles = guidata(hObject);
handles.filename = [pathname filename];  %%any handle where value is to be stored
set(handles.file,'string',filename);
[raw] = PX4RawReading(handles.filename);

header = {'Time (s)', '\phi (deg)', '\theta (deg)', '\psi (deg)', ...
    'p (deg/s)', 'q (deg/s)', 'r (deg/s)', 'a_x (m/s^2)', 'a_y (m/s^2)',...
    'a_z (m/s^2)', 'V_e (m/s)', 'H_p (m)', 'T (C)', 'P (Pa)', ...
    '\delta_a (deg)', '\delta_e (deg)', '\delta_r (deg)', '\tau (%)'};

handles.header = header;

handles.A = [raw.att.time, raw.att.phi, raw.att.theta, raw.att.psi, raw.rate.p, ...
    raw.rate.q, raw.rate.r, raw.acc.a_x, raw.acc.a_y, raw.acc.a_z, ...
    raw.air.airspeed, raw.air.Hp, raw.air.Temp, raw.air.Pressure, ...
    raw.controls.aileron, raw.controls.elevator, raw.controls.rudder, ...
    raw.controls.throttle];

guidata(hObject,handles)

A = handles.A;

for ii = [2,3,4,11]
    if ii == 11
        ax(ii) = subplot(4,1,4, 'Parent', handles.attitudes);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
        xlabel(['{\it ' header{1} '}']);
    else
        ax(ii) = subplot(4,1,ii-1, 'Parent', handles.attitudes);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
    end
end

for ii = [5,6,7,10]
    if ii == 10
        ax(ii) = subplot(4,1,4, 'Parent', handles.rates);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
        xlabel(['{\it ' header{1} '}']);
    else
        ax(ii) = subplot(4,1,ii-4, 'Parent', handles.rates);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
    end
end

for ii = 15:18
    ax(ii) = subplot(4,1,ii-14, 'Parent', handles.inputs);
    plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 18
        xlabel(['{\it ' header{1} '}']);
    end
end

set(handles.status,'string','Data Succesfully Imported');

return



function basename_Callback(hObject, eventdata, handles)
% hObject    handle to basename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of basename as text
%        str2double(get(hObject,'String')) returns contents of basename as a double


% --- Executes during object creation, after setting all properties.
function basename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to basename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lower_Callback(hObject, eventdata, handles)
% hObject    handle to lower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lower as text
%        str2double(get(hObject,'String')) returns contents of lower as a double


% --- Executes during object creation, after setting all properties.
function lower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upper_Callback(hObject, eventdata, handles)
% hObject    handle to upper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upper as text
%        str2double(get(hObject,'String')) returns contents of upper as a double


% --- Executes during object creation, after setting all properties.
function upper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in partition.
function partition_Callback(hObject, eventdata, handles)
% hObject    handle to partition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str=get(handles.lower, 'string');
lower = str2num(str);
str=get(handles.upper, 'string');
upper = str2num(str);

interval = [lower,upper];

A = handles.A;
X_fil = handles.X_fil;
header =handles.header;
time = A(:,1);
hh = find(time==interval(1));
hh1 = find(time==interval(2));

X_test = X_fil(hh:hh1,:); 
X_test(:,1) = X_test(:,1) - interval(1);
for ii = 2:4
    X_test(:,ii) = X_test(:,ii) - mean(X_test(:,ii));
end
handles.X_test = X_test;
guidata(hObject,handles)
for ii = [2,3,4,11]
    if ii == 11
        ax(ii) = subplot(4,1,4, 'Parent', handles.attitudes);
        plot(ax(ii),X_test(:,1),X_test(:,ii),'r','LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
        xlabel(['{\it ' header{1} '}']);
    else
        ax(ii) = subplot(4,1,ii-1, 'Parent', handles.attitudes);
        plot(ax(ii),X_test(:,1),X_test(:,ii),'r','LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
    end
end

for ii = [5,6,7,10]
    if ii == 10
        xlabel(['{\it ' header{1} '}']);
        ax(ii) = subplot(4,1,4, 'Parent', handles.rates);
        plot(ax(ii),X_test(:,1),X_test(:,ii),'r','LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
    else
        ax(ii) = subplot(4,1,ii-4, 'Parent', handles.rates);
        plot(ax(ii),X_test(:,1),X_test(:,ii),'r','LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
    end
end

for ii = 15:18
    ax(ii) = subplot(4,1,ii-14, 'Parent', handles.inputs);
    plot(ax(ii),X_test(:,1),X_test(:,ii),'r','LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 18
        xlabel(['{\it ' header{1} '}']);
    end
end

set(handles.status,'string','Data Successfully Partitionned');
return


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

header = {'Time (s)', '\phi (deg)', '\theta (deg)', '\psi (deg)', ...
    'p (deg/s)', 'q (deg/s)', 'r (deg/s)', 'a_x (m/s^2)', 'a_y (m/s^2)',...
    'a_z (m/s^2)', 'V_e (m/s)', 'H_p (m)', 'T (C)', 'P (Pa)', ...
    '\delta_a (deg)', '\delta_e (deg)', '\delta_r (deg)', '\tau (%)'};

A = handles.A;

for ii = [2,3,4,11]
    if ii == 11
        ax(ii) = subplot(4,1,4, 'Parent', handles.attitudes);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
        xlabel(['{\it ' header{1} '}']);
    else
        ax(ii) = subplot(4,1,ii-1, 'Parent', handles.attitudes);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
    end
end

for ii = [5,6,7,10]
    if ii == 10
        ax(ii) = subplot(4,1,4, 'Parent', handles.rates);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
        xlabel(['{\it ' header{1} '}']);
    else
        ax(ii) = subplot(4,1,ii-4, 'Parent', handles.rates);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
    end
end

for ii = 15:18
    ax(ii) = subplot(4,1,ii-14, 'Parent', handles.inputs);
    plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 18
        xlabel(['{\it ' header{1} '}']);
    end
end

set(handles.status,'string','Original Data');
return


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


str=get(handles.basename, 'string');
basename = str;
X_test = handles.X_test;
headerline = 'Time (s), phi (deg), theta (deg), psi (deg), p (deg/s), q (deg/s), r (deg/s), ax (m/s^2), ay (m/s^2), az (m/s^2), Ve (m/s), Hp (m), T (C), P (Pa), aileron (deg), elevator (deg), rudder (deg), throttle (percentage) \n';
fid = fopen([basename '.csv'], 'w');
fprintf(fid, headerline);
fclose(fid);

dlmwrite([basename '.csv'], X_test, '-append', 'precision', '%.6f', 'delimiter', '\t');

set(handles.status,'string',[basename '.csv Successfully Saved']);
return


% --- Executes on button press in filter.
function filter_Callback(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str=get(handles.fil, 'string');
fil = str2num(str);
[b a] = butter(2, fil, 'low'); % filter

header = handles.header;

A = handles.A;

for ii = 2:numel(header)
    X_mags(:,ii) = abs(fft(A(:,ii)));
    X_fil(:,ii) = filter(b,a, A(:,ii));
end
X_fil(:,1) = A(:,1);
handles.X_fil = X_fil;

guidata(hObject,handles)

for ii = [2,3,4,11]
    if ii == 11
        ax(ii) = subplot(4,1,4, 'Parent', handles.attitudes);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5); hold on;
        plot(ax(ii),A(:,1),X_fil(:,ii),'r','LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
        xlabel(['{\it ' header{1} '}']);
        legend('data', 'filtered data');
    else
        ax(ii) = subplot(4,1,ii-1, 'Parent', handles.attitudes);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5); hold on;
        plot(ax(ii),A(:,1),X_fil(:,ii),'r','LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
    end
    hold off
end

for ii = [5,6,7,10]
    if ii == 10
        ax(ii) = subplot(4,1,4, 'Parent', handles.rates);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5); hold on;
        plot(ax(ii),A(:,1),X_fil(:,ii),'r','LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
        xlabel(['{\it ' header{1} '}']);
        legend('data', 'filtered data');
    else
        ax(ii) = subplot(4,1,ii-4, 'Parent', handles.rates);
        plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5); hold on;
        plot(ax(ii),A(:,1),X_fil(:,ii),'r','LineWidth',1.5);
        grid on; ylabel(['{\it ' header{ii} '}']);
    end
    hold off
end

for ii = 15:18
    ax(ii) = subplot(4,1,ii-14, 'Parent', handles.inputs);
    plot(ax(ii),A(:,1),A(:,ii),'LineWidth',1.5); hold on;
    plot(ax(ii),A(:,1),X_fil(:,ii),'r','LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 18
        xlabel(['{\it ' header{1} '}']);
        legend('data', 'filtered data');
    end
    hold off
end

set(handles.status,'string',['Data Successfully Filtered']);
return



function fil_Callback(hObject, eventdata, handles)
% hObject    handle to fil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fil as text
%        str2double(get(hObject,'String')) returns contents of fil as a double


% --- Executes during object creation, after setting all properties.
function fil_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function status_Callback(hObject, eventdata, handles)
% hObject    handle to status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of status as text
%        str2double(get(hObject,'String')) returns contents of status as a double


% --- Executes during object creation, after setting all properties.
function status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
