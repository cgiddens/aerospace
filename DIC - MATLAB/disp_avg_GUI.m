function varargout = disp_avg_GUI(varargin)
% DISP_AVG_GUI M-file for disp_avg_GUI.fig
%      DISP_AVG_GUI, by itself, creates a new DISP_AVG_GUI or raises the existing
%      singleton*.
%
%      H = DISP_AVG_GUI returns the handle to a new DISP_AVG_GUI or the handle to
%      the existing singleton*.
%
%      DISP_AVG_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISP_AVG_GUI.M with the given input arguments.
%
%      DISP_AVG_GUI('Property','Value',...) creates a new DISP_AVG_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before disp_avg_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to disp_avg_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help disp_avg_GUI

% Last Modified by GUIDE v2.5 21-Jul-2014 16:06:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @disp_avg_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @disp_avg_GUI_OutputFcn, ...
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


% --- Executes just before disp_avg_GUI is made visible.
function disp_avg_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to disp_avg_GUI (see VARARGIN)

% Choose default command line output for disp_avg_GUI
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

handles.scnsize = scnsize;
handles.GUIpos = position;

%Load the computed data
handles.N_images_correlated = varargin{1};
handles.N_pts = varargin{2};
handles.gridx = varargin{3};
handles.gridy = varargin{4};
handles.dispx = varargin{5};
handles.dispy = varargin{6};
handles.scale = varargin{7};
handles.corr_coeff = varargin{8};

if handles.scale == 1
    unit = '(pixels)';
else
    unit = '({\mu}m)';
end

handles.param_disp_avg.unit = unit;

%Define the ROI box on the plot
x = [0,0,1,1,0];
y = [0,1,1,0,0];
plot(x,y,'-y','linewidth',2)
axis ij
axis([-0.1,1.1,-0.1,1.1])

%Set the default values
handles.data_DIC_avg = [];
handles.param_disp_avg.y_label = [];
handles.param_disp_avg.data_avg = [];
handles.param_disp_avg.x = [];
set(handles.tag_frac,'string','0.5')
set(handles.tag_time_value,'string','10');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes disp_avg_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = disp_avg_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.param_disp_avg;
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


% --- Executes when selected object is changed in tag_x_axis.
function tag_x_axis_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in tag_x_axis 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
selection = get(eventdata.NewValue,'tag');
if strcmp(selection, 'tag_image') == 1
    set(handles.tag_time_value,'enable','off')
    set(handles.tag_time_value_label,'foregroundcolor',[0.8,0.8,0.8])
    set(handles.tag_time_unit,'foregroundcolor',[0.8,0.8,0.8])
elseif strcmp(selection, 'tag_time') == 1
    set(handles.tag_time_value,'enable','on')
    set(handles.tag_time_value_label,'foregroundcolor',[0 0 0])
    set(handles.tag_time_unit,'foregroundcolor',[0 0 0])
end


function tag_time_value_Callback(hObject, eventdata, handles)
% hObject    handle to tag_time_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_time_value as text
%        str2double(get(hObject,'String')) returns contents of tag_time_value as a double


% --- Executes during object creation, after setting all properties.
function tag_time_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_time_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tag_avg_image.
function tag_avg_image_Callback(hObject, eventdata, handles)
% hObject    handle to tag_avg_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_avg_image
yn_avg_image = get(hObject,'value');
if yn_avg_image == 1
    set(handles.tag_loc_dir,'foregroundcolor',[0.8,0.8,0.8])
    set(handles.tag_frac,'enable','off')
    set(handles.tag_frac_label,'foregroundcolor',[0.8,0.8,0.8])
    set(handles.tag_dir,'foregroundcolor',[0.8,0.8,0.8])
    set(handles.tag_hor,'enable','off')
    set(handles.tag_ver,'enable','off')
    set(handles.tag_refresh,'enable','off')
end


