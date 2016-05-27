function varargout = compute_data_GUI(varargin)
% COMPUTE_DATA_GUI M-file for compute_data_GUI.fig
%      COMPUTE_DATA_GUI, by itself, creates a new COMPUTE_DATA_GUI or raises the existing
%      singleton*.
%
%      H = COMPUTE_DATA_GUI returns the handle to a new COMPUTE_DATA_GUI or the handle to
%      the existing singleton*.
%
%      COMPUTE_DATA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPUTE_DATA_GUI.M with the given input arguments.
%
%      COMPUTE_DATA_GUI('Property','Value',...) creates a new COMPUTE_DATA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before compute_data_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to compute_data_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help compute_data_GUI

% Last Modified by GUIDE v2.5 08-Nov-2014 14:24:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @compute_data_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @compute_data_GUI_OutputFcn, ...
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


% --- Executes just before compute_data_GUI is made visible.
function compute_data_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to compute_data_GUI (see VARARGIN)

% Set default values
set(handles.tag_scale,'string','1'); %1 um/pi
set(handles.tag_kernel_size,'string','11'); %Default kernel size of 11 x 11 control points
set(handles.tag_smooth_passes,'string','3'); %Default number of smoothing passes
set(handles.tag_NaN_group_size,'string','15'); %Default size for max number of contiguous points to smooth over
set(handles.tag_compute_disp_grad,'value',0); %Don't calculate disp grad

%Try to load the full data; if there isn't any, then abort
load grid_setup
if isempty(grid_setup)
    w = warndlg('There is no correlated full data.','No full data');
    waitfor(w)
    return
end

% Choose default command line output for compute_data_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes compute_data_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = compute_data_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;
delete(hObject)


% --- Executes on selection change in tag_loop.
function tag_loop_Callback(hObject, eventdata, handles)
% hObject    handle to tag_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns tag_loop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_loop


% --- Executes during object creation, after setting all properties.
function tag_loop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% tag_scale
function tag_scale_Callback(hObject, eventdata, handles)
% hObject    handle to tag_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_scale as text
%        str2double(get(hObject,'String')) returns contents of tag_scale as a double


% --- Executes during object creation, after setting all properties.
function tag_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Smooth data

% --- Executes on button press in tag_smooth.
function tag_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to tag_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_smooth
smooth_yn = get(hObject,'Value');
if smooth_yn == 1 %WANT to smooth displacements
    set(handles.tag_weights,'enable','on');
    set(handles.tag_kernel_size_label,'foregroundcolor',[0 0 0]);
    set(handles.tag_kernel_size,'enable','on');
    set(handles.tag_kernel_unit,'foregroundcolor',[0 0 0]);
    set(handles.tag_smooth_passes_label,'foregroundcolor',[0 0 0]);
    set(handles.tag_smooth_passes,'enable','on');
    set(handles.tag_NaN_group_size,'enable','on');
    set(handles.tag_NaN_group_size_label,'foregroundcolor',[0 0 0]);
elseif smooth_yn == 0 %Do NOT want to smooth displacements
    set(handles.tag_weights,'enable','off');
    set(handles.tag_kernel_size_label,'foregroundcolor',[0.8 0.8 0.8]);
    set(handles.tag_kernel_size,'enable','off');
    set(handles.tag_kernel_unit,'foregroundcolor',[0.8 0.8 0.8]);
    set(handles.tag_smooth_passes_label,'foregroundcolor',[0.8 0.8 0.8]);
    set(handles.tag_smooth_passes,'enable','off');
    set(handles.tag_NaN_group_size,'enable','off');
    set(handles.tag_NaN_group_size_label,'foregroundcolor',[0.8 0.8 0.8]);
end
    

