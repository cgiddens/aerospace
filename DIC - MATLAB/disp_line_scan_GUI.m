function varargout = disp_line_scan_GUI(varargin)
% DISP_LINE_SCAN_GUI M-file for disp_line_scan_GUI.fig
%      DISP_LINE_SCAN_GUI, by itself, creates a new DISP_LINE_SCAN_GUI or raises the existing
%      singleton*.
%
%      H = DISP_LINE_SCAN_GUI returns the handle to a new DISP_LINE_SCAN_GUI or the handle to
%      the existing singleton*.
%
%      DISP_LINE_SCAN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISP_LINE_SCAN_GUI.M with the given input arguments.
%
%      DISP_LINE_SCAN_GUI('Property','Value',...) creates a new DISP_LINE_SCAN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before disp_line_scan_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to disp_line_scan_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help disp_line_scan_GUI

% Last Modified by GUIDE v2.5 20-May-2012 22:00:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @disp_line_scan_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @disp_line_scan_GUI_OutputFcn, ...
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


% --- Executes just before disp_line_scan_GUI is made visible.
function disp_line_scan_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to disp_line_scan_GUI (see VARARGIN)

% Choose default command line output for disp_line_scan_GUI
handles.output = hObject;

%Locate the GUI at the top-left of the screen
set(0,'Units','pixels') 
scnsize = get(0,'ScreenSize');
scnheight = scnsize(4);
set(gcf,'units','pixels')
GUIpos = get(gcf,'OuterPosition');
GUIwidth = GUIpos(3);
GUIheight = GUIpos(4);
leftborder = 75;
topborder = 10;
bottomborder = scnheight - GUIheight - topborder;
position = [leftborder,bottomborder,GUIwidth,GUIheight];
set(gcf,'OuterPosition',position)

handles.GUIpos = GUIpos;

%Load the computed data
handles.N_images_correlated = varargin{1};
handles.N_pts = varargin{2};
handles.corr_coeff = varargin{3};
handles.gridx = varargin{4};
handles.gridy = varargin{5};
handles.dispx = varargin{6};
handles.dispy = varargin{7};
handles.scale = varargin{8};

%Define the ROI box on the plot
x = [0,0,1,1,0];
y = [0,1,1,0,0];
plot(x,y,'-y','linewidth',2)
axis ij
axis([-0.1,1.1,-0.1,1.1])

%Set the default values
if handles.scale == 1
    unit_x = '(pixels)';
    unit_y = '(pixels)';
else
    unit_x = '({\mu}m)';
    unit_y = '({\mu}m)';
end
handles.param_disp_line_scan.grid_plot_scan = [];
handles.param_disp_line_scan.data_scan = [];
handles.param_disp_line_scan.x_label = [];
handles.param_disp_line_scan.y_label = [];
handles.param_disp_line_scan.plot_title_data = [];
handles.param_disp_line_scan.plot_title_location = [];
handles.param_disp_line_scan.plot_title_dir = [];
handles.param_disp_line_scan.plot_title_ROI_boundary = [];
handles.param_disp_line_scan.unit_x = unit_x;
handles.param_disp_line_scan.unit_y = unit_y;

set(handles.tag_frac,'string','0.5');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes disp_line_scan_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = disp_line_scan_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.param_disp_line_scan;
delete(hObject);