% --- Executes on button press in tag_avg_line_scan.
function tag_avg_line_scan_Callback(hObject, eventdata, handles)
% hObject    handle to tag_avg_line_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_avg_line_scan
yn_avg_line_scan = get(hObject,'value');
if yn_avg_line_scan == 1
    set(handles.tag_loc_dir,'foregroundcolor',[0,0,0])
    set(handles.tag_frac,'enable','on')
    set(handles.tag_frac_label,'foregroundcolor',[0,0,0])
    set(handles.tag_dir,'foregroundcolor',[0,0,0])
    set(handles.tag_hor,'enable','on')
    set(handles.tag_ver,'enable','on')
    set(handles.tag_refresh,'enable','on')
end


% --- Executes on button press in tag_avg_box.
function tag_avg_box_Callback(hObject, eventdata, handles)
% hObject    handle to tag_avg_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_avg_box

yn_avg_box = get(hObject,'value');
if yn_avg_box == 1
    set(handles.tag_loc_dir,'foregroundcolor',[0,0,0])
    set(handles.tag_frac,'enable','on')
    set(handles.tag_frac_label,'foregroundcolor',[0,0,0])
    set(handles.tag_dir,'foregroundcolor',[0.8 0.8 0.8])
    set(handles.tag_hor,'enable','off')
    set(handles.tag_ver,'enable','off')
    set(handles.tag_refresh,'enable','on')
end


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

%Draw the vertical line
frac = str2double(get(handles.tag_frac,'string'));
x = [1,1]*frac;
y = [0,1];
hold on
plot(x,y,'-r','linewidth',1)
hold off


% --- Executes on button press in tag_refresh.
function tag_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to tag_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the type of line/box to draw:
yn_avg_line_scan = get(handles.tag_avg_line_scan,'value');
yn_avg_box = get(handles.tag_avg_box,'value');

%Redraw the ROI rectangle:
x = [0,0,1,1,0];
y = [0,1,1,0,0];
plot(x,y,'-y','linewidth',2)
axis ij
axis([-0.1,1.1,-0.1,1.1])

frac = str2double(get(handles.tag_frac,'string'));

if yn_avg_line_scan == 1 %Line scan

    yn_hor = get(handles.tag_hor,'value');
    yn_ver = get(handles.tag_ver,'value');
    
    if yn_hor == 1 %Draw the horizontal line
        x = [0,1];
        y = [1,1]*frac;
    elseif yn_ver == 1 %Draw the vertical line
        x = [1,1]*frac;
        y = [0,1];
    end
    
    

elseif yn_avg_box == 1
    
    x = [0.5-frac/2, 0.5+frac/2, 0.5+frac/2, 0.5-frac/2, 0.5-frac/2];
    y = [0.5-frac/2, 0.5-frac/2, 0.5+frac/2, 0.5+frac/2, 0.5-frac/2];
end

hold on
plot(x,y,'-r','linewidth',1)
hold off
  

% --- Executes on button press in tag_plot_roi.
function tag_plot_Callback(hObject, eventdata, handles)
% hObject    handle to tag_plot_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the units
unit = handles.param_disp_avg.unit;

%Get the computed data
N_images = handles.N_images_correlated;
N_Node = handles.N_pts;
gridx = handles.gridx;
gridy = handles.gridy;
dispx = handles.dispx;
dispy = handles.dispy;
corr_coeff = handles.corr_coeff;

%Choose the x-axis
yn_image = get(handles.tag_image,'value');
yn_time = get(handles.tag_time,'value');

if yn_image == 1
    x = 1:1:N_images;
    x_label = 'Image number';
elseif yn_time == 1
    time_value = str2double(get(handles.tag_time_value,'string'));
    x = (1:1:N_images)*time_value/60; %Time in hours
    x_label = 'Time (hr)';
else %Neither option is checked
    x = [];
    x_label = [];
end

%Choose the displacement field
yn_U = get(handles.tag_U,'value');
yn_V = get(handles.tag_V,'value');
yn_mag = get(handles.tag_mag,'value');
yn_corr_coeff = get(handles.tag_corr_coeff,'value');

if yn_U == 1
    data = dispx;
    plot_title_data = 'U';
    y_label = ['U ',unit];
elseif yn_V == 1
    data = dispy;
    plot_title_data = 'V';
    y_label = ['V ',unit];
elseif yn_mag == 1
    data = sqrt(dispx.^2 + dispy.^2);
    plot_title_data = 'Displacement magnitude';
    y_label = ['Displacement magnitude ',unit];
