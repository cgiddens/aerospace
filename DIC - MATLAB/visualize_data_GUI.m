function varargout = visualize_data_GUI(varargin)
% VISUALIZE_DATA_GUI M-file for visualize_data_GUI.fig
%      VISUALIZE_DATA_GUI, by itself, creates a new VISUALIZE_DATA_GUI or raises the existing
%      singleton*.
%
%      H = VISUALIZE_DATA_GUI returns the handle to a new VISUALIZE_DATA_GUI or the handle to
%      the existing singleton*.
%
%      VISUALIZE_DATA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALIZE_DATA_GUI.M with the given input arguments.
%
%      VISUALIZE_DATA_GUI('Property','Value',...) creates a new VISUALIZE_DATA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before visualize_data_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to visualize_data_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help visualize_data_GUI

% Last Modified by GUIDE v2.5 10-Jun-2014 20:29:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @visualize_data_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_data_GUI_OutputFcn, ...
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


% --- Executes just before visualize_data_GUI is made visible.
function visualize_data_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to visualize_data_GUI (see VARARGIN)

% Choose default command line output for visualize_data_GUI
handles.output = hObject;

%Locate the main GUI at the top-left of the screen
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
newGUIpos = [leftborder,bottomborder,GUIwidth,GUIheight];
set(gcf,'OuterPosition',newGUIpos)

handles.scnsize = scnsize;
handles.GUIpos = newGUIpos;

% Hints: contents = cellstr(get(hObject,'String')) returns tag_data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_data


%Get data selection
data_selection = get(handles.tag_data,'value');

%Load the computed data:
[grid_setup,reduction,corr_setup,FEM_setup,gridx,gridy,...
    dispx_smooth,dispy_smooth,dispx_raw,dispy_raw,corr_coeff_full,scale,...
    small_strain,large_strain,gridx_DU,gridy_DU,...
    grid_setup_reduced,gridx_reduced,gridy_reduced,...
    corr_setup_reduced,dispx_reduced,dispy_reduced,corr_coeff_reduced,...
    gridx_def,gridy_def,gridx_DU_def,gridy_DU_def] = load_computed_data;


handles.computed_data.grid_setup = grid_setup;
handles.computed_data.reduction = reduction;
handles.computed_data.corr_setup = corr_setup;
handles.computed_data.FEM_setup = FEM_setup;
handles.computed_data.gridx = gridx;
handles.computed_data.gridy = gridy;
handles.computed_data.scale = scale;
handles.computed_data.dispx_smooth = dispx_smooth;
handles.computed_data.dispy_smooth = dispy_smooth;
handles.computed_data.dispx_raw = dispx_raw;
handles.computed_data.dispy_raw = dispy_raw;
handles.computed_data.corr_coeff_full = corr_coeff_full;
handles.computed_data.small_strain = small_strain;
handles.computed_data.large_strain = large_strain;
handles.computed_data.gridx_DU = gridx_DU;
handles.computed_data.gridy_DU = gridy_DU;
handles.computed_data.grid_setup_reduced = grid_setup_reduced;
handles.computed_data.gridx_reduced = gridx_reduced;
handles.computed_data.gridy_reduced = gridy_reduced;
handles.computed_data.corr_setup_reduced = corr_setup_reduced;
handles.computed_data.dispx_reduced = dispx_reduced;
handles.computed_data.dispy_reduced = dispy_reduced;
handles.computed_data.corr_coeff_reduced = corr_coeff_reduced;
handles.computed_data.gridx_def = gridx_def;
handles.computed_data.gridy_def = gridy_def;
handles.computed_data.gridx_DU_def = gridx_DU_def;
handles.computed_data.gridy_DU_def = gridy_DU_def;


%Check to see if there is any reduced data
if isempty(grid_setup_reduced) && data_selection==1 %Reduced data
    set(handles.tagDispVec,'enable','off')
    set(handles.tagDispPatchContour,'enable','off')
    set(handles.tag_disp_line_scan,'enable','off')
    set(handles.tag_disp_avg,'enable','off')
    
end

%With the default being reduced data, set the default to raw data also
%You can enable the smoothed option by clicking on "full data"
set(handles.tag_raw_smooth,'value',1) %Raw
set(handles.tag_raw_smooth,'enable','off')


%Check to see if there are displacement gradients:
N_Node_DU = FEM_setup.N_Node_DU;

