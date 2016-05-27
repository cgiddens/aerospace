function varargout = dispgrad_patch_contour_GUI(varargin)
% DISPGRAD_PATCH_CONTOUR_GUI M-file for dispgrad_patch_contour_GUI.fig
%      DISPGRAD_PATCH_CONTOUR_GUI, by itself, creates a new DISPGRAD_PATCH_CONTOUR_GUI or raises the existing
%      singleton*.
%
%      H = DISPGRAD_PATCH_CONTOUR_GUI returns the handle to a new DISPGRAD_PATCH_CONTOUR_GUI or the handle to
%      the existing singleton*.
%
%      DISPGRAD_PATCH_CONTOUR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPGRAD_PATCH_CONTOUR_GUI.M with the given input arguments.
%
%      DISPGRAD_PATCH_CONTOUR_GUI('Property','Value',...) creates a new DISPGRAD_PATCH_CONTOUR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dispgrad_patch_contour_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dispgrad_patch_contour_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dispgrad_patch_contour_GUI

% Last Modified by GUIDE v2.5 25-Oct-2012 10:28:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dispgrad_patch_contour_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @dispgrad_patch_contour_GUI_OutputFcn, ...
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


% --- Executes just before dispgrad_patch_contour_GUI is made visible.
function dispgrad_patch_contour_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dispgrad_patch_contour_GUI (see VARARGIN)

% Choose default command line output for dispgrad_patch_contour_GUI
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
handles.computed_data = varargin{1};

%Define the default values
unitE = '(%)';
scale = handles.computed_data.scale;
unitXY = '({\mu}m)';
if scale == 1
    unitXY = '(pixels)';
end
handles.param_dispgrad_patch_contour.unitE = unitE;
handles.param_dispgrad_patch_contour.unitXY = unitXY;
handles.param_dispgrad_patch_contour.data = [];
handles.param_dispgrad_patch_contour.plot_title = [];
handles.param_dispgrad_patch_contour.a = [];
handles.param_dispgrad_patch_contour.b = [];
handles.images_folder = 0;

%Reference grid only if no deformed grid has been computed
if isempty(handles.computed_data.gridx_DU_def)
    set(handles.tag_grid_selection,'foregroundcolor',[0.8 0.8 0.8])
    set(handles.tag_grid_ref,'enable','off')
    set(handles.tag_grid_def,'enable','off')
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dispgrad_patch_contour_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dispgrad_patch_contour_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.param_dispgrad_patch_contour;
delete(hObject);


% --- Executes on button press in tag_directory.
function tag_directory_Callback(hObject, eventdata, handles)
% hObject    handle to tag_directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start_path = cd;
dialog_title = 'Choose directory containing appropriate images';
images_folder = uigetdir(start_path,dialog_title);
set(handles.tag_directory_name,'string',images_folder);
handles.images_folder = images_folder;
guidata(hObject,handles);


function tag_directory_name_Callback(hObject, eventdata, handles)
% hObject    handle to tag_directory_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_directory_name as text
%        str2double(get(hObject,'String')) returns contents of tag_directory_name as a double


% --- Executes during object creation, after setting all properties.
function tag_directory_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_directory_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tag_extension.
function tag_extension_Callback(hObject, eventdata, handles)
% hObject    handle to tag_extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tag_extension contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_extension


% --- Executes during object creation, after setting all properties.
function tag_extension_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function tag_opacity_Callback(hObject, eventdata, handles)
% hObject    handle to tag_opacity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
opacity = get(hObject,'Value');
opacity = roundn(opacity,1);
set(hObject,'Value',opacity);
opacity_str = num2str(opacity);
set(handles.tag_opacity_value,'string',opacity_str);


% --- Executes during object creation, after setting all properties.
function tag_opacity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_opacity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function tag_opacity_value_Callback(hObject, eventdata, handles)
% hObject    handle to tag_opacity_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_opacity_value as text
%        str2double(get(hObject,'String')) returns contents of tag_opacity_value as a double
opacity = str2double(get(hObject,'string'));
opacity = roundn(opacity,1);
set(handles.tag_opacity,'value',opacity);
set(handles.tag_opacity_value,'string',num2str(opacity));


