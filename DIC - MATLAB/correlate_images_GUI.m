
%% Initialize GUI

function varargout = correlate_images_GUI(varargin)
% CORRELATE_IMAGES_GUI M-file for correlate_images_GUI.fig
%      CORRELATE_IMAGES_GUI, by itself, creates a new CORRELATE_IMAGES_GUI or raises the existing
%      singleton*.
%
%      H = CORRELATE_IMAGES_GUI returns the handle to a new CORRELATE_IMAGES_GUI or the handle to
%      the existing singleton*.
%
%      CORRELATE_IMAGES_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CORRELATE_IMAGES_GUI.M with the given input arguments.
%
%      CORRELATE_IMAGES_GUI('Property','Value',...) creates a new CORRELATE_IMAGES_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before correlate_images_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to correlate_images_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help correlate_images_GUI

% Last Modified by GUIDE v2.5 15-Oct-2014 18:06:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @correlate_images_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @correlate_images_GUI_OutputFcn, ...
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


% --- Executes just before correlate_images_GUI is made visible.
function correlate_images_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to correlate_images_GUI (see VARARGIN)

% Try loading previous reduced data, and full grid
try 
    
    load grid_setup_reduced.mat
    load grid_reduced_data.mat
    load corr_setup_reduced.mat
    load disp_reduced_data.mat
    
    handles.grid_setup_reduced = grid_setup_reduced;
    handles.gridx_reduced = gridx_reduced;
    handles.gridy_reduced = gridy_reduced;
    handles.corr_setup_reduced = corr_setup_reduced;
    handles.dispx_reduced = dispx_reduced;
    handles.dispy_reduced = dispy_reduced;
    
catch
    
    handles.grid_setup_reduced = [];
    handles.gridx_reduced = [];
    handles.gridy_reduced = [];
    handles.corr_setup_reduced = [];
    handles.dispx_reduced = [];
    handles.dispy_reduced = [];
    
end


try
    
    load grid_setup.mat
    load grid_data.mat
    
    handles.grid_setup = grid_setup;
    handles.gridx = gridx;
    handles.gridy = gridy;
    
catch
    
    handles.grid_setup = [];
    handles.gridx = [];
    handles.gridy = [];
    
end


try
    load filenamelist
    load image_setup
    
    handles.filenamelist = filenamelist;
    handles.image_setup = image_setup;
catch
    w = warndlg(['There is no filenamelist.mat or image_setup.mat files in the working directory.  ',...
        'Please generate a filenamelist (using image_setup_GUI for instance) ',...
        'and then run correlate_images_GUI again.  '],...
        'Images not setup');
    waitfor(w);
    return
end

% Set default values
handles.use_reduced_selection = [];

% Choose default command line output for correlate_images_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes correlate_images_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = correlate_images_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;
close all;



%% For-loop parameters

% --- Executes on button press in tag_parallel.
function tag_parallel_Callback(hObject, eventdata, handles)
% hObject    handle to tag_parallel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_parallel
set(handles.tag_parallel_label,'enable','on')
set(handles.tag_ref_image_label,'foregroundcolor',[0.8 0.8 0.8])
set(handles.tag_first_image,'enable','off')
set(handles.tag_preceeding_image,'enable','off')


% --- Executes on button press in tag_serial.
function tag_serial_Callback(hObject, eventdata, handles)
% hObject    handle to tag_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_serial
set(handles.tag_parallel_label,'enable','off')
set(handles.tag_ref_image_label,'foregroundcolor',[0 0 0])
set(handles.tag_first_image,'enable','on')
set(handles.tag_preceeding_image,'enable','on')


% --- Executes on button press in tag_first_image.
function tag_first_image_Callback(hObject, eventdata, handles)
% hObject    handle to tag_first_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_first_image
ref_image = 1;
handles.corr_param.ref_image = ref_image;
guidata(hObject,handles)


% --- Executes on button press in tag_preceeding_image.
function tag_preceeding_image_Callback(hObject, eventdata, handles)
% hObject    handle to tag_preceeding_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_preceeding_image
ref_image = 2;
handles.corr_param.ref_image = ref_image;
guidata(hObject,handles)


