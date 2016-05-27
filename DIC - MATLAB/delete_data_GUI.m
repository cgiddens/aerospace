function varargout = delete_data_GUI(varargin)
% DELETE_DATA_GUI MATLAB code for delete_data_GUI.fig
%      DELETE_DATA_GUI, by itself, creates a new DELETE_DATA_GUI or raises the existing
%      singleton*.
%
%      H = DELETE_DATA_GUI returns the handle to a new DELETE_DATA_GUI or the handle to
%      the existing singleton*.
%
%      DELETE_DATA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DELETE_DATA_GUI.M with the given input arguments.
%
%      DELETE_DATA_GUI('Property','Value',...) creates a new DELETE_DATA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before delete_data_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to delete_data_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help delete_data_GUI

% Last Modified by GUIDE v2.5 03-Jul-2012 12:01:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @delete_data_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @delete_data_GUI_OutputFcn, ...
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


% --- Executes just before delete_data_GUI is made visible.
function delete_data_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to delete_data_GUI (see VARARGIN)

% Choose default command line output for delete_data_GUI
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

%Set the default values:
set(handles.tag_image_number,'string','1');
handles.del_pts_index_matrix = [];
handles.del_pts_index_vector =[];
handles.N_pts_new = [];

%Load the correlated data:
load valid_data
load grid_data
load disp_raw_data
load grid_setup
load corr_setup

try
    load grid_deformed_data
catch
    gridx_def = [];
    gridy_def = [];
    gridx_DU_def = [];
    gridy_DU_def = [];
end


%Save data into the handles
handles.computed_data.grid_setup = grid_setup;
handles.computed_data.corr_setup = corr_setup;
handles.computed_data.gridx = gridx;
handles.computed_data.gridy = gridy;
handles.computed_data.dispx_raw = dispx_raw;
handles.computed_data.dispy_raw = dispy_raw;
handles.computed_data.validx = validx;
handles.computed_data.validy = validy;
handles.computed_data.corr_coeff_full = corr_coeff_full;
handles.computed_data.gridx_def = gridx_def;
handles.computed_data.gridy_def = gridy_def;
handles.computed_data.FEM_setup.scale = 1;

% Update handles structure
guidata(hObject, handles);

%Warn the user to only use this function w/ raw data (no smoothing, no disp
%grad)
w = warndlg('Use this function on raw data only (no smoothing, no disp gard)',...
    'Raw data');
waitfor(w);

% UIWAIT makes delete_data_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = delete_data_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;
close all


function tag_image_number_Callback(hObject, eventdata, handles)
% hObject    handle to tag_image_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_image_number as text
%        str2double(get(hObject,'String')) returns contents of tag_image_number as a double


% --- Executes during object creation, after setting all properties.
function tag_image_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_image_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tag_grid.
function tag_grid_Callback(hObject, eventdata, handles)
% hObject    handle to tag_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the data and store in a working/temporary variable:
N_pts = handles.computed_data.grid_setup.N_pts;
x_matrix = handles.computed_data.grid_setup.x_matrix; %pixels
y_matrix = handles.computed_data.grid_setup.y_matrix; %pixels
gridx = handles.computed_data.gridx; %pixels
gridy = handles.computed_data.gridy; %pixels
% reduction = handles.computed_data.grid_setup.reduction;


%Get the main GUI position and set the figure to be just to the right of the GUI
scnsize = handles.scnsize; %in pixels
GUIpos = handles.GUIpos; %in pixels

leftborder = 30;
topborder = 10;

figheight = 700;
figwidth = 875;

figleft = GUIpos(1) + GUIpos(3) + leftborder;
figbottom = scnsize(4) - figheight - topborder;

figpos = [figleft,figbottom,figwidth,figheight];

%Show the current grid points overlayed on a base image
[FileNameBase,PathNameBase,FilterIndex] = uigetfile( ...
    {'*.bmp;*.tif;*.jpg;*.tiff;*.TIF;*.BMP;*.JPG;*.TIFF','Image files (*.bmp,*.tif,*.jpg,*.tiff)';'*.*',  'All Files (*.*)'}, ...
    'Open base image for grid creation');

im_grid = imread([PathNameBase,FileNameBase]);

m = figure('units','pixels','OuterPosition',figpos);
imshow(im_grid);
hold on
plot(x_matrix,y_matrix,'ob')
hold off
title(sprintf('Define the region of interest. \n All points inside taht region will be deleted'))