elseif yn_corr_coeff == 1
    if isempty(corr_coeff)
        warningstring = {'The correlation coefficients were not saved.';...
            'This is likely because the data was correlated using an older version of this code.'};
        dlgname = 'No Corr Coeff';
        h = warndlg(warningstring,dlgname);
        return
    end
    data = corr_coeff;
    plot_title_data = 'Correlation coefficient';
    y_label = 'Correlation Coefficient';
else %None of the options are checked
    data = [];
    plot_title_data = [];
    y_label = [];
end


%% Spatially average the data
yn_avg_image = get(handles.tag_avg_image,'value');
yn_avg_line_scan = get(handles.tag_avg_line_scan,'value');
yn_avg_box = get(handles.tag_avg_box,'value');

%Put data into a cell array to match format of average functions
data = {data'};

if yn_avg_image == 1
    [data_avg,data_std,data_min,data_max] = average_image(data);
    plot_title = {[plot_title_data,' averaged over'];'entire image'};
    
elseif yn_avg_line_scan == 1
    %Set the line scan parameters
    yn_hor = get(handles.tag_hor,'value');
    yn_ver = get(handles.tag_ver,'value');

    if yn_hor == 1
        grid_location = gridy; %Grid to use to find the location of the line scan
        plot_title_dir = 'horizontal';
        plot_title_ROI_boundary = 'top';

    elseif yn_ver == 1
        grid_location = gridx; %Grid to use to find the location of the line scan
        plot_title_dir = 'vertical';
        plot_title_ROI_boundary = 'left';

    else %Neither box is checked
        grid_location = [];
    end
    
    %Make sure a direction was chosen:
    if isempty(grid_location)
        warndlg('You did not set one of the parameters')
    else
        plot_title_location = get(handles.tag_frac,'string');
        frac = str2double(get(handles.tag_frac,'string'));

        %Put grid data into a cell array to match format of average
        %functions
        gridx = {gridx};
        grid_location = {grid_location};
        
        [data_avg,data_std,data_min,data_max] = average_line_GUI_compatible(data,gridx,grid_location,frac);
        plot_title = {[plot_title_data,' averaged over'];...
            [plot_title_dir,' line ',plot_title_location,' from the ',plot_title_ROI_boundary,' of the image']};
    end
   
elseif yn_avg_box == 1
    
    frac = str2double(get(handles.tag_frac,'string')); %amount of image to average
    
    %Put grid data into a cell array to match format of average
    %functions
    gridx = {gridx};
    gridy = {gridy};
    
    [data_avg,data_std,data_min,data_max] = average_box(data,gridx,gridy,frac);
    
    plot_title = {[plot_title_data,' averaged over a box'];...
        ['centered at image center and encompassing ',num2str(frac*100),' % of the ROI']};
    
else %None of the options are checked
    w = warndlg('You did not set one of the parameters');
    waitfor(w);
    return
end

%Get data_avg out of cell array
data_avg = data_avg{1}';
data_std = data_std{1}';
data_min = data_min{1}';
data_max = data_max{1}';

%Save all the info to give back to plot function in visualize_data_GUI
handles.param_disp_avg.data_avg = data_avg;
handles.param_disp_avg.data_std = data_std;
handles.param_disp_avg.data_min = data_min;
handles.param_disp_avg.data_max = data_max;
handles.param_disp_avg.x = x;
handles.param_disp_avg.plot_title = plot_title;
handles.param_disp_avg.y_label = y_label;
handles.param_disp_avg.x_label = x_label;

%Check to make sure all parameters were chosen:
if isempty(handles.param_disp_avg.y_label)||...
        isempty(handles.param_disp_avg.data_avg)||...
        isempty(handles.param_disp_avg.x) 
    w = warndlg('You did not set one of the parameters');
    waitfor(w);
    return
end

%Save the handles
handles.param_disp_avg.quit = 0;
guidata(hObject,handles);
uiresume(handles.figure1);


% --- Executes on button press in tag_quit.
function tag_quit_Callback(hObject, eventdata, handles)
% hObject    handle to tag_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.param_disp_avg.quit = 1;
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