%% Reduced images parameters

% --- Executes on selection change in tag_corr_reduced.
function tag_corr_reduced_Callback(hObject, eventdata, handles)
% hObject    handle to tag_corr_reduced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tag_corr_reduced contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_corr_reduced
% corr_reduced_contents = cellstr(get(hObject,'String'));
% corr_reduced_selection = corr_reduced_contents{get(hObject,'Value')};
corr_reduced_selection = get(hObject,'value');

if corr_reduced_selection==1 %No
    
    set(handles.tag_reduction,'enable','off')
    set(handles.tag_reduction_label,'enable','off')
    set(handles.tag_reduced_grid,'enable','off')
    set(handles.tag_reduced_grid_label,'enable','off')
    set(handles.tag_subset_reduced,'enable','off')
    set(handles.tag_subset_reduced_label,'enable','off')
    set(handles.tag_subset_reduced_unit,'enable','off')
    set(handles.tag_thresh_reduced,'enable','off')
    set(handles.tag_thresh_reduced_label,'enable','off')
    set(handles.tag_search_zone_reduced_label,'enable','off')
    set(handles.tag_search_zone_reduced,'enable','off')
    
elseif corr_reduced_selection==2 %Yes

    set(handles.tag_reduction,'enable','on')
    set(handles.tag_reduction_label,'enable','on')
    set(handles.tag_reduced_grid,'enable','on')
    set(handles.tag_reduced_grid_label,'enable','on')
    set(handles.tag_subset_reduced,'enable','on')
    set(handles.tag_subset_reduced_label,'enable','on')
    set(handles.tag_subset_reduced_unit,'enable','on')
    set(handles.tag_thresh_reduced,'enable','on')
    set(handles.tag_thresh_reduced_label,'enable','on')
    set(handles.tag_search_zone_reduced_label,'enable','on')
    set(handles.tag_search_zone_reduced,'enable','on')
    
elseif corr_reduced_selection==3 %Yes - use previous iteration
    try
        load corr_setup_reduced
    catch
        corr_setup_reduced = [];
    end
    
    if isempty(corr_setup_reduced)
        w = warndlg('You have not yet correlated reduced images.',...
            'No reduced data');
        waitfor(w);
        return
    end      
    
    set(handles.tag_reduction,'enable','off','string',num2str(corr_setup_reduced.reduction))
    set(handles.tag_reduction_label,'enable','off')
    set(handles.tag_reduced_grid,'enable','off','value',1)
    set(handles.tag_reduced_grid_label,'enable','off')
    set(handles.tag_subset_reduced,'enable','off','string',num2str(corr_setup_reduced.subset_reduced))
    set(handles.tag_subset_reduced_label,'enable','off')
    set(handles.tag_subset_reduced_unit,'enable','off')
    
    
    
end


% --- Executes during object creation, after setting all properties.
function tag_corr_reduced_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_corr_reduced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tag_reduction_Callback(hObject, eventdata, handles)
% hObject    handle to tag_reduction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_reduction as text
%        str2double(get(hObject,'String')) returns contents of tag_reduction as a double


% --- Executes during object creation, after setting all properties.
function tag_reduction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_reduction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tag_reduced_grid.
function tag_reduced_grid_Callback(hObject, eventdata, handles)
% hObject    handle to tag_reduced_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tag_reduced_grid contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_reduced_grid


% --- Executes during object creation, after setting all properties.
function tag_reduced_grid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_reduced_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tag_subset_reduced_Callback(hObject, eventdata, handles)
% hObject    handle to tag_subset_reduced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_subset_reduced as text
%        str2double(get(hObject,'String')) returns contents of tag_subset_reduced as a double


% --- Executes during object creation, after setting all properties.
function tag_subset_reduced_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_subset_reduced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tag_thresh_reduced_Callback(hObject, eventdata, handles)
% hObject    handle to tag_thresh_reduced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_thresh_reduced as text
%        str2double(get(hObject,'String')) returns contents of tag_thresh_reduced as a double