more_pts = 'Yes';
del_pts_index_matrix = [];
del_pts_index_vector = [];
while strcmp(more_pts,'Yes') == 1

    %Choose region of points to delete:
    figure(m)
    hold on
    [xdel(1),ydel(1)] = ginput(1);
    plot(xdel(1),ydel(1),'+r')
    [xdel(2),ydel(2)] = ginput(1);
    plot(xdel(2),ydel(2),'+r')
    hold off

    %Find the index of the points to be deleted
    del_pts_index_matrix_i = find(x_matrix>min(xdel) & x_matrix<max(xdel)...
        & y_matrix>min(ydel) & y_matrix<max(ydel));
    del_pts_index_vector_i = find(gridx>min(xdel) & gridx<max(xdel)...
        & gridy>min(ydel) & gridy<max(ydel));
    del_pts_index_matrix = unique([del_pts_index_matrix; del_pts_index_matrix_i]);
    del_pts_index_vector = unique([del_pts_index_vector; del_pts_index_vector_i]);


    %Delete points temporarily:
    gridx_temp = gridx;
    x_matrix_temp = x_matrix;
    y_matrix_temp = y_matrix;
    gridx_temp(del_pts_index_vector) = [];
    x_matrix_temp(del_pts_index_matrix) = NaN;
    y_matrix_temp(del_pts_index_matrix) = NaN;
    N_pts_new = length(gridx_temp);

    %Show new grid:
    figure(m)
    imshow(im_grid);
    hold on
    plot(x_matrix_temp,y_matrix_temp,'ob')
    hold off

    more_pts = questdlg('Would you like to select more points to delete?',...
        'More points?','Yes','No','No');

end


%Save the indices of the deleted points
handles.del_pts_index_matrix = del_pts_index_matrix;
handles.del_pts_index_vector = del_pts_index_vector;
handles.N_pts_new = N_pts_new;
guidata(hObject,handles);


% --- Executes on button press in tag_vec.
function tag_vec_Callback(hObject, eventdata, handles)
% hObject    handle to tag_vec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the data
gridx = handles.computed_data.gridx; %pixels
gridy = handles.computed_data.gridy; %pixels
dispx = handles.computed_data.dispx_raw; %pixels
dispy = handles.computed_data.dispy_raw; %pixels
N_pts = handles.computed_data.grid_setup.N_pts;
x_matrix = handles.computed_data.grid_setup.x_matrix; %in pixels
y_matrix= handles.computed_data.grid_setup.y_matrix; %in pixels

image_number = str2double(get(handles.tag_image_number,'string'));

%Set the vector field parameters:
reduction = 1; %Delete data works with full images
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
qscale = quiver_param.qscale;
gridx = quiver_param.gridx;
gridy = quiver_param.gridy;
qskip = quiver_param.qskip;

m = figure('units','pixels','OuterPosition',figpos,'windowstyle','normal');
xmin = min(min(gridx)) - 0.1*max(max(gridx));
xmax = max(max(gridx)) + 0.1*max(max(gridx));
ymin = min(min(gridy)) - 0.1*max(max(gridy));
ymax = max(max(gridy)) + 0.1*max(max(gridy));

figure(m)
h = quiver(gridx(1:qskip:end,image_number),gridy(1:qskip:end,image_number),...
    dispx(1:qskip:end,image_number),dispy(1:qskip:end,image_number),0);
hU = get(h,'UData');
hV = get(h,'VData');
set(h,'UData',qscale*hU,'VData',qscale*hV)
axis ij
axis equal
axis([xmin xmax ymin ymax])
title('Vectorfield of displacements','fontsize',16,'fontweight','bold')
xlabel('X (pixels)','fontsize',16)
ylabel('Y (pixels)','fontsize',16)
set(gca,'fontsize',12)

