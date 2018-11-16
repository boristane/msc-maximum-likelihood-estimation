function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 08-Aug-2015 11:22:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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
return 


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)
axes(handles.logo);
set(gca,'color','none')
imshow('cranfield_logo.jpg');
set(handles.buttongroup, 'SelectionChangeFcn',  @buttongroup_Selection);
set(handles.console,'string','Select a File');
set(handles.console,'string','Select a Mode');pause(0.5);
% Choose default command line output for gui
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in input.
function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.csv','Select the Data input file');
handles = guidata(hObject);
handles.input = [pathname filename];  %%any handle where value is to be stored
set(handles.file,'string',filename);
guidata(hObject,handles)
handles.filename = filename;

guidata(hObject,handles)


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.console,'string','Estimating Parameters');pause(0.5);
type = handles.buttongroup;
%pixhawk_post_processing
filename = handles.input;
if strcmp(handles.buttongroup, 'long')
    load(handles.constants);
    c = p;
elseif strcmp(handles.buttongroup, 'lat')
    load(handles.constants);
    c = p;
    [filename1,pathname1] = uigetfile('*.mat','Select the Constant roll mode input file');
    load([pathname1 filename1]);
    c = [c p];
else
    c = 0;
end

j31test
my_oe_lat
input_plot
output_plot
residuals_plot
colnames = {'Parameter','Estimate','Std Error', '% Error', '95% Confidence Interval'};
for ii = 1:numel(p)
    temp1{ii} = p(ii);
    temp2{ii} = real(serr(ii));
    temp3{ii} = real(perr(ii));
    temp4{ii} = ['[' num2str(p(ii)-2*real(serr(ii)),'%8.3f') ' , ' num2str(p(ii)+2*real(serr(ii)),'%8.3f') ']'];
end
clear p serr;
p = temp1; serr = temp2; perr = temp3; confidence = temp4;
clear temp1 temp2 temp3 temp4;
data_table = [pnames; p; serr; perr; confidence];
set(handles.table,'data',data_table','ColumnName',colnames);

handles.results = data_table;
handles.z = z;
handles.u = u;
handles.y = y;
handles.inputsLabels = inputs;
handles.outputsLabels = outputs;
handles.time = time;
handles.xs = xs;

guidata(hObject,handles)
% set(handles.table,'data',p,'ColumnName');
% set(handles.table,'data',serr,'ColumnName');
return


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
close gui;
gui;



function console_Callback(hObject, eventdata, handles)
% hObject    handle to console (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of console as text
%        str2double(get(hObject,'String')) returns contents of console as a double


% --- Executes during object creation, after setting all properties.
function console_CreateFcn(hObject, eventdata, handles)
% hObject    handle to console (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on push button selection.
function buttongroup_Selection(hObject, eventdata)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
switch get(eventdata.NewValue,  'Tag' )
case 'sppo'
    handles.buttongroup= 'SPPO';  %%any handle where value is to be stored
    set(handles.console,'string','SPPO Mode Selected');pause(0.5);
case 'dutch'
    handles.buttongroup = 'dutch';
    set(handles.console,'string','Dutch Roll Mode Selected');pause(0.5);
case 'roll'
    handles.buttongroup= 'roll';
    set(handles.console,'string','Roll Mode Selected');pause(0.5);
case 'long'
    handles.buttongroup= 'long';
    set(handles.console,'string','Longitudinal Mode Selected');pause(0.5);
case 'lat'
    handles.buttongroup= 'lat';
    set(handles.console,'string','Lateral/Directional Mode Selected');pause(0.5);
end
guidata(hObject,handles)
return



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


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

results = handles.results;
filename = handles.filename;
p = cell2mat(results(2,:));
n = numel(filename);
temp = filename(1:n-4);
save([temp '-states.mat'],'p');
results = results';
save([temp '-results.mat'],'results');

time = handles.time;
y = handles.y;
z = handles.z;
u = handles.u;
xs = handles.xs;
inputs = handles.inputsLabels;
outputs = handles.outputsLabels;

if strcmp(handles.buttongroup,'SPPO')
    inputIndex = 1;
    outputIndex = 2;
elseif strcmp(handles.buttongroup,'dutch')
    inputIndex = 2;
    outputIndex = [2];
elseif strcmp(handles.buttongroup,'roll')
    inputIndex = 1;
    outputIndex = 1;
elseif strcmp(handles.buttongroup,'long')
    inputIndex = 1;
    outputIndex = [3,4];
elseif strcmp(handles.buttongroup,'lat')
    inputIndex = [1,2];
    outputIndex = [2,3];
end

FgH=figure('Units','normalized',...
           'Position',[.43 .14 .56 .90],...
           'Color',[0.8 0.8 0.8],...
           'Name','Output-Error Parameter Estimation',...
           'NumberTitle','off',...
           'Tag','Fig1');
       
subplotCompt = 1;
for ii = inputIndex
    subplot(2*numel(outputIndex)+numel(inputIndex),1,subplotCompt);
    plot(time,u(:,ii), '-b', 'Linewidth', 1.5);
    ylabel(['{\it ' inputs(ii,:) ' }']);
    grid on;
    subplotCompt = subplotCompt+1;
end

x0=xs(1,:)';
for ii = outputIndex
    subplot(2*numel(outputIndex)+numel(inputIndex),1,subplotCompt);
    plot(time,z(:,ii), '-b', 'Linewidth', 1.5);hold on;
    plot(time,y(:,ii), '--r', 'Linewidth', 1.5);
    ylabel(['{\it ' outputs(ii,:) ' }']);
    grid on;
if ii == outputIndex(1)
    legend('Measured', 'Model');
end
    hold on,plot(time(1),x0(ii),'r.','LineWidth',2,'MarkerSize',14),hold off;
    subplotCompt = subplotCompt+1;
end

for ii = outputIndex
    subplot(2*numel(outputIndex)+numel(inputIndex),1,subplotCompt);
    plot(time,z(:,ii)-y(:,ii), '-k', 'Linewidth',1.5);
    ylabel(['{\it {\fontsize{15} \upsilon}[' outputs(ii,:) '] }']);
    grid on;
if ii == outputIndex(end)
    xlabel('{\it Time (s)}');
    legend('Innovation');
end
    subplotCompt = subplotCompt+1;
end




% --- Executes on button press in constants_button.
function constants_button_Callback(hObject, eventdata, handles)
% hObject    handle to constants_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.mat','Select the Constant input file');
handles = guidata(hObject);
handles.constants_button = [pathname filename];  %%any handle where value is to be stored
set(handles.mat,'string',filename);
guidata(hObject,handles)
handles.constants = handles.constants_button;

guidata(hObject,handles)



function mat_Callback(hObject, eventdata, handles)
% hObject    handle to mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mat as text
%        str2double(get(hObject,'String')) returns contents of mat as a double


% --- Executes during object creation, after setting all properties.
function mat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