% --- Executes during object creation, after setting all properties.
function tag_search_zone_reduced_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_search_zone_reduced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tag_search_zone_reduced_Callback(hObject, eventdata, handles)
% hObject    handle to tag_search_zone_reduced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_search_zone_reduced as text
%        str2double(get(hObject,'String')) returns contents of tag_search_zone_reduced as a double


% --- Executes during object creation, after setting all properties.
function tag_thresh_reduced_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_thresh_reduced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Full image parameters

% --- Executes on selection change in tag_correlate_full.
function tag_correlate_full_Callback(hObject, eventdata, handles)
% hObject    handle to tag_correlate_full (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tag_correlate_full contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_correlate_full
% correlate_full_contents = cellstr(get(hObject,'string'));
% correlate_full_selection = correlate_full_contents{get(hObject,'value')};
correlate_full_selection = get(hObject,'value');
handles.correlate_full_selection = correlate_full_selection;



if correlate_full_selection==1 %No
    
    set(handles.tag_use_reduced,'enable','off')
    set(handles.tag_use_reduced_label,'enable','off')
    set(handles.tag_full_grid,'enable','off')
    set(handles.tag_full_grid_label,'enable','off')
    set(handles.tag_subset_full,'enable','off')
    set(handles.tag_subset_full_label,'enable','off')
    set(handles.tag_subset_full_unit,'enable','off')
    set(handles.tag_thresh_full,'enable','off')
    set(handles.tag_thresh_full_label,'enable','off')
    set(handles.tag_search_zone_full_label,'enable','off')
    set(handles.tag_search_zone_full,'enable','off')
    
elseif correlate_full_selection==2 %Yes
   
    set(handles.tag_use_reduced,'enable','on')
    set(handles.tag_use_reduced_label,'enable','on')
    set(handles.tag_full_grid,'enable','on')
    set(handles.tag_full_grid_label,'enable','on')
    set(handles.tag_subset_full,'enable','on')
    set(handles.tag_subset_full_label,'enable','on')
    set(handles.tag_subset_full_unit,'enable','on')
    set(handles.tag_thresh_full,'enable','on')
    set(handles.tag_thresh_full_label,'enable','on')
    set(handles.tag_search_zone_full_label,'enable','on')
    set(handles.tag_search_zone_full,'enable','on')
    
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function tag_correlate_full_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_correlate_full (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tag_use_reduced.
function tag_use_reduced_Callback(hObject, eventdata, handles)
% hObject    handle to tag_use_reduced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tag_use_reduced contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_use_reduced
use_reduced_contents = cellstr(get(hObject,'String'));
use_reduced_selection = use_reduced_contents{get(hObject,'Value')};
handles.use_reduced_selection = use_reduced_selection;

correlate_full_selection = handles.correlate_full_selection;

grid_setup_reduced = handles.grid_setup_reduced;
corr_reduced_contents = cellstr(get(handles.tag_corr_reduced,'string'));
corr_reduced_selection = corr_reduced_contents{get(handles.tag_corr_reduced,'value')};

if use_reduced_selection==2 %Yes
    if corr_reduced_selection==1 && isempty(grid_setup_reduced) %No
    
        w = warndlg('To use reduced data, you must either have previously reduced data in the current working directory, or you must correlate reduced images now',...
            'No reduced data!');
        waitfor(w)
        return

    end 
end


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function tag_use_reduced_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_use_reduced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tag_full_grid.
function tag_full_grid_Callback(hObject, eventdata, handles)
% hObject    handle to tag_full_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns tag_full_grid contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_full_grid


% --- Executes during object creation, after setting all properties.
function tag_full_grid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_full_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tag_subset_full_Callback(hObject, eventdata, handles)
% hObject    handle to tag_subset_full (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_subset_full as text
subset = str2double(get(hObject,'String'));
handles.corr_param.subset = subset;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function tag_subset_full_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_subset_full (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tag_thresh_full_Callback(hObject, eventdata, handles)
% hObject    handle to tag_thresh_full (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_thresh_full as text
%        str2double(get(hObject,'String')) returns contents of tag_thresh_full as a double


% --- Executes during object creation, after setting all properties.
function tag_thresh_full_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_thresh_full (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tag_search_zone_full_Callback(hObject, eventdata, handles)
% hObject    handle to tag_search_zone_full (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_search_zone_full as text
%        str2double(get(hObject,'String')) returns contents of tag_search_zone_full as a double


% --- Executes during object creation, after setting all properties.
function tag_search_zone_full_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_search_zone_full (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% Correlate / cancel / quit

% --- Executes on button press in tag_correlate.
function tag_correlate_Callback(hObject, eventdata, handles)
% hObject    handle to tag_correlate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

t1 = clock;

%% Check to make sure you're not correlating reduced images and NOT using the reduced data

corr_reduced_selection = get(handles.tag_corr_reduced,'value');
correlate_full_selection = get(handles.tag_correlate_full,'value');
use_reduced_selection = get(handles.tag_use_reduced,'value');

if (corr_reduced_selection == 2 || corr_reduced_selection == 3) ... %Yes and Yes - use previous iteration
        && correlate_full_selection==2 && use_reduced_selection==1 %Yes and No
    
    w = warndlg('You are correlating reduced images but NOT using the reduced data!',...
        'Pointless correlation');
        waitfor(w)
        return
    
end

%% Get the info that was loaded during GUI initialization
filenamelist = handles.filenamelist;
image_setup = handles.image_setup;

grid_setup_reduced = handles.grid_setup_reduced;
gridx_reduced = handles.gridx_reduced;
gridy_reduced = handles.gridy_reduced;
corr_setup_reduced = handles.corr_setup_reduced;
dispx_reduced = handles.dispx_reduced;
dispy_reduced = handles.dispy_reduced;

grid_setup = handles.grid_setup;
gridx = handles.gridx;
gridy = handles.gridy;

N_images_correlated = image_setup.N_images_correlated;



%% Check to see if you want to use parallel for loops or serial loops
yn_parallel = get(handles.tag_parallel,'Value');
yn_serial = get(handles.tag_serial,'Value');

if yn_parallel == 1 %Use parallel for loops

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

    ref_image = 1;
    loop_type = 'parallel';
    
elseif yn_serial == 1 %Use serial for loops
    
    %Set the reference image
    yn_first = get(handles.tag_first_image,'value');
    yn_prec = get(handles.tag_preceeding_image,'value');
    if yn_first == 1
        ref_image = 1;
    elseif yn_prec == 1
        ref_image = 2;
        
    else %Neither are chosen
        w = warndlg('You did not choose a reference image','No reference image');
        waitfor(w)
        return
    end

    loop_type = 'serial';
    N_threads = [];
end



%% Reduced images

%Get amount of image reduction
reduction = str2double(get(handles.tag_reduction,'string'));
thresh_reduced = str2double(get(handles.tag_thresh_reduced,'string'));
search_zone_default_reduced = str2double(get(handles.tag_search_zone_reduced,'string'));

%Check to make sure the search zone is an integer:
if mod(search_zone_default_reduced,1) ~= 0 %User inputted a non-integer search zone size
    w = warndlg('The search zone must be an integer!','Integer search zone');
    waitfor(w);
    return;
end

if corr_reduced_selection==2 || corr_reduced_selection==3 
   %Yes                      OR Yes - use previous iteration    
    
    %Get selection of "Define a new reduced grid" drop down menu
    reduced_grid_selection = get(handles.tag_reduced_grid,'Value');
    
    %Check to see if the current reduction matches the previous reduction (if a previous one exists)
    if ~isempty(grid_setup_reduced)
        reduction_prev = grid_setup_reduced.reduction;

        %Warn the user if the already-defined grid used a different reduction
        %factor and force them to change the reduction factor in the GUI
        if reduced_grid_selection == 1 && reduction ~= reduction_prev
            % Use previous grid        BUT Have different reduction from before
            reduction_string = num2str(reduction);
            reduction_prev_string = num2str(reduction_prev);
            w = warndlg({['Reduction factor is currently set to ',reduction_string,'.'];...
                ['Previously-defined grid used a reduction factor of ',reduction_prev_string,'.'];...
                ['Either change the reduction factor to ',reduction_prev_string,' or define a new grid.']});
            waitfor(w)
            return
        end
    end

    %Get reduced subset size
    subset_reduced = str2double(get(handles.tag_subset_reduced,'string'));
    if mod(subset_reduced,2) == 0 %The subset is even
        w = warndlg('The subset size must be odd!','Odd subset');
        waitfor(w);
        return;
    end
    
    %Set up the reduced grid, correlate the reduced images, and calculate
    %the reduced displacements
    [gridx_reduced,gridy_reduced,grid_setup_reduced,corr_setup_reduced,...
        dispx_reduced,dispy_reduced,corr_coeff_reduced] = ...
        grid_reduced_setup_fun(grid_setup_reduced,gridx_reduced,gridy_reduced,...
        corr_setup_reduced,reduced_grid_selection,reduction,...
        N_images_correlated,filenamelist,ref_image,subset_reduced,N_threads,...
        loop_type,corr_reduced_selection,...
        dispx_reduced,dispy_reduced,thresh_reduced,search_zone_default_reduced);
    
    %Set the "full grid message" to "yes"
    full_grid_message = 1;
    
    %Save the reduced data
    save('grid_setup_reduced','grid_setup_reduced');
    save('grid_reduced_data','gridx_reduced','gridy_reduced');
    save('corr_setup_reduced','corr_setup_reduced')
    save('disp_reduced_data','dispx_reduced','dispy_reduced','corr_coeff_reduced');
    
elseif corr_reduced_selection==1
    
    %If this is the first time correlate_images_GUI is run in this folder,
    %then create an empty set of reduced variables.  Otherwise, if there
    %already exists a set of reduced variables, don't do anything, or
    %you'll overwrite reduced data!
    if exist('grid_setup_reduced.mat') == 0
    
        grid_setup_reduced = [];
        gridx_reduced = [];
        gridy_reduced = [];
        corr_setup_reduced = [];
        dispx_reduced = [];
        dispy_reduced = [];
        corr_coeff_reduced = [];

        %Save the reduced data
        save('grid_setup_reduced','grid_setup_reduced');
        save('grid_reduced_data','gridx_reduced','gridy_reduced');
        save('corr_setup_reduced','corr_setup_reduced')
        save('disp_reduced_data','dispx_reduced','dispy_reduced','corr_coeff_reduced');
    end
    
    full_grid_message = 0;

end


%% Full images

subset = str2double(get(handles.tag_subset_full,'string'));
if mod(subset,2) == 0 %The subset is even
    w = warndlg('The subset size must be odd!','Odd subset');
    waitfor(w);
    return;
end

if correlate_full_selection==2 %Yes

    %% Full grid

    %Get selection of "Define a new reduced grid" drop down menu
    full_grid_contents = cellstr(get(handles.tag_full_grid,'String'));
    full_grid_selection = full_grid_contents{get(handles.tag_full_grid,'Value')};

    %When generating the full grid and correlating the full images, reduction must be 1 (no reduction)
    reduction_full = 1; 

    %Set up the full grid
    [gridx,gridy,grid_setup] = grid_setup_fun(grid_setup,gridx,gridy,...
        full_grid_selection,full_grid_message,reduction_full);
    
    N_pts = grid_setup.N_pts;


    %% Correlate reduced and full grids
    
    %Use default search zone of 2; if you can't capture large displacements
    %with the search zone of 2, correlate reduced images first and use the
    %reduced correlation results as initial guesses in the correlation of
    %the full images.  Only in extreme cases should you change the search
    %zone.
    search_zone_default_full = str2double(get(handles.tag_search_zone_full,'string'));
    
    %Check to make sure the search zone is an integer:
    if mod(search_zone_default_full,1) ~= 0 %User inputted a non-integer search zone size
        w = warndlg('The search zone must be an integer!','Integer search zone');
        waitfor(w);
        return;
    end
    
    search_zone = search_zone_default_full*ones(N_pts,N_images_correlated); 
    
    if use_reduced_selection==1 %No
        initialx = zeros(N_pts,N_images_correlated);
        initialy = zeros(N_pts,N_images_correlated);
        
    elseif use_reduced_selection==2 %Yes
        reduction_prev = corr_setup_reduced.reduction;    
        
        %Match the reduced grid from the correlation of reduced images with
        %the full grid from the correlation of full images.
        [initialx,initialy] = grid_correlation(gridx_reduced,gridy_reduced,gridx,gridy,...
            grid_setup,dispx_reduced,dispy_reduced,reduction_prev,N_images_correlated,ref_image);
    
    end


    %% Remove grid points from the border region of the image
    [N_pts,gridx,gridy,grid_setup,initialx,initialy,search_zone] = delete_grid_boundaries(...
        gridx,gridy,grid_setup,subset,initialx,initialy,search_zone,filenamelist,...
        reduction_full);


    %% Correlate the full images
    
    thresh_full = str2double(get(handles.tag_thresh_full,'string'));
    t2 = clock;

    [validx,validy,corr_coeff_full] = automate_image_GUI_compatible...
        (filenamelist,reduction_full,gridx,gridy,ref_image,subset,search_zone,...
        N_images_correlated,N_pts,initialx,initialy,N_threads,loop_type,thresh_full);

    t3 = clock;


    save('grid_data','gridx','gridy');
    save('valid_data','validx','validy','corr_coeff_full');
    save('grid_setup','grid_setup');
    save('disp_initial_data','initialx','initialy','search_zone')


    %% Get the times for the running the code:
    total_time = etime(t3,t1);
    automate_image_time = etime(t3,t2);
    
    %Save the correlation parameters
    corr_setup.today = clock; %Get the current date and time
    corr_setup.subset = subset;
    corr_setup.ref_image = ref_image;
    corr_setup.N_images_correlated = N_images_correlated;
    corr_setup.parallel = yn_parallel;
    corr_setup.serial = yn_serial;
    corr_setup.search_zone = search_zone;
    corr_setup.reduced_type = use_reduced_selection;
    corr_setup.total_time = total_time;
    corr_setup.automate_image_time = automate_image_time;
    corr_setup.thresh_full = thresh_full;
    corr_setup.default_search_zone_full = search_zone_default_full;
    save('corr_setup','corr_setup')
    
    %% Compute the displacements (in pixels)
    [dispx_raw,dispy_raw] = calc_disp(grid_setup,corr_setup,gridx,gridy,validx,validy);
    save('disp_raw_data','dispx_raw','dispy_raw')
    

elseif correlate_full_selection==1 %No
    total_time = [];
    automate_image_time = [];
    search_zone = 'N/A';
    reduced_type_selection = 'N/A';
    
    %If this is the first time correlate_images_GUI is run in this folder,
    %then create an empty set of variables.  Otherwise, if there
    %already exists a set of variables, don't do anything, or
    %you'll overwrite data!
    if exist('grid_setup.mat') == 0
    
        grid_setup = [];
        gridx = [];
        gridy = [];
        corr_setup = [];
        validx = [];
        validy = [];
        corr_coeff_full = [];
        
        dispx_smooth = [];
        dispy_smooth = [];
        dispx_raw = [];
        dispy_raw = [];
        gridx_scale = [];
        gridy_scale = [];

        DU_FEM = [];
        D2U_FEM = [];
        gridx_DU = [];
        gridy_DU = [];
        FEM_setup.N_Node_DU = [];
        small_strain = [];
        large_strain = [];
        
        %Save the reduced data
        save('grid_setup','grid_setup');
        save('grid_data','gridx','gridy');
        save('corr_setup','corr_setup')
        save('valid_data','validx','validy','corr_coeff_full');
        save('disp_smooth_data','dispx_smooth','dispy_smooth')
        save('disp_raw_data','dispx_raw','dispy_raw')
        save('grid_scale_data','gridx_scale','gridy_scale')
        save('DU_data','DU_FEM','gridx_DU','gridy_DU','D2U_FEM','large_strain','small_strain')
        save('FEM_setup','FEM_setup')
    end


end




%Resume the GUI
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