% --- Executes during object creation, after setting all properties.
function tag_opacity_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_opacity_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in tag_strains.
function tag_strains_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in tag_strains 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in tag_auto_each.
function tag_auto_each_Callback(hObject, eventdata, handles)
% hObject    handle to tag_auto_each (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_auto_each
yn_auto_each = get(hObject,'value');
if yn_auto_each == 1
    set(handles.tag_min_label,'enable','off')
    set(handles.tag_max_label,'enable','off')
    set(handles.tag_min,'enable','off')
    set(handles.tag_max,'enable','off')
end


% --- Executes on button press in tag_auto_all.
function tag_auto_all_Callback(hObject, eventdata, handles)
% hObject    handle to tag_auto_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_auto_all
yn_auto_all = get(hObject,'value');
if yn_auto_all == 1
    set(handles.tag_min_label,'enable','off')
    set(handles.tag_max_label,'enable','off')
    set(handles.tag_min,'enable','off')
    set(handles.tag_max,'enable','off')
end


% --- Executes on button press in tag_user_def.
function tag_user_def_Callback(hObject, eventdata, handles)
% hObject    handle to tag_user_def (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_user_def
yn_user_def = get(hObject,'value');
if yn_user_def == 1
    set(handles.tag_min_label,'enable','on')
    set(handles.tag_max_label,'enable','on')
    set(handles.tag_min,'enable','on')
    set(handles.tag_max,'enable','on')
end


function tag_min_Callback(hObject, eventdata, handles)
% hObject    handle to tag_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_min as text
%        str2double(get(hObject,'String')) returns contents of tag_min as a double


% --- Executes during object creation, after setting all properties.
function tag_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tag_max_Callback(hObject, eventdata, handles)
% hObject    handle to tag_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_max as text
%        str2double(get(hObject,'String')) returns contents of tag_max as a double


% --- Executes during object creation, after setting all properties.
function tag_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tag_set.
function tag_set_Callback(hObject, eventdata, handles)
% hObject    handle to tag_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Save the handles and resume the figure

%Get the image information:
scale = handles.computed_data.FEM_setup.scale;

contents_extension = get(handles.tag_extension,'string');
image_extension = contents_extension{get(handles.tag_extension,'Value')};

images_folder = handles.images_folder; %Get the image_folder
if images_folder == 0 %No folder was selected
    opacity = 1;
    images = [];
    xdata = [];
    ydata = [];
else %A folder was selected
    opacity = get(handles.tag_opacity, 'value');
    opacity = opacity/100; %Change from 0-100 scale to 0-1 scale
    
    %Get a list of all of the images in the folder
    try %Backslash for PCs
        images = dir([images_folder,'\*',image_extension]); 
    catch %Front slash for Macs
        images = dir([images_folder,'/*',image_extension]); 
    end
    if isempty(images)
        w = warndlg('There are no images in the selected folder.');
        waitfor(w)
        return
    end
    
    if isempty(image_extension)
        w = warndlg('You did not choose an image extension.');
        waitfor(w)
        return
    end
    
    %Get the size of the images
    try %Backslash for PCs
        image_size = size(imread([images_folder,'\',images(1).name])); 
    catch %Frontslash for Macs
        image_size = size(imread([images_folder,'/',images(1).name]));
    end
    
    %Scale the xdata and ydata of the images so it fits with the DIC data
    xdata = [0,image_size(2)*scale];
    ydata = [0,image_size(1)*scale];
end


handles.param_dispgrad_patch_contour.images_folder = images_folder;
handles.param_dispgrad_patch_contour.opacity = opacity;
handles.param_dispgrad_patch_contour.image_extension = image_extension;
handles.param_dispgrad_patch_contour.images = images;
handles.param_dispgrad_patch_contour.xdata = xdata;
handles.param_dispgrad_patch_contour.ydata = ydata;

%Get the computed data
N_images = handles.computed_data.corr_setup.N_images_correlated;

%Choose the grid to plot over:
gridx_DU = handles.computed_data.gridx_DU;
gridy_DU = handles.computed_data.gridy_DU;
gridx_DU_def = handles.computed_data.gridx_DU_def;
gridy_DU_def = handles.computed_data.gridy_DU_def;

% small_strain_ref = handles.computed_data.small_strain;
% large_strain_ref = handles.computed_data.large_strain;
% small_strain_def = handles.computed_data.small_strain_def;
% large_strain_def = handles.computed_data.large_strain_def;

grid_selection = get(get(handles.tag_grid_selection,'SelectedObject'),'string');
if strcmp(grid_selection,'Reference grid')
    gridx = gridx_DU;
    gridy = gridy_DU;
%     small_strain = small_strain_ref;
%     large_strain = large_strain_ref;
    
elseif strcmp(grid_selection,'Deformed grid')
    gridx = gridx_DU_def;
    gridy = gridy_DU_def;
%     small_strain = small_strain_def;
%     large_strain = large_strain_def;
    
end

handles.param_dispgrad_patch_contour.gridx = gridx;
handles.param_dispgrad_patch_contour.gridy = gridy;


%Choose the strain field
strain_selection = get(get(handles.tag_strains,'SelectedObject'),'string');

if strcmp(strain_selection,'e_xx')
    data = handles.computed_data.small_strain.exx;
    plot_title = '{\epsilon_{xx}} (infinitesimal strain)';
    
elseif strcmp(strain_selection,'e_xy')
    data = handles.computed_data.small_strain.exy;
    plot_title = '{\epsilon_{xy}} (infinitesimal strain)';
    
elseif strcmp(strain_selection,'e_yy')
    data = handles.computed_data.small_strain.eyy;
    plot_title = '{\epsilon_{yy}} (infinitesimal strain)';
    
elseif strcmp(strain_selection,'e_eqv')
    data = handles.computed_data.small_strain.eeqv;
    plot_title = '{\epsilon_{eqv}} (infinitesimal strain)';
    
elseif strcmp(strain_selection,'E_xx')
    data = handles.computed_data.large_strain.Exx;
    plot_title = '{E_{xx}} (finite strain)';
    
elseif strcmp(strain_selection,'E_xy')
    data = handles.computed_data.large_strain.Exy;
    plot_title = '{E_{xy}} (finite strain)';
    
elseif strcmp(strain_selection,'E_yy')
    data = handles.computed_data.large_strain.Eyy;
    plot_title = '{E_{yy}} (finite strain)';
    
elseif strcmp(strain_selection,'E_eqv')
    data = handles.computed_data.large_strain.Eeqv;
    plot_title = '{E_{eqv}} (finite strain)';
    
else %None of the options are selected
    w = warndlg('You did not set one of the parameters');
    waitfor(w);
    return
end

handles.param_dispgrad_patch_contour.data = data;
handles.param_dispgrad_patch_contour.plot_title = plot_title;


%Choose the scale
yn_auto_each = get(handles.tag_auto_each,'value');
yn_auto_all = get(handles.tag_auto_all,'value');
yn_user_def = get(handles.tag_user_def,'value');

if yn_auto_each == 1
    try %"data" is an array (i.e. ref grid is used)
        a = min(data);
        b = max(data);
    catch %"data" is a cell array (i.e. def grid is used)
        a = cellfun(@min,data,'uniformoutput',0);
        b = cellfun(@max,data,'uniformoutput',0);
        
        %Find empty cells
        index = cellfun(@isempty,a);
        a{index} = 0;
        a = cell2mat(a);
        
        index = cellfun(@isempty,b);
        b{index} = 0;
        b = cell2mat(b);
        
    end
        
elseif yn_auto_all == 1
    try
        a = min(min(data)) * ones(1,N_images);
        b = max(max(data)) * ones(1,N_images);
    catch
        a = cellfun(@min,data,'uniformoutput',0);
        b = cellfun(@max,data,'uniformoutput',0);
        
        %Find empty cells
        index = cellfun(@isempty,a);
        a{index} = 0;
        a = min(cell2mat(a)) * ones(1,N_images);

        
        index = cellfun(@isempty,b);
        b{index} = 0;
        b = min(cell2mat(b)) * ones(1,N_images);

    end
    
elseif yn_user_def == 1
    a = str2double(get(handles.tag_min,'string')) * ones(1,N_images);
    b = str2double(get(handles.tag_max,'string')) * ones(1,N_images);
    
else %None of the options are checked
    w = warndlg('You did not set one of the parameters');
    waitfor(w);
    return
    
end

%If a = b, replace a = -1 and b = 1
c = abs(a-b);
a(c<0.1) = -1;
b(c<0.1) = 1;

handles.param_dispgrad_patch_contour.a = a;
handles.param_dispgrad_patch_contour.b = b;


%Save the handles and resume the figure
handles.param_dispgrad_patch_contour.quit = 0;
guidata(hObject,handles);
uiresume(handles.figure1);


% --- Executes on button press in tag_quit.
function tag_quit_Callback(hObject, eventdata, handles)
% hObject    handle to tag_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.param_dispgrad_patch_contour.quit = 1;
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
