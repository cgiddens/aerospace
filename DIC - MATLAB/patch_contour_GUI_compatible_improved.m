function patch_contour_GUI_compatible_improved(figpos,N_images,skip,grid_param,...
    reduction,scale,N_Node,param_patch_contour)


%Get the patch contour parameters:
unitXY = param_patch_contour.unitXY;
unitE = param_patch_contour.unitE;
data = param_patch_contour.data;
plot_title = param_patch_contour.plot_title;
a = param_patch_contour.a;
b = param_patch_contour.b;
images_folder = param_patch_contour.images_folder;
opacity = param_patch_contour.opacity;
images = param_patch_contour.images;
xdata = param_patch_contour.xdata*reduction;
ydata = param_patch_contour.ydata*reduction;
gridx = param_patch_contour.gridx*reduction;
gridy = param_patch_contour.gridy*reduction;
x_matrix = grid_param.x_matrix;


%Get step size (in um):
step_pi = grid_param.step*reduction; %Step size in pixels
step = step_pi*scale; %Step size in um.

%Get the number of rows and columns from the original grid:
[Ny,Nx] = size(grid_param.x_matrix);

% Form the vertices of the squares surrounding the grid nodes
overlap=0;

aa = mat2cell(gridx,size(gridx,1),ones(1,size(gridx,2)));
gridx_patch = cellfun(@(x) [x' - step/2 - overlap*step; x' - step/2 - overlap*step;...
        x' + step/2 + overlap*step; x' + step/2 + overlap*step], aa,'uniformoutput',0);

aa = mat2cell(gridy,size(gridy,1),ones(1,size(gridy,2)));
gridy_patch = cellfun(@(x) [x' + step/2 + overlap*step; x' - step/2 - overlap*step;...
        x' - step/2 - overlap*step; x' + step/2 + overlap*step], aa,'uniformoutput',0);
  

%Create the patch contour plot
m = figure('units','pixels','OuterPosition',figpos,'windowstyle','normal');

xmin = min(min(gridx)) - 0.05*max(max(gridx));
xmax = max(max(gridx)) + 0.05*max(max(gridx));
ymin = min(min(gridy)) - 0.05*max(max(gridy));
ymax = max(max(gridy)) + 0.05*max(max(gridy));

patch_min_x = min(cell2mat(cellfun(@(x) min(min(x)),gridx_patch,'uniformoutput',0)));
patch_max_x = max(cell2mat(cellfun(@(x) max(max(x)),gridx_patch,'uniformoutput',0)));
patch_min_y = min(cell2mat(cellfun(@(x) min(min(x)),gridy_patch,'uniformoutput',0)));
patch_max_y = max(cell2mat(cellfun(@(x) max(max(x)),gridy_patch,'uniformoutput',0)));

gridx_patch_border = [xmin,         xmin,           xmin,           patch_max_x;... 
                      xmin,         xmin,           xmin,           patch_max_x;...
                      patch_min_x,  xmax,           xmax,           xmax;... 
                      patch_min_x,  xmax,           xmax,           xmax];
gridy_patch_border = [ymax,         patch_min_y,    ymax,           ymax;...
                      ymin,         ymin,           patch_max_y,    ymin;...
                      ymin,         ymin,           patch_max_y,    ymin;...
                      ymax,         patch_min_y,    ymax,           ymax];

patch_border_color =  [1 1 1] ;

for i = 1:skip:N_images
    figure(m)
    clf
    
    %Show the image (if desired)
    if images_folder ~= 0 %A folder was chosen
        image_i_name = images(i).name;
        
        try %Backslash for PCs
            image_i = [images_folder,'\',image_i_name];
        catch %Front slash for Macs
            image_i = [images_folder,'/',image_i_name];
        end
        
        warning('off','images:initSize:adjustingMag');
        %Original (V1) resized the images, but the contour was with the
        %normal-sized grid; new code does not resize images.
%         image_layer = imshow(imresize(imread(image_i),1/reduction),...
%             'xdata',xdata,'ydata',ydata);
        image_layer = imshow(imread(image_i),'xdata',xdata,'ydata',ydata);
        freezeColors
        hold on
    else
        patch(gridx_patch_border,gridy_patch_border,patch_border_color,'edgecolor','none');
        hold on
    end
 
    
    if size(gridx_patch,2)>1 %Deformed grid, new grid for each image
        %Get the patch for the i'th image
        gridx_patch_i = gridx_patch{i};
        gridy_patch_i = gridy_patch{i};
        
        %Alter the patch slightly to get rid of the white lines inbetween
        %patch elements by merging close points
        [gridx_patch_i,gridy_patch_i] = merge_points(gridx_patch_i,gridy_patch_i,Ny,Nx,x_matrix);
    else %Reference grid, same grid for each image
        gridx_patch_i = gridx_patch{1};
        gridy_patch_i = gridy_patch{1};
    end
    
    %Get the data for the i'th image
    data_i = data(:,i); %i'th image
    data_i_trans = data_i'; %transpose from column to row vector
    data_patch = [data_i_trans; data_i_trans; data_i_trans; data_i_trans]; %Same disp grad at four vertices of patch square
    
    %Plot the patch
    colormap('jet')
    patch_layer = patch(gridx_patch_i,gridy_patch_i,data_patch,...
        'EdgeColor','none','FaceAlpha',opacity);    
    axis ij
    axis equal
    if images_folder == 0
        axis([xmin xmax ymin ymax])
    end
    title(['Contour plot of ',plot_title,sprintf(' (Current image #: %1g)',i)],...
        'fontsize',10,'fontweight','bold')
    xlabel(['X ',unitXY], 'fontsize',10,'fontweight','bold')
    ylabel(['Y ',unitXY],'fontsize',10,'fontweight','bold')
    set(gca,'fontsize',10,'layer','top')
    caxis([a(i),b(i)])
    h = colorbar('Location','EastOutside');
    title (h,unitE,'fontsize',10)
    
    hold off
    
    try
        waitforbuttonpress
    catch
        return
    end
end
    