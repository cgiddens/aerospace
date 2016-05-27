function varargout = image_setup_GUI(varargin)
% IMAGE_SETUP_GUI M-file for image_setup_GUI.fig
%      IMAGE_SETUP_GUI, by itself, creates a new IMAGE_SETUP_GUI or raises the existing
%      singleton*.
%
%      H = IMAGE_SETUP_GUI returns the handle to a new IMAGE_SETUP_GUI or the handle to
%      the existing singleton*.
%
%      IMAGE_SETUP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGE_SETUP_GUI.M with the given input arguments.
%
%      IMAGE_SETUP_GUI('Property','Value',...) creates a new IMAGE_SETUP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before image_setup_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to image_setup_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help image_setup_GUI

% Last Modified by GUIDE v2.5 30-May-2012 10:47:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @image_setup_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @image_setup_GUI_OutputFcn, ...
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


% --- Executes just before image_setup_GUI is made visible.
function image_setup_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to image_setup_GUI (see VARARGIN)

%Set default values
set(handles.tag_image_skip,'string',1)

% Choose default command line output for image_setup_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes image_setup_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = image_setup_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;
delete(hObject);


% --- Executes on selection change in tag_extension.
function tag_extension_Callback(hObject, eventdata, handles)
% hObject    handle to tag_extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns tag_extension contents as cell array
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


% --- Executes on button press in tag_set.
function tag_set_Callback(hObject, eventdata, handles)
% hObject    handle to tag_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the parameters:
contents_extension = get(handles.tag_extension,'String');
image_extension = contents_extension{get(handles.tag_extension,'Value')};
if isempty(image_extension) == 1 
    w = warndlg('You did not choose a file extension for the images.','No Extension');
    waitfor(w);
    return
end

image_skip = str2double(get(handles.tag_image_skip,'string'));


%Get the images with the appropriate extension from the current working
%directory
images = dir(['*',image_extension]);

if isempty(images) == 1 %No images in the directory with the chosen extension
    w = warndlg('There are no images in the working directory with the chosen file extension.','No Images');
    waitfor(w);
    return
end


N_images_total = length(images);

%Find the number of characters in the longest image name
L_name = zeros(N_images_total,1);
for i = 1:size(images)
    cell = images(i);
    name = cell.name;
    L_name(i) = length(name);
end
L_name_max = max(L_name);

%Create a list of the names of ALL the images in the working directory
filenamelist_total = repmat(' ',[N_images_total,L_name_max]);
for i = 1:size(images)
    cell = images(i);
    name = cell.name;
    L_name_i = length(name);
    diff_i = L_name_max - L_name_i;
    if diff_i ~= 0
        extra = repmat('0',[1,diff_i]);
        name_new = [extra,name];
        movefile(name,name_new);
    elseif diff_i == 0
        name_new = name;
    end

    filenamelist_total(i,:) = name_new;
end
filenamelist_total = sortrows(filenamelist_total);


%Convert the images to gray scale if necessary
image_1 = imread(filenamelist_total(1,:));
[Nrow,Ncol,Ncolor] = size(image_1);

if Ncolor ~= 1 %Images are color images and need to be converted to gray scale
    
    yn_convert = questdlg('The images are in color and must be converted to gray scale before correlating them.  Would you like to convert them now?',...
        'Convert images to gray scale?','No, cancel','Yes, convert','No, cancel');
    
    if strcmp(yn_convert,'Yes, convert') == 1 %Convert the images
        
        for i = 1:N_images_total %Loop over all the images
            image_i = imread(filenamelist_total(i,:));
            image_i_gray = uint8(mean(image_i,3));
            imwrite(image_i_gray,filenamelist_total(i,:));
        end
        
    else %Do NOT convert images
        return
    end
    
end


%Remove the images according to image skip:
if image_skip ~= 1 

    N_images_correlated = ceil(N_images_total/image_skip);
    filenamelist = repmat(' ',[N_images_correlated,L_name_max]);
    k = 1;
    for i = 1:image_skip:N_images_total
        filenamelist(k,:) = filenamelist_total(i,:);
        k = k+1;
    end
    
else
    
    N_images_correlated = N_images_total;
    filenamelist = filenamelist_total;
    
end
save('filenamelist','filenamelist')

%Save the image setup parameters
image_setup.extension = image_extension;
image_setup.N_images_total = N_images_total;
image_setup.N_images_correlated = N_images_correlated;
save('image_setup','image_setup')

%Resume the GUI
uiresume(handles.figure1);


% --- Executes on button press in tag_quit.
function tag_quit_Callback(hObject, eventdata, handles)
% hObject    handle to tag_quit (see GCBO)
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
