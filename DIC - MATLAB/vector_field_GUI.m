function varargout = vector_field_GUI(varargin)
% VECTOR_FIELD_GUI M-file for vector_field_GUI.fig
%      VECTOR_FIELD_GUI, by itself, creates a new VECTOR_FIELD_GUI or raises the existing
%      singleton*.
%
%      H = VECTOR_FIELD_GUI returns the handle to a new VECTOR_FIELD_GUI or the handle to
%      the existing singleton*.
%
%      VECTOR_FIELD_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VECTOR_FIELD_GUI.M with the given input arguments.
%
%      VECTOR_FIELD_GUI('Property','Value',...) creates a new VECTOR_FIELD_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vector_field_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vector_field_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vector_field_GUI

% Last Modified by GUIDE v2.5 01-Jul-2013 16:57:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vector_field_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @vector_field_GUI_OutputFcn, ...
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


% --- Executes just before vector_field_GUI is made visible.
function vector_field_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vector_field_GUI (see VARARGIN)

% Choose default command line output for vector_field_GUI
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

%Set the default values
handles.qscale = 0;

%Get the computed data:
handles.computed_data = varargin{1};

%Reference grid only if a) reduced data or b) no deformed grid has been
%computed
handles.reduction = varargin{2};
if handles.reduction ~= 1 || isempty(handles.computed_data.gridx_def)    
    set(handles.tag_grid_selection,'foregroundcolor',[0.8 0.8 0.8])
    set(handles.tag_grid_ref,'enable','off')
    set(handles.tag_grid_def,'enable','off')
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vector_field_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vector_field_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.quiver_param;
delete(hObject);


function tag_qscale_Callback(hObject, eventdata, handles)
% hObject    handle to tag_qscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_qscale as text
%        str2double(get(hObject,'String')) returns contents of tag_qscale as a double
% uiresume(handles.figure1);


% --- Executes during object creation, after setting all properties.
function tag_qscale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_qscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function tag_grid_selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_grid_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function tag_quiver_skip_Callback(hObject, eventdata, handles)
% hObject    handle to tag_quiver_skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_quiver_skip as text
%        str2double(get(hObject,'String')) returns contents of tag_quiver_skip as a double


% --- Executes during object creation, after setting all properties.
function tag_quiver_skip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_quiver_skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tagSet.
function tagSet_Callback(hObject, eventdata, handles)
% hObject    handle to tagSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the scale of the quivers
qscale = str2double(get(handles.tag_qscale,'string'));
handles.quiver_param.qscale = qscale;

%Choose the grid to plot over:
gridx_ref = handles.computed_data.gridx;
gridy_ref = handles.computed_data.gridy;
gridx_def = handles.computed_data.gridx_def;
gridy_def = handles.computed_data.gridy_def;

grid_selection = get(get(handles.tag_grid_selection,'SelectedObject'),'string');

try %Try getting N_images_correlated from the full correlation
    N_images = handles.computed_data.corr_setup.N_images_correlated;
catch %If only reduced images have been correlated, and full images haven't:
    N_images = handles.computed_data.corr_setup_reduced.N_images_correlated;
end

if strcmp(grid_selection,'Reference grid')
    gridx = repmat(gridx_ref,1,N_images);
    gridy = repmat(gridy_ref,1,N_images);
    
elseif strcmp(grid_selection,'Deformed grid')
    gridx = gridx_def;
    gridy = gridy_def;

end

if handles.reduction ~= 1 %Looking at reduced data; must use ref grid
    gridx = repmat(handles.computed_data.gridx_reduced,1,N_images);
    gridy = repmat(handles.computed_data.gridy_reduced,1,N_images);
end

handles.quiver_param.gridx = gridx;
handles.quiver_param.gridy = gridy;  

%Get the quiver skip value
qskip = str2double(get(handles.tag_quiver_skip,'string'));
handles.quiver_param.qskip = qskip;

handles.quiver_param.quit = 0;
guidata(hObject,handles)
uiresume(handles.figure1);


% --- Executes on button press in tagQuit.
function tagQuit_Callback(hObject, eventdata, handles)
% hObject    handle to tagQuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.text_box = '0'
handles.quiver_param.quit = 1;
guidata(hObject,handles)
uiresume(handles.figure1);


% --- Executes when user attempts to close figure.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
% t = get(handles.figure1,'waitstatus')
if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, use UIRESUME and return
    uiresume(handles.figure1);
else
    % The GUI is no longer waiting, so destroy it now.
    delete(hObject);
end