%There are no displacement gradients
if isempty(N_Node_DU) || data_selection==1 %Reduced data
    set(handles.tag_dispgrad_patch_contour,'enable','off')
    set(handles.tag_dispgrad_line_scan,'enable','off')
    set(handles.tag_dispgrad_avg,'enable','off')

%N_Node_DU ~= 0 --> There are displacement gradients
elseif ~isempty(N_Node_DU) && data_selection==2 %Full data
    set(handles.tag_dispgrad_patch_contour,'enable','on')
    set(handles.tag_dispgrad_line_scan,'enable','on')
    set(handles.tag_dispgrad_avg,'enable','on')
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes visualize_data_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = visualize_data_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = get(handles.text_box,'string')
close all
% delete(hObject);


function tag_image_skip_Callback(hObject, eventdata, handles)
% hObject    handle to tag_image_skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of tag_image_skip as text
%        str2double(get(hObject,'String')) returns contents of tag_image_skip as a double
% image_skip = str2double(get(hObject,'String'));
% handles.image_skip = image_skip;
% gui(hObject,handles);


% --- Executes during object creation, after setting all properties.
function tag_image_skip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_image_skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tag_data.
function tag_data_Callback(hObject, eventdata, handles)
% hObject    handle to tag_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tag_data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_data

data_selection = get(hObject,'value');

grid_setup_reduced = handles.computed_data.grid_setup_reduced;
grid_setup = handles.computed_data.grid_setup;
dispx_smooth = handles.computed_data.dispx_smooth;

%Check to see if there is any reduced data
if (isempty(grid_setup_reduced) && data_selection==1)... %Reduced data
        || (isempty(grid_setup) && data_selection==2) %Full data
    set(handles.tagDispVec,'enable','off')
    set(handles.tagDispPatchContour,'enable','off')
    set(handles.tag_disp_line_scan,'enable','off')
    set(handles.tag_disp_avg,'enable','off')
    
else
    set(handles.tagDispVec,'enable','on')
    set(handles.tagDispPatchContour,'enable','on')
    set(handles.tag_disp_line_scan,'enable','on')
    set(handles.tag_disp_avg,'enable','on')
    
end

%Check to see if there are displacement gradients:
N_Node_DU = handles.computed_data.FEM_setup.N_Node_DU;

%There are no displacement gradients
if isempty(N_Node_DU) || data_selection==1 %Reduced data
    set(handles.tag_dispgrad_patch_contour,'enable','off')
    set(handles.tag_dispgrad_line_scan,'enable','off')
    set(handles.tag_dispgrad_avg,'enable','off')

%N_Node_DU ~= 0 --> There are displacement gradients
elseif ~isempty(N_Node_DU) && data_selection==2 %Full data
    set(handles.tag_dispgrad_patch_contour,'enable','on')
    set(handles.tag_dispgrad_line_scan,'enable','on')
    set(handles.tag_dispgrad_avg,'enable','on')
end

%If looking at reduced data, only option is raw data (no smoothed)
if data_selection == 1 %Reduced data
    set(handles.tag_raw_smooth,'value',1) %Raw
    set(handles.tag_raw_smooth,'enable','off')
elseif data_selection == 2 &&  ~isempty(dispx_smooth) %Full data and have smoothed data
    set(handles.tag_raw_smooth,'value',2) %Default: smoothed
    set(handles.tag_raw_smooth,'enable','on')
elseif data_selection == 2 && isempty(dispx_smooth) %Full data, but no smoothed displacements
    set(handles.tag_raw_smooth,'value',1) %Raw
    set(handles.tag_raw_smooth,'enable','off')
end



% --- Executes during object creation, after setting all properties.
function tag_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tag_raw_smooth.
function tag_raw_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to tag_raw_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tag_raw_smooth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_raw_smooth


% --- Executes during object creation, after setting all properties.
function tag_raw_smooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_raw_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tagDispVec.
function tagDispVec_Callback(hObject, eventdata, handles)
% hObject    handle to tagDispVec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Get data selection
data_selection = get(handles.tag_data,'value');

%Get raw/smooth choice:
raw_smooth = get(handles.tag_raw_smooth,'value');

if data_selection==1 %Reduced data
    dispx = handles.computed_data.dispx_reduced;
    dispy = handles.computed_data.dispy_reduced;
    grid_setup = handles.computed_data.grid_setup_reduced;
    reduction = grid_setup.reduction;
    N_images_correlated = handles.computed_data.corr_setup_reduced.N_images_correlated;
    scale = 1;