% --- Executes on button press in tag_U.
function tag_U_Callback(hObject, eventdata, handles)
% hObject    handle to tag_U (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_U


% --- Executes on button press in tag_V.
function tag_V_Callback(hObject, eventdata, handles)
% hObject    handle to tag_V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_V


function tag_frac_Callback(hObject, eventdata, handles)
% hObject    handle to tag_frac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_frac as text
%        str2double(get(hObject,'String')) returns contents of tag_frac as a double


% --- Executes during object creation, after setting all properties.
function tag_frac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_frac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tag_hor.
function tag_hor_Callback(hObject, eventdata, handles)
% hObject    handle to tag_hor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_hor

%Redraw the ROI rectangle:
x = [0,0,1,1,0];
y = [0,1,1,0,0];
plot(x,y,'-y','linewidth',2)
axis ij
axis([-0.1,1.1,-0.1,1.1])

%Draw the horizontal line
frac = str2double(get(handles.tag_frac,'string'));
x = [0,1];
y = [1,1]*frac;
hold on
plot(x,y,'-r','linewidth',1)
hold off


% --- Executes on button press in tag_ver.
function tag_ver_Callback(hObject, eventdata, handles)
% hObject    handle to tag_ver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_ver

%Redraw the ROI rectangle:
x = [0,0,1,1,0];
y = [0,1,1,0,0];
plot(x,y,'-y','linewidth',2)
axis ij
axis([-0.1,1.1,-0.1,1.1])

%Draw the horizontal line
frac = str2double(get(handles.tag_frac,'string'));
x = [1,1]*frac;
y = [0,1];
hold on
plot(x,y,'-r','linewidth',1)
hold off


% --- Executes on button press in tag_set.
function tag_set_Callback(hObject, eventdata, handles)
% hObject    handle to tag_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the units
unit_x = handles.param_disp_line_scan.unit_x;
unit_y = handles.param_disp_line_scan.unit_y;

%Get the computed data
N_images = handles.N_images_correlated;
N_Node = handles.N_pts;
gridx = handles.gridx;
gridy = handles.gridy;
dispx = handles.dispx;
dispy = handles.dispy;
corr_coeff = handles.corr_coeff;

%Choose the displacement field
yn_U = get(handles.tag_U,'value');
yn_V = get(handles.tag_V,'value');
yn_corr_coeff = get(handles.tag_corr_coeff,'value');

if yn_U == 1
    data = dispx;
    plot_title_data = 'U';
    y_label = ['U ',unit_y];
elseif yn_V == 1
    data = dispy;
    plot_title_data = 'V';
    y_label = ['V ',unit_y];
elseif yn_corr_coeff == 1
    if isempty(corr_coeff)
        warningstring = {'The correlation coefficients were not saved.';...
            'This is likely because the data was correlated using an older version of this code.'};
        dlgname = 'No Corr Coeff';
        h = warndlg(warningstring,dlgname);
        return
    end
    data = corr_coeff;
    plot_title_data = 'Correlation Coefficient';
    y_label = 'Correlation Coefficient';
else %None of the options are checked
    plot_title_data = [];
    y_label = [];
end

handles.param_disp_line_scan.plot_title_data = plot_title_data;
handles.param_disp_line_scan.y_label = y_label;

%Choose what location you want to scan across:
plot_title_location = get(handles.tag_frac,'string');
frac = str2double(get(handles.tag_frac,'string'));

handles.param_disp_line_scan.plot_title_location = plot_title_location;

%Choose what direction you want to scan across
yn_hor = get(handles.tag_hor,'value');
yn_ver = get(handles.tag_ver,'value');

if yn_hor == 1
    grid_plot = gridx; %Grid we're plotting against
    grid_location = gridy; %Grid to use to find the location of the line scan
   
    plot_title_dir = 'horizontal';
    plot_title_ROI_boundary = 'top';
    x_label = ['X ',unit_x];
    
elseif yn_ver == 1
    grid_plot = gridy; %Grid of interest for vertical line scans is the gridy
    grid_location = gridx; %Grid to use to find the location of the line scan
    
    plot_title_dir = 'vertical';
    plot_title_ROI_boundary = 'left';
    x_label = ['Y ',unit_x];
    
else %Neither box is checked
    grid_plot = [];
    grid_location = [];
    plot_title_dir = [];
    plot_title_ROI_boundary = [];
    x_label = [];
end

if isempty(y_label) == 0 && isempty(x_label) == 0
    grid_location_sort = sort(grid_location); %Sort the values of the location-grid
    index = ceil(N_Node*frac); %index of the grid_other-value that is "location" fraction from the top of the ROI
    value = grid_location_sort(index); %grid_other-value that is "location" from the top/left of the ROI
    grid_index = find(grid_location == value); %index values of ALL the grid_other-entries that are the same value as y_value
    N_pts_scan = length(grid_index); %Number of points in the line scan
    
    grid_plot_scan = zeros(N_pts_scan,1);
    data_scan = zeros(N_pts_scan,N_images);
    for i = 1:N_pts_scan %Loop over the number of points in the scan
        index_i = grid_index(i); %Get the i'th index
        grid_plot_scan(i) = grid_plot(index_i); %Get the i'th point in the grid_scan
        data_scan(i,:) = data(index_i,:); %Get the i'th data points in the scan
    end
    
else
    grid_plot_scan = [];
    data_scan = [];
end

handles.param_disp_line_scan.grid_plot_scan = grid_plot_scan;
handles.param_disp_line_scan.data_scan = data_scan;
handles.param_disp_line_scan.plot_title_dir = plot_title_dir;
handles.param_disp_line_scan.plot_title_ROI_boundary = plot_title_ROI_boundary;
handles.param_disp_line_scan.x_label = x_label;

%Make sure all parameters have been chosen:
if isempty(handles.param_disp_line_scan.data_scan ) %One of the options in the parameters was not choosen
    w = warndlg('You did not set one of the parameters');
    waitfor(w);
    return
end

%Save the handles and resume the figure
handles.param_disp_line_scan.quit = 0;
guidata(hObject,handles);
uiresume(handles.figure1);


% --- Executes on button press in tag_quit.
function tag_quit_Callback(hObject, eventdata, handles)
% hObject    handle to tag_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.param_disp_line_scan.quit = 1;
guidata(hObject,handles);
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, use UIRESUME and return
    uiresume(hObject);
else
    % The GUI is no longer waiting, so destroy it now.
    delete(hObject);
end