more_pts = 'Yes';
del_pts_index_matrix = [];
del_pts_index_vector = [];
while strcmp(more_pts,'Yes') == 1

    %Choose the region of points to delete:
    [xdel(1),ydel(1)] = ginput(1);
    figure(m)
    hold on
    plot(xdel(1),ydel(1),'+r')
    [xdel(2),ydel(2)] = ginput(1);
    plot(xdel(2),ydel(2),'+r')
    hold off


    %Find the index of the points to be deleted
    del_pts_index_matrix_i = find(x_matrix>min(xdel) & x_matrix<max(xdel)...
        & y_matrix>min(ydel) & y_matrix<max(ydel));
    del_pts_index_vector_i = find(gridx(:,image_number)>min(xdel) & gridx(:,image_number)<max(xdel)...
        & gridy(:,image_number)>min(ydel) & gridy(:,image_number)<max(ydel));
    del_pts_index_matrix = unique([del_pts_index_matrix; del_pts_index_matrix_i]);
    del_pts_index_vector = unique([del_pts_index_vector; del_pts_index_vector_i]);


    %Delete points temporarily:
    gridx_temp = gridx;
    gridy_temp = gridy;
    dispx_temp = dispx;
    dispy_temp = dispy;
    gridx_temp(del_pts_index_vector,:) = [];
    gridy_temp(del_pts_index_vector,:) = [];
    dispx_temp(del_pts_index_vector,:) = [];
    dispy_temp(del_pts_index_vector,:) = [];
    N_pts_new = length(gridx_temp);

    %Show the new vector field
    figure(m)
    h = quiver(gridx_temp(1:qskip:end,image_number),gridy_temp(1:qskip:end,image_number),...
        dispx_temp(1:qskip:end,image_number),dispy_temp(1:qskip:end,image_number),0);
    hU = get(h,'UData');
    hV = get(h,'VData');
    set(h,'UData',qscale*hU,'VData',qscale*hV)
    axis ij
    axis equal
    axis([xmin xmax ymin ymax])
    title('Vectorfield of displacements','fontsize',16,'fontweight','bold')
    xlabel('X (pixels)','fontsize',16)
    ylabel('Y (pixels)','fontsize',16)
    set(gca,'fontsize',12)

    more_pts = questdlg('Would you like to select more points to delete?',...
        'More points?','Yes','No','No');   
end


%Save the indices of the deleted points
handles.del_pts_index_matrix = del_pts_index_matrix;
handles.del_pts_index_vector = del_pts_index_vector;
handles.N_pts_new = N_pts_new;
guidata(hObject,handles);
    

% --- Executes on button press in tag_patch_contour.
function tag_patch_contour_Callback(hObject, eventdata, handles)
% hObject    handle to tag_patch_contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the data
gridx = handles.computed_data.gridx; %pixels
gridy = handles.computed_data.gridy; %pixels
N_images_correlated = handles.computed_data.corr_setup.N_images_correlated;
N_pts = handles.computed_data.grid_setup.N_pts;
x_matrix = handles.computed_data.grid_setup.x_matrix; %in pixels
y_matrix= handles.computed_data.grid_setup.y_matrix; %in pixels
step = handles.computed_data.grid_setup.step; %Step size in pixels
scale = handles.computed_data.FEM_setup.scale;
dispx = handles.computed_data.dispx_raw;
dispy = handles.computed_data.dispy_raw;
corr_coeff_full = handles.computed_data.corr_coeff_full;

image_number = str2double(get(handles.tag_image_number,'string'));

%Set the patch contour parameters:
param_disp_patch_contour = disp_patch_contour_GUI(scale,N_images_correlated,...
    dispx,dispy,corr_coeff_full,1,handles.computed_data);
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

%Set the axes for the contour plot
m = figure('units','pixels','OuterPosition',figpos,'windowstyle','normal');
xmin = min(gridx) - 0.05*max(gridx);
xmax = max(gridx) + 0.05*max(gridx);
ymin = min(gridy) - 0.05*max(gridy);
ymax = max(gridy) + 0.05*max(gridy);

%Get the patch contour parameters:
unit = 'pixels';
data = param_disp_patch_contour.data;
plot_title = param_disp_patch_contour.plot_title;
a = param_disp_patch_contour.a;
b = param_disp_patch_contour.b;
images_folder = param_disp_patch_contour.images_folder;
opacity = param_disp_patch_contour.opacity;
images = param_disp_patch_contour.images;


%% Plot the original patch contour
% Form the vertices of the squares surrounding the grid nodes
gridx_patch = zeros(4,N_pts);
gridy_patch = zeros(4,N_pts);
for i = 1:N_pts
    gridx_patch(:,i) = [gridx(i) - step/2; gridx(i) - step/2; gridx(i) + step/2; gridx(i) + step/2];
    gridy_patch(:,i) = [gridy(i) + step/2; gridy(i) - step/2; gridy(i) - step/2; gridy(i) + step/2];