elseif data_selection==2 %Full data
    if raw_smooth == 1 %Raw data
        dispx = handles.computed_data.dispx_raw;
        dispy = handles.computed_data.dispy_raw;
    elseif raw_smooth == 2 %Smoothed data
        dispx = handles.computed_data.dispx_smooth;
        dispy = handles.computed_data.dispy_smooth;
    end
    reduction = 1;
    N_images_correlated = handles.computed_data.corr_setup.N_images_correlated;
    scale = handles.computed_data.scale;
    
end


%Get the skip image value:
skip = str2double(get(handles.tag_image_skip,'string'));

%Set the vector field parameters:
quiver_param = vector_field_GUI(handles.computed_data,reduction);
if quiver_param.quit == 1
    return
end
  
%Get the main GUI position and set the figure to be just to the right of the GUI
scnsize = handles.scnsize; %in pixels
GUIpos = handles.GUIpos; %in pixels

leftborder = 10;
topborder = 10;

figheight = 700;
figwidth = 875;

figleft = GUIpos(1) + GUIpos(3) + leftborder;
figbottom = scnsize(4) - figheight - topborder;

figpos = [figleft,figbottom,figwidth,figheight];

% Plot the vector field
vector_field_GUI_compatible(figpos,quiver_param,N_images_correlated,skip,...
    dispx,dispy,scale,reduction)


% --- Executes on button press in tagDispPatchContour.
function tagDispPatchContour_Callback(hObject, eventdata, handles)
% hObject    handle to tagDispPatchContour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get data selection
data_selection = get(handles.tag_data,'value');
raw_smooth = get(handles.tag_raw_smooth,'value');

if data_selection==1 %Reduced data
    dispx = handles.computed_data.dispx_reduced;
    dispy = handles.computed_data.dispy_reduced;
    corr_coeff = handles.computed_data.corr_coeff_reduced;
    N_pts = handles.computed_data.grid_setup_reduced.N_pts;
    grid_setup = handles.computed_data.grid_setup_reduced;
    N_images_correlated = handles.computed_data.corr_setup_reduced.N_images_correlated;
    reduction = grid_setup.reduction;
    scale = 1;

elseif data_selection==2 %Full data
    corr_coeff = handles.computed_data.corr_coeff_full;
    if raw_smooth == 1 %Raw data
        dispx = handles.computed_data.dispx_raw;
        dispy = handles.computed_data.dispy_raw;
    elseif raw_smooth == 2 %Smoothed data
        dispx = handles.computed_data.dispx_smooth;
        dispy = handles.computed_data.dispy_smooth;
    end
    N_pts = handles.computed_data.grid_setup.N_pts;
    grid_setup = handles.computed_data.grid_setup;
    N_images_correlated = handles.computed_data.corr_setup.N_images_correlated;
    reduction = 1;
    scale = handles.computed_data.scale;
    
end


%Get the skip image value:
skip = str2double(get(handles.tag_image_skip,'string'));

%Set the patch contour parameters:
param_disp_patch_contour = disp_patch_contour_GUI(scale,N_images_correlated,...
    dispx,dispy,corr_coeff,reduction,handles.computed_data);
if param_disp_patch_contour.quit == 1
    return
end


%Get the main GUI position and set the figure to be just to the right of the GUI
scnsize = handles.scnsize; %in pixels
GUIpos = handles.GUIpos; %in pixels

leftborder = 10;
topborder = 10;

figheight = 700;
figwidth = 875;

figleft = GUIpos(1) + GUIpos(3) + leftborder;
figbottom = scnsize(4) - figheight - topborder;

figpos = [figleft,figbottom,figwidth,figheight];

% Plot the patch contour plot
patch_contour_GUI_compatible_improved(figpos,N_images_correlated,skip,grid_setup,...
    reduction,scale,N_pts,param_disp_patch_contour)


% --- Executes on button press in tag_disp_line_scan.
function tag_disp_line_scan_Callback(hObject, eventdata, handles)
% hObject    handle to tag_disp_line_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the computed data:

%Get data selection
data_selection = get(handles.tag_data,'value');
raw_smooth = get(handles.tag_raw_smooth,'value');