% --- Executes on selection change in tag_weights.
function tag_weights_Callback(hObject, eventdata, handles)
% hObject    handle to tag_weights (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tag_weights contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_weights


% --- Executes during object creation, after setting all properties.
function tag_weights_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_weights (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tag_kernel_size_Callback(hObject, eventdata, handles)
% hObject    handle to tag_kernel_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_kernel_size as text
%        str2double(get(hObject,'String')) returns contents of tag_kernel_size as a double


% --- Executes during object creation, after setting all properties.
function tag_kernel_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_kernel_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tag_smooth_passes_Callback(hObject, eventdata, handles)
% hObject    handle to tag_smooth_passes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_smooth_passes as text
%        str2double(get(hObject,'String')) returns contents of tag_smooth_passes as a double


% --- Executes during object creation, after setting all properties.
function tag_smooth_passes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_smooth_passes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tag_NaN_group_size_Callback(hObject, eventdata, handles)
% hObject    handle to tag_NaN_group_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_NaN_group_size as text
%        str2double(get(hObject,'String')) returns contents of tag_NaN_group_size as a double


% --- Executes during object creation, after setting all properties.
function tag_NaN_group_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_NaN_group_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Displacement Gradients

% --- Executes on button press in tag_compute_disp_grad.
function tag_compute_disp_grad_Callback(hObject, eventdata, handles)
% hObject    handle to tag_compute_disp_grad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_compute_disp_grad

yesno_disp_grad = get(hObject,'Value');
if yesno_disp_grad == 1 %Box is checked
    set(handles.tag_linear,'enable','on');
    set(handles.tag_quadratic,'enable','on');
    set(handles.tag_cubic,'enable','on');

else %Box is NOT checked
    set(handles.tag_linear,'enable','off');
    set(handles.tag_quadratic,'enable','off');
    set(handles.tag_cubic,'enable','off');

end
handles.disp_grad.yesno_disp_grad = yesno_disp_grad;
guidata(hObject,handles)


% --- Executes on button press in tag_linear.
function tag_linear_Callback(hObject, eventdata, handles)
% hObject    handle to tag_linear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_linear


% --- Executes on button press in tag_quadratic.
function tag_quadratic_Callback(hObject, eventdata, handles)
% hObject    handle to tag_quadratic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_quadratic


% --- Executes on button press in tag_cubic.
function tag_cubic_Callback(hObject, eventdata, handles)
% hObject    handle to tag_cubic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_cubic


%% Deformed grid

% --- Executes on button press in tag_deformed_grid.
function tag_deformed_grid_Callback(hObject, eventdata, handles)
% hObject    handle to tag_deformed_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_deformed_grid



%% Compute Data

% --- Executes on button press in tag_compute_data.
function tag_compute_data_Callback(hObject, eventdata, handles)
% hObject    handle to tag_compute_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Determine which type of for-loop to use
contents_loop = get(handles.tag_loop,'String');
loop_type = contents_loop{get(handles.tag_loop,'Value')};
if strcmp(loop_type,'parallel') == 1 %Use parallel loops
    % Check if the matlab parallel toolbox is open
    % Open it if it isn't

    try %Use parpool for newer versions
        if isempty(gcp('nocreate'))
            parpool;
        end
    catch %Use matlabpool for older versions
        isOpen = matlabpool('size') > 0;
        if  isOpen ~= 1
            matlabpool;
        end
    end
    N_threads = 12; % Number of threads to use
    
elseif strcmp(loop_type,'serial') == 1 %Use serial loops
    N_threads = [];
    
elseif isempty(loop_type) == 1 %No loop choice was selected
    w = warndlg('You did not choose a loop format.','No loop');
    waitfor(w);
    return;
end

%Get data from GUI inputs:
scale = str2double(get(handles.tag_scale,'string'));
yn_disp_grad = get(handles.tag_compute_disp_grad,'value');

%Smoothing info
if get(handles.tag_smooth,'value') == 0
    smooth_setup.smoothing_algorithm = 'no smoothing';

elseif get(handles.tag_smooth,'value') == 1
    smooth_setup.smoothing_algorithm = 'moving average';
    
    weights_contents = cellstr(get(handles.tag_weights,'String'));
    weights_selection_string = weights_contents{get(handles.tag_weights,'Value')};
    weights_selection = get(handles.tag_weights,'value');
    smooth_setup.weights_string = weights_selection_string;
    smooth_setup.weights_selection = weights_selection;
    smooth_setup.NaN_group_size = str2double(get(handles.tag_NaN_group_size,'string'));
    
    
    kernel_full_size = str2double(get(handles.tag_kernel_size,'string'));
    if mod(kernel_full_size,2) ~= 1 %Kernel is not an odd number
       w = warndlg('The smoothing kernel size must be odd!','Odd kernel size');
       waitfor(w);
       return;
    end
        
    smooth_setup.kernel_size = kernel_full_size;
    smooth_setup.smooth_passes = str2double(get(handles.tag_smooth_passes,'string'));

end

% Strain info
if get(handles.tag_linear,'value') == 1
    elem_order = 1;
elseif get(handles.tag_quadratic,'value') == 1
    elem_order = 2;
elseif get(handles.tag_cubic,'value') == 1
    elem_order = 3;
end

%Compute deformed grid?
def_grid = get(handles.tag_deformed_grid,'value');

%Load the correlation data
t1 = clock;
[grid_setup,corr_setup,gridx_scale,gridy_scale,dispx,dispy,...
    dispx_smooth_prev,dispy_smooth_prev] = ...
    load_correlation_data_GUI_compatible(scale);

%Smooth the data using a moving average
t2 = clock;
[dispx_smooth,dispy_smooth] = smooth_disp(smooth_setup,grid_setup,corr_setup,...
    dispx,dispy,dispx_smooth_prev,dispy_smooth_prev,loop_type,N_threads);
    
%Calculate the displacement gradients using FEM shape functions
t3 = clock;
if isempty(dispx_smooth) %Use raw displacements to calculate strains
    [DU_FEM,D2U_FEM,gridx_DU,gridy_DU,FEM_setup] = calc_derivatives_GUI_compatible(...
        yn_disp_grad,elem_order,grid_setup,corr_setup,gridx_scale,gridy_scale,...
        dispx,dispy,scale,N_threads,loop_type);
else %Use smoothed displacements to calculate strains
    [DU_FEM,D2U_FEM,gridx_DU,gridy_DU,FEM_setup] = calc_derivatives_GUI_compatible(...
        yn_disp_grad,elem_order,grid_setup,corr_setup,gridx_scale,gridy_scale,...
        dispx_smooth,dispy_smooth,scale,N_threads,loop_type);
end

%Calculate small and large strains using the derivatives
[small_strain,large_strain] = calc_strains_GUI_compatible(DU_FEM,D2U_FEM);
t4 = clock;

%Compute the deformed grid
if isempty(dispx_smooth) %Use raw displacements to calculate deformed grid
    [gridx_def,gridy_def,gridx_DU_def,gridy_DU_def] = deformed_grid(def_grid,...
        gridx_scale,gridy_scale,gridx_DU,gridy_DU,dispx,dispy);
else%Use smoothed displacements to calculated deformed grid
    [gridx_def,gridy_def,gridx_DU_def,gridy_DU_def] = deformed_grid(def_grid,...
        gridx_scale,gridy_scale,gridx_DU,gridy_DU,dispx_smooth,dispy_smooth);
end
t5 = clock;

%Get all the computation times
load_data_time = etime(t2,t1);
smooth_time = etime(t3,t2);
strain_time = etime(t4,t3);
def_grid_time = etime(t5,t4);


smooth_setup.smooth_time = smooth_time;
FEM_setup.strain_time = strain_time;

%Save all the data
save('grid_scale_data','gridx_scale','gridy_scale');
save('disp_smooth_data','dispx_smooth','dispy_smooth');
save('smooth_setup','smooth_setup')
save('DU_data','small_strain','large_strain','DU_FEM','D2U_FEM','gridx_DU','gridy_DU');
save('FEM_setup','FEM_setup')
save('grid_deformed_data','gridx_def','gridy_def','gridx_DU_def','gridy_DU_def');

uiresume(handles.figure1);


% --- Executes on button press in tag_cancel.
function tag_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to tag_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