end

%Show the image (if desired)
if images_folder ~= 0 %A folder was chosen
    image_i_name = images(image_number).name;
    image_i = [images_folder,'\',image_i_name];
    warning('off','images:initSize:adjustingMag');
    image_layer = imshow(image_i);
end
freezeColors
hold on


% Transform the shape of disp_grad from one value at each DU node, to one value
% at each vertex of the square surrounding the DU node:
data_i = data(:,image_number); %i'th image
data_i_trans = data_i'; %transpose from column to row vector
data_patch = [data_i_trans; data_i_trans; data_i_trans; data_i_trans]; %Same disp grad at four vertices of patch square

%Make the contour plot
colormap('jet')
patch(gridx_patch,gridy_patch,data_patch,'EdgeColor','none','FaceAlpha',opacity)
axis ij
axis equal
if images_folder == 0
    axis([xmin xmax ymin ymax])
end
title(['Contour plot of ',plot_title],'fontsize',16,'fontweight','bold')
xlabel('X (pixels)', 'fontsize',16)
ylabel('Y (pixels)','fontsize',16)
set(gca,'fontsize',12)
caxis([a(image_number),b(image_number)])
h = colorbar('Location','EastOutside');
title (h,unit,'fontsize',12)

more_pts = 'Yes';
del_pts_index_matrix = [];
del_pts_index_vector = [];
while strcmp(more_pts, 'Yes') == 1

    %% Choose the region of points to delete:
    [xdel(1),ydel(1)] = ginput(1);
    figure(m)
    hold on
    plot(xdel(1),ydel(1),'+r')
    [xdel(2),ydel(2)] = ginput(1);
    plot(xdel(2),ydel(2),'+r')
    hold off
    
%     %TEMPORARY
%     xdel(1) = 251;
%     xdel(2) = 259;
%     ydel(1) = 0;
%     ydel(2) = 513;

    %Find the index of the points to be deleted
    del_pts_index_matrix_i = find(x_matrix>min(xdel) & x_matrix<max(xdel)...
        & y_matrix>min(ydel) & y_matrix<max(ydel));
    del_pts_index_vector_i = find(gridx>min(xdel) & gridx<max(xdel)...
        & gridy>min(ydel) & gridy<max(ydel));
    del_pts_index_matrix = unique([del_pts_index_matrix; del_pts_index_matrix_i]);
    del_pts_index_vector = unique([del_pts_index_vector; del_pts_index_vector_i]);


    %Delete points temporarily:
    gridx_temp = gridx;
    gridy_temp = gridy;
    data_temp = data;
    gridx_temp(del_pts_index_vector) = [];
    gridy_temp(del_pts_index_vector) = [];
    data_temp(del_pts_index_vector,:) = [];
    N_pts_new = length(gridx_temp);


    %% Replot the new patch contour plot
    % Form the vertices of the squares surrounding the grid nodes
    gridx_patch = zeros(4,N_pts_new);
    gridy_patch = zeros(4,N_pts_new);
    for i = 1:N_pts_new
        gridx_patch(:,i) = [gridx_temp(i) - step/2; gridx_temp(i) - step/2; gridx_temp(i) + step/2; gridx_temp(i) + step/2];
        gridy_patch(:,i) = [gridy_temp(i) + step/2; gridy_temp(i) - step/2; gridy_temp(i) - step/2; gridy_temp(i) + step/2];
    end


    % Transform the shape of disp_grad from one value at each DU node, to one value
    % at each vertex of the square surrounding the DU node:
    data_i = data_temp(:,image_number); %i'th image
    data_i_trans = data_i'; %transpose from column to row vector
    data_patch = [data_i_trans; data_i_trans; data_i_trans; data_i_trans]; %Same disp grad at four vertices of patch square

    %Reset the figure
    close(m)
    m = figure('units','pixels','OuterPosition',figpos,'windowstyle','normal');

    %Show the image (if desired)
    if images_folder ~= 0 %A folder was chosen
        image_i_name = images(image_number).name;
        image_i = [images_folder,'\',image_i_name];
        warning('off','images:initSize:adjustingMag');
        image_layer = imshow(image_i);
    end
    freezeColors
    hold on

    %Make the contour plot
    colormap('jet')
    patch(gridx_patch,gridy_patch,data_patch,'EdgeColor','none','FaceAlpha',opacity)
    axis ij
    axis equal
    if images_folder == 0
        axis([xmin xmax ymin ymax])
    end
    title(['Contour plot of ',plot_title],'fontsize',16,'fontweight','bold')
    xlabel('X (pixels)', 'fontsize',16)
    ylabel('Y (pixels)','fontsize',16)
    set(gca,'fontsize',12)
    caxis([a(image_number),b(image_number)])
    h = colorbar('Location','EastOutside');
    title (h,unit,'fontsize',12)

    more_pts = questdlg('Would you like to select more points to delete?',...
        'More points?','Yes','No','No');  

end


%Save the indices of the deleted points
handles.del_pts_index_matrix = del_pts_index_matrix;
handles.del_pts_index_vector = del_pts_index_vector;
handles.N_pts_new = N_pts_new;
guidata(hObject,handles);



% --- Executes on button press in tag_delete.
function tag_delete_Callback(hObject, eventdata, handles)
% hObject    handle to tag_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the data
del_pts_index_matrix = handles.del_pts_index_matrix;
del_pts_index_vector = handles.del_pts_index_vector;
N_pts_new = handles.N_pts_new;
validx = handles.computed_data.validx;
validy = handles.computed_data.validy;
corr_coeff_full = handles.computed_data.corr_coeff_full;
dispx_raw = handles.computed_data.dispx_raw;
dispy_raw = handles.computed_data.dispy_raw;
gridx = handles.computed_data.gridx;
gridy = handles.computed_data.gridy;
x_matrix = handles.computed_data.grid_setup.x_matrix;
y_matrix = handles.computed_data.grid_setup.y_matrix;
corr_setup = handles.computed_data.corr_setup;
% scale = handles.computed_data.FEM_setup.scale;
grid_setup = handles.computed_data.grid_setup;

%Check to see if data was selected to be deleted:
if isempty(del_pts_index_vector) == 1 %No data was selected to be deleted
    h = warndlg('No data was selected to be deleted','No Data');
    waitfor(h)
    return
end

%Confirm that the user really does want to delete the data:
yn_delete = questdlg('Are you sure you want to delete the data?','Delete Data',...
    'Yes','No','No');
if strcmp(yn_delete,'No') == 1
    return
end


%Remove the data
gridx(del_pts_index_vector) = [];
gridy(del_pts_index_vector) = [];
validx(del_pts_index_vector,:) = [];
validy(del_pts_index_vector,:) = [];
dispx_raw(del_pts_index_vector,:) = [];
dispy_raw(del_pts_index_vector,:) = [];
corr_coeff_full(del_pts_index_vector,:) = [];
x_matrix(del_pts_index_matrix) = NaN;
y_matrix(del_pts_index_matrix) = NaN;

grid_setup.x_matrix = x_matrix;
grid_setup.y_matrix = y_matrix;
grid_setup.N_pts = N_pts_new;

%Set any previously computed data to empty (forcing recomputation):
dispx_smooth = [];
dispy_smooth = [];
gridx_scale = [];
gridy_scale = [];
FEM_setup = [];
FEM_setup.N_Node_DU = [];
DU_FEM = [];
D2U_FEM = [];
gridx_DU = [];
gridy_DU = [];
large_strain = [];
small_strain = [];


%Save the data
save('grid_data','gridx','gridy')
save('valid_data','validx','validy','corr_coeff_full')
save('disp_raw_data','dispx_raw','dispy_raw');
save('grid_setup','grid_setup');

save('grid_scale_data','gridx_scale','gridy_scale')
save('disp_smooth_data','dispx_smooth','dispy_smooth')
save('FEM_setup','FEM_setup')
save('DU_data','DU_FEM','D2U_FEM','gridx_DU','gridy_DU','large_strain','small_strain')



%Save the data in the GUI handles
handles.computed_data.gridx = gridx;
handles.computed_data.gridy = gridy;
handles.computed_data.validx = validx;
handles.computed_data.validy = validy;
handles.computed_data.dispx_raw = dispx_raw;
handles.computed_data.dispy_raw = dispy_raw;
handles.computed_data.grid_setup = grid_setup;
handles.computed_data.corr_coeff_full = corr_coeff_full;


%Close the current figure
figure(1)
close(gcf)

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in tag_done.
function tag_done_Callback(hObject, eventdata, handles)
% hObject    handle to tag_done (see GCBO)
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