if data_selection==1 %Reduced data
    reduction = handles.computed_data.corr_setup_reduced.reduction;
    gridx = handles.computed_data.gridx_reduced*reduction;
    gridy = handles.computed_data.gridy_reduced*reduction;
    dispx = handles.computed_data.dispx_reduced;
    dispy = handles.computed_data.dispy_reduced;
    corr_coeff = handles.computed_data.corr_coeff_reduced;
    N_pts = handles.computed_data.grid_setup_reduced.N_pts;
    grid_setup = handles.computed_data.grid_setup_reduced;
    N_images_correlated = handles.computed_data.corr_setup_reduced.N_images_correlated;
    scale = 1;

elseif data_selection==2 %Full data
    gridx = handles.computed_data.gridx;
    gridy = handles.computed_data.gridy;
    corr_coeff = handles.computed_data.corr_coeff_full;
    if raw_smooth == 1 %Raw data
        dispx = handles.computed_data.dispx_raw;
        dispy = handles.computed_data.dispy_raw;
    elseif raw_smooth == 2 %Smoothed data
        dispx = handles.computed_data.dispx_smooth;
        dispy = handles.computed_data.dispy_smooth;
    end
    N_pts = handles.computed_data.grid_setup.N_pts;
    grid_setup = handles.computed_data.grid_setup;
    N_images_correlated = handles.computed_data.corr_setup.N_images_correlated;
    scale = handles.computed_data.scale;
    
end


%Get the skip image value:
skip = str2double(get(handles.tag_image_skip,'string'));

% Set the line scan parameters
param_disp_line_scan = disp_line_scan_GUI(N_images_correlated,N_pts,...
    corr_coeff,gridx,gridy,dispx,dispy,scale);
if param_disp_line_scan.quit == 1
    return
end

    
%Get the main GUI position and set the figure to be just to the right of the GUI
scnsize = handles.scnsize; %in pixels
GUIpos = handles.GUIpos; %in pixels

leftborder = 10;
topborder = 10;

figheight = 700;
figwidth = 875;

figleft = GUIpos(1) + GUIpos(3) + leftborder;
figbottom = scnsize(4) - figheight - topborder;

figpos = [figleft,figbottom,figwidth,figheight];

% Plot the line scan plot
line_scan_GUI_compatible(figpos,N_images_correlated,skip,param_disp_line_scan)


% --- Executes on button press in tag_disp_avg.
function tag_disp_avg_Callback(hObject, eventdata, handles)
% hObject    handle to tag_disp_avg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the computed data:

%Get data selection
data_selection = get(handles.tag_data,'value');
raw_smooth = get(handles.tag_raw_smooth,'value');

if data_selection==1 %Reduced data
    gridx = handles.computed_data.gridx_reduced;
    gridy = handles.computed_data.gridy_reduced;
    corr_coeff = handles.computed_data.corr_coeff_reduced;
    dispx = handles.computed_data.dispx_reduced;
    dispy = handles.computed_data.dispy_reduced;
    N_pts = handles.computed_data.grid_setup_reduced.N_pts;
    grid_setup = handles.computed_data.grid_setup_reduced;
    N_images_correlated = handles.computed_data.corr_setup_reduced.N_images_correlated;
    scale = 1;

elseif data_selection==2 %Full data
    gridx = handles.computed_data.gridx;
    gridy = handles.computed_data.gridy;
    corr_coeff = handles.computed_data.corr_coeff_full;
    if raw_smooth == 1 %Raw data
        dispx = handles.computed_data.dispx_raw;
        dispy = handles.computed_data.dispy_raw;
    elseif raw_smooth == 2 %Smoothed data
        dispx = handles.computed_data.dispx_smooth;
        dispy = handles.computed_data.dispy_smooth;
    end
    N_pts = handles.computed_data.grid_setup.N_pts;
    grid_setup = handles.computed_data.grid_setup;
    N_images_correlated = handles.computed_data.corr_setup.N_images_correlated;
    scale = handles.computed_data.scale;
    
end


% Set the line scan parameters
param_disp_avg = disp_avg_GUI(N_images_correlated,N_pts,gridx,gridy,dispx,dispy,scale,corr_coeff);

if param_disp_avg.quit == 1
    return
end

%Get the main GUI position and set the figure to be just to the right of the GUI
scnsize = handles.scnsize; %in pixels
GUIpos = handles.GUIpos; %in pixels

leftborder = 10;
topborder = 10;

figheight = 700;
figwidth = 875;

figleft = GUIpos(1) + GUIpos(3) + leftborder;
figbottom = scnsize(4) - figheight - topborder;

figpos = [figleft,figbottom,figwidth,figheight];

% Plot the patch contour plot
data_avg_GUI_compatible(figpos,param_disp_avg)


