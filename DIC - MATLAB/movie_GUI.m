function varargout = movie_GUI(varargin)
% MOVIE_GUI MATLAB code for movie_GUI.fig
%      MOVIE_GUI, by itself, creates a new MOVIE_GUI or raises the existing
%      singleton*.
%
%      H = MOVIE_GUI returns the handle to a new MOVIE_GUI or the handle to
%      the existing singleton*.
%
%      MOVIE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOVIE_GUI.M with the given input arguments.
%
%      MOVIE_GUI('Property','Value',...) creates a new MOVIE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before movie_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to movie_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help movie_GUI

% Last Modified by GUIDE v2.5 02-Jul-2013 12:22:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @movie_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @movie_GUI_OutputFcn, ...
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


% --- Executes just before movie_GUI is made visible.
function movie_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to movie_GUI (see VARARGIN)

% Choose default command line output for movie_GUI
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

%Load the computed data:
[grid_setup,reduction,corr_setup,FEM_setup,gridx,gridy,...
    dispx,dispy,scale,small_strain,large_strain,...
    gridx_DU,gridy_DU,grid_setup_reduced,gridx_reduced,gridy_reduced,...
    corr_setup_reduced,dispx_reduced,dispy_reduced,gridx_def,gridy_def,...
    gridx_DU_def,gridy_DU_def] = load_computed_data;
handles.computed_data.grid_setup = grid_setup;
handles.computed_data.reduction = reduction;
handles.computed_data.corr_setup = corr_setup;
handles.computed_data.FEM_setup = FEM_setup;
handles.computed_data.gridx = gridx;
handles.computed_data.gridy = gridy;
handles.computed_data.dispx = dispx;
handles.computed_data.dispy = dispy;
handles.computed_data.scale = scale;
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
handles.computed_data.gridx_def = gridx_def;
handles.computed_data.gridy_def = gridy_def;
handles.computed_data.gridx_DU_def = gridx_DU_def;
handles.computed_data.gridy_DU_def = gridy_DU_def;


%Check to see if there are displacement gradients:
N_Node_DU = FEM_setup.N_Node_DU;
if isempty(N_Node_DU) == 1 %There are no displacement gradients
    set(handles.tag_dispgrad,'foregroundcolor',[0.8,0.8,0.8])
    set(handles.tag_dispgrad_patch_contour,'enable','off')
%     set(handles.tag_dispgrad_line_scan,'enable','off')
else %N_Node_DU ~= 0 --> There are displacement gradients
    set(handles.tag_dispgrad,'foregroundcolor',[0,0,0])
    set(handles.tag_dispgrad_patch_contour,'enable','on')
%     set(handles.tag_dispgrad_line_scan,'enable','on')
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes movie_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = movie_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;
close all


function tag_preview_Callback(hObject, eventdata, handles)
% hObject    handle to tag_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_preview as text
%        str2double(get(hObject,'String')) returns contents of tag_preview as a double


% --- Executes during object creation, after setting all properties.
function tag_preview_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tag_image_skip_Callback(hObject, eventdata, handles)
% hObject    handle to tag_image_skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_image_skip as text
%        str2double(get(hObject,'String')) returns contents of tag_image_skip as a double


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


function tag_frame_rate_Callback(hObject, eventdata, handles)
% hObject    handle to tag_frame_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_frame_rate as text
%        str2double(get(hObject,'String')) returns contents of tag_frame_rate as a double


% --- Executes during object creation, after setting all properties.
function tag_frame_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_frame_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tag_vec.
function tag_vec_Callback(hObject, eventdata, handles)
% hObject    handle to tag_vec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tag_disp_patch_contour.
function tag_disp_patch_contour_Callback(hObject, eventdata, handles)
% hObject    handle to tag_disp_patch_contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the computed data:
dispx = handles.computed_data.dispx;
dispy = handles.computed_data.dispy;
N_pts = handles.computed_data.grid_setup.N_pts;
grid_setup = handles.computed_data.grid_setup;
N_images_correlated = handles.computed_data.corr_setup.N_images_correlated;
reduction = 1;
try
    scale = handles.computed_data.FEM_setup.scale;
catch
    scale = 1;
end

%Get the image preview value:
preview = str2double(get(handles.tag_preview,'string'));

