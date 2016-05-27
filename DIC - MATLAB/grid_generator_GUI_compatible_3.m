function [gridx,gridy,grid_param] = grid_generator_GUI_compatible_3(reduction)

%Prompt the user to open the base image to define the grid on
drawnow
[FileNameBase,PathNameBase,FilterIndex] = uigetfile( ...
    {'*.bmp;*.tif;*.jpg;*.tiff;*.TIF;*.BMP;*.JPG;*.TIFF','Image files (*.bmp,*.tif,*.jpg,*.tiff)';'*.*',  'All Files (*.*)'}, ...
    'Open base image for grid creation');
cd(PathNameBase)
im_grid = imresize(imread(FileNameBase),1/reduction);

%Make the initial, rectangular grid
[x,y,grid_param] = initial_grid(im_grid);

% Do you want to keep/add the grid?
make_grid = 1;

while make_grid == 1
confirmselection = menu_mod(sprintf('What would you like to do with this grid?'),...
    'Keep this grid','Remove points','Start over');

    % Keep this grid
    if confirmselection == 1
        % Save the matrix form of the grid coordinates
        grid_param.x_matrix = x;
        grid_param.y_matrix = y;
        
        %Reshape to vectors and remove all 'NaN' values from the grid
        %coordinates
        gridx=reshape(x,[],1);
        gridy=reshape(y,[],1);
        index = find(isnan(gridx) == 1);
        gridx(index) = [];
        gridy(index) = [];
        fig = gcf;
        close(fig);
        make_grid = 0;
    end

    %Remove points
    if confirmselection == 2
        fig = gcf;
        close(fig);
        [x,y,grid_param] = remove_points(x,y,im_grid,grid_param);
    end

    % Start over
    if confirmselection == 3
        fig = gcf;
        close(fig)
        [x,y,grid_param] = initial_grid(im_grid);
    end

end

end

function [x,y,grid_param] = initial_grid(im_grid)
clear x y
m = figure;
% hold off
imshow(im_grid,'InitialMagnification',100,'displayrange',[]); %show chosen Image


%Define a rectangular grid
title(sprintf('Define the region of interest by clicking on the UPPER LEFT and LOWER RIGHT corners.'));

[x(1,1),y(1,1)]=ginput(1);
hold on
plot(x(1,1),y(1,1),'s','markerfacecolor',[255 177 100]/255,'markeredgecolor','none','markersize',3)

[x(2,1),y(2,1)]=ginput(1);
hold on
plot(x(2,1),y(2,1),'s','markerfacecolor',[255 177 100]/255,'markeredgecolor','none','markersize',3)

drawnow

xmin = min(x);
xmax = max(x);
ymin = min(y);
ymax = max(y);

lowerline=[xmin ymin; xmax ymin];
upperline=[xmin ymax; xmax ymax];
leftline=[xmin ymin; xmin ymax];
rightline=[xmax ymin; xmax ymax];

plot(lowerline(:,1),lowerline(:,2),'-','color',[255 177 100]/255)
plot(upperline(:,1),upperline(:,2),'-','color',[255 177 100]/255)
plot(leftline(:,1),leftline(:,2),'-','color',[255 177 100]/255)
plot(rightline(:,1),rightline(:,2),'-','color',[255 177 100]/255)

% Prompt user for grid spacing/resolution
prompt = {'Enter step size [pixels]:'};
dlg_title = 'Input for grid creation';
num_lines= 1;
def     = {'20'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
step = str2double(cell2mat(answer(1,1)));


% Round xmin,xmax and ymin,ymax "up" based on selected spacing
numXelem = ceil((xmax-xmin)/step)-1;
numYelem = ceil((ymax-ymin)/step)-1;

xmin_new = ceil((xmax+xmin)/2-((numXelem/2)*step));
xmax_new = ceil((xmax+xmin)/2+((numXelem/2)*step));
ymin_new = ceil((ymax+ymin)/2-((numYelem/2)*step));
ymax_new = ceil((ymax+ymin)/2+((numYelem/2)*step));

% Create the analysis grid and show user
[x,y] = meshgrid(xmin_new:step:xmax_new,ymin_new:step:ymax_new);
[Ny, Nx] = size(x);
N_pts = Ny*Nx;
%zdummy = 200.*ones(rows,columns);
figure(m)
imshow(im_grid,'displayrange',[])
title(['Selected grid has ',num2str(N_pts), ' rasterpoints'])    % plot a title onto the image
plot(x,y,'s','markerfacecolor',[255 177 100]/255,'markeredgecolor','none','markersize',3)
    
%Store the grid parameters:
grid_param.step = step;
grid_param.N_pts = N_pts;
grid_param.Nx = Nx;
grid_param.Ny = Ny;
end

function [x,y,grid_param] = remove_points(x,y,im_grid,grid_param)
%Create a working copy of the grid
x_temp = x;
y_temp = y;

%Show the image with the current grid:
m = figure;
imshow(im_grid,'InitialMagnification',100,'displayrange',[]);
hold on
plot(x,y,'ob')
title(sprintf('Define the region of interest. \n All points inside that region will be deleted'))

%Choose region of points to delete:
[xdel(1),ydel(1)] = ginput(1);
plot(xdel(1),ydel(1),'+r')
[xdel(2),ydel(2)] = ginput(1);
plot(xdel(2),ydel(2),'+r')
hold off

%Find the index of the points to be deleted
delete_points_index = find(x>min(xdel) & x<max(xdel) & y>min(ydel) & y<max(ydel));
N_pts_remove = length(delete_points_index);

%Replace deleted poitns with "NaN"
x_temp(delete_points_index) = NaN;
y_temp(delete_points_index) = NaN;

%Show new grid:
figure(m)
imshow(im_grid,'InitialMagnification',100,'displayrange',[]);
hold on
plot(x_temp,y_temp,'ob')
hold off

%Delete points permanently?
keepchanges = menu_mod(sprintf('Do you want to delete these markers permanently?'),'Yes','No');
if keepchanges == 1
    x = x_temp;
    y = y_temp; 
    N_pts = grid_param.N_pts;
    N_pts = N_pts - N_pts_remove;
    grid_param.N_pts = N_pts;
elseif keepchanges == 2
    %Replot the original grid
    fig = gcf;
    close(gcf);
    N_pts = grid_param.N_pts;
    figure
    imshow(im_grid,'displayrange',[])
    title(['Selected grid has ',num2str(N_pts), ' rasterpoints'])    % plot a title onto the image
    hold on
    plot(x,y,'s','markerfacecolor',[255 177 100]/255,'markersize',2)
    hold off
end


end