% --- Executes on button press in tag_dispgrad_patch_contour.
function tag_dispgrad_patch_contour_Callback(hObject, eventdata, handles)
% hObject    handle to tag_dispgrad_patch_contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the computed data:
computed_data = handles.computed_data;
N_images_correlated = handles.computed_data.corr_setup.N_images_correlated;
grid_setup = handles.computed_data.grid_setup;
scale = handles.computed_data.FEM_setup.scale;
N_Node_DU = handles.computed_data.FEM_setup.N_Node_DU;
reduction = 1; %Assume no gradients are calculated from reduced data

%Get the skip image value:
skip = str2double(get(handles.tag_image_skip,'string'));

%Check to see if there are displacement gradients:
if N_Node_DU ~= 0 %There are displacement gradients:

    %Set the patch contour parameters:
    param_dispgrad_patch_contour = dispgrad_patch_contour_GUI(computed_data);
    if param_dispgrad_patch_contour.quit == 1
        return
    end
    
    %Get the main GUI position and set the figure to be just to the right of the GUI
    scnsize = handles.scnsize; %in pixels
    GUIpos = handles.GUIpos; %in pixels

    leftborder = 10;
    topborder = 10;

    figheight = 700;
    figwidth = 875;

    figleft = GUIpos(1) + GUIpos(3) + leftborder;
    figbottom = scnsize(4) - figheight - topborder;

    figpos = [figleft,figbottom,figwidth,figheight];

    % Plot the patch contour plot
    patch_contour_GUI_compatible_improved(figpos,N_images_correlated,skip,grid_setup,...
        reduction,scale,N_Node_DU,param_dispgrad_patch_contour)

    
else %N_Node_DU == 0 --> There are NO displacement gradients
    w = warndlg('There are no displacement gradients to plot');
    waitfor(w);
    return
    
    
end


% --- Executes on button press in tag_dispgrad_line_scan.
function tag_dispgrad_line_scan_Callback(hObject, eventdata, handles)
% hObject    handle to tag_dispgrad_line_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the computed data:
computed_data = handles.computed_data;
N_images = handles.computed_data.corr_setup.N_images_correlated;
scale = handles.computed_data.scale;

%Get the skip image value:
skip = str2double(get(handles.tag_image_skip,'string'));

% Set the line scan parameters
param_dispgrad_line_scan = dispgrad_line_scan_GUI(computed_data,scale);
if param_dispgrad_line_scan.quit == 1
    return
end

%Get the main GUI position and set the figure to be just to the right of the GUI
scnsize = handles.scnsize; %in pixels
GUIpos = handles.GUIpos; %in pixels

leftborder = 10;
topborder = 10;

figheight = 700;
figwidth = 875;

figleft = GUIpos(1) + GUIpos(3) + leftborder;
figbottom = scnsize(4) - figheight - topborder;

figpos = [figleft,figbottom,figwidth,figheight];

% Plot the patch contour plot
line_scan_GUI_compatible(figpos,N_images,skip,param_dispgrad_line_scan)


% --- Executes on button press in tag_dispgrad_avg.
function tag_dispgrad_avg_Callback(hObject, eventdata, handles)
% hObject    handle to tag_dispgrad_avg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structu
%Get the computed data:
computed_data = handles.computed_data;

% Set the line scan parameters
param_dispgrad_avg = dispgrad_avg_GUI(computed_data);
if param_dispgrad_avg.quit == 1
    return
end

%Plot the line scans
if isempty(param_dispgrad_avg.y_label) || isempty(param_dispgrad_avg.data_avg) %One of the options in the parameters was not choosen
    warndlg('You did not set one of the parameters')

else %An option was chosen for all the parameters
    
    %Get the main GUI position and set the figure to be just to the right of the GUI
    scnsize = handles.scnsize; %in pixels
    GUIpos = handles.GUIpos; %in pixels
    
    leftborder = 10;
    topborder = 10;
    
    figheight = 700;
    figwidth = 875;
    
    figleft = GUIpos(1) + GUIpos(3) + leftborder;
    figbottom = scnsize(4) - figheight - topborder;
    
    figpos = [figleft,figbottom,figwidth,figheight];
    
    % Plot the patch contour plot
    data_avg_GUI_compatible(figpos,param_dispgrad_avg)
end


% --- Executes on button press in tagQuit.
function tagQuit_Callback(hObject, eventdata, handles)
% hObject    handle to tagQuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1)


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