%Set the patch contour parameters:
param_disp_patch_contour = disp_patch_contour_GUI(scale,N_images_correlated,...
    dispx,dispy,reduction,handles.computed_data);
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

% Plot the patch contour plot preview
patch_contour_movie_preview_improved(figpos,preview,grid_setup,scale,N_pts,...
    param_disp_patch_contour)

message = 'Adjust the figure parameters, i.e. title, as desired.  Then click on Make Movie.';
title = 'Set parameters';
icon = 'help';
h = msgbox(message,title,icon);
waitfor(h);

handles.fig_type = 'disp_patch_contour';
handles.fig_param = param_disp_patch_contour;
guidata(hObject,handles);


% --- Executes on button press in tag_disp_line_scan.
function tag_disp_line_scan_Callback(hObject, eventdata, handles)
% hObject    handle to tag_disp_line_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tag_dispgrad_patch_contour.
function tag_dispgrad_patch_contour_Callback(hObject, eventdata, handles)
% hObject    handle to tag_dispgrad_patch_contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the computed data:
computed_data = handles.computed_data;
grid_setup = handles.computed_data.grid_setup;
scale = handles.computed_data.scale;
N_Node_DU = handles.computed_data.FEM_setup.N_Node_DU;


%Get the image preview value:
preview = str2double(get(handles.tag_preview,'string'));

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

    % Plot the patch contour plot preview
    patch_contour_movie_preview_improved(figpos,preview,grid_setup,scale,N_Node_DU,...
        param_dispgrad_patch_contour)


else %N_Node_DU == 0 --> There are NO displacement gradients
    warndlg('There are no displacement gradients to plot')   
end

message = 'Adjust the figure parameters, i.e. title, as desired.  Then click on Make Movie.';
title = 'Set parameters';
icon = 'help';
h = msgbox(message,title,icon);
waitfor(h);

handles.fig_type = 'dispgrad_patch_contour';
handles.fig_param = param_dispgrad_patch_contour;
guidata(hObject,handles);


% --- Executes on button press in tag_dispgrad_line_scan.
function tag_dispgrad_line_scan_Callback(hObject, eventdata, handles)
% hObject    handle to tag_dispgrad_line_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tag_quit.
function tag_quit_Callback(hObject, eventdata, handles)
% hObject    handle to tag_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1)


% --- Executes on button press in tag_movie.
function tag_movie_Callback(hObject, eventdata, handles)
% hObject    handle to tag_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the computed data:
N_images_correlated = handles.computed_data.corr_setup.N_images_correlated;
grid_setup = handles.computed_data.grid_setup;
scale = handles.computed_data.scale;
N_pts = handles.computed_data.grid_setup.N_pts;
N_Node_DU = handles.computed_data.FEM_setup.N_Node_DU;

%Get the skip image value:
skip = str2double(get(handles.tag_image_skip,'string'));

%Get the desired frame rate:
frame_rate = str2double(get(handles.tag_frame_rate,'string'));

%Get the handles of the preview figure
figure(1);
title_handles = get(gca,'title');
title_string = get(title_handles,'string');

%Close the preview figure
close(1);

%Get the figure type
fig_type = handles.fig_type;
if isempty(fig_type)
    w = warndlg('You did not set a figure type.','Figure Type');
    waitfor(w)
    return
end

%Set the position of the figures
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

message = ['Do not cover the figure window (i.e. with the mouse or other windows)',...
    'during movie capture! This would be a good time to go get a cup of coffee',...
    'while the movie is being made.'];
title = 'Do not cover window!';
icon = 'warn';
h = msgbox(message,title,icon);
waitfor(h)


%Run the appropriate script to make the movie
if strcmp(fig_type,'disp_patch_contour')
    param_patch_contour = handles.fig_param;
    patch_contour_movie(figpos,N_images_correlated,skip,frame_rate,grid_setup,...
        scale,N_pts,param_patch_contour,title_string,fig_type);
end

if  strcmp(fig_type,'dispgrad_patch_contour')
    param_patch_contour = handles.fig_param;
    patch_contour_movie(figpos,N_images_correlated,skip,frame_rate,grid_setup,...
        scale,N_Node_DU,param_patch_contour,title_string,fig_type);
end





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
