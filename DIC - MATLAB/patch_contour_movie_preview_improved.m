function patch_contour_movie_preview_improved(figpos,preview,grid_param,scale,...
    N_Node,param_patch_contour)


%Get the patch contour parameters:
data = param_patch_contour.data;
plot_title = param_patch_contour.plot_title;
a = param_patch_contour.a;
b = param_patch_contour.b;
images_folder = param_patch_contour.images_folder;
opacity = param_patch_contour.opacity;
images = param_patch_contour.images;
xdata = param_patch_contour.xdata;
ydata = param_patch_contour.ydata;
unitXY = param_patch_contour.unitXY;
unitE = param_patch_contour.unitE;
gridx = param_patch_contour.gridx;
gridy = param_patch_contour.gridy;

if size(gridx,2) > 1 %Deformed grid, new grid for each image
    gridx = gridx(:,preview);
    gridy = gridy(:,preview);
end

%Get step size (in um):
step_pi = grid_param.step; %Step size in pixels
step = step_pi*scale; %Step size in um.


% Form the vertices of the squares surrounding the grid nodes
gridx_patch = zeros(4,N_Node);
gridy_patch = zeros(4,N_Node);
for i = 1:N_Node
    gridx_patch(:,i) = [gridx(i) - step/2; gridx(i) - step/2; gridx(i) + step/2; gridx(i) + step/2];
    gridy_patch(:,i) = [gridy(i) + step/2; gridy(i) - step/2; gridy(i) - step/2; gridy(i) + step/2];
end

%Alter the patch slightly to get rid of the white lines inbetween
%patch elements by merging close points
[gridx_patch,gridy_patch] = merge_points(gridx_patch,gridy_patch,step);

%Create the patch contour plot
m = figure('units','pixels','OuterPosition',figpos,'windowstyle','normal');
xmin = min(min(gridx)) - 0.05*max(max(gridx));
xmax = max(max(gridx)) + 0.05*max(max(gridx));
ymin = min(min(gridy)) - 0.05*max(max(gridy));
ymax = max(max(gridy)) + 0.05*max(max(gridy));


figure(m)
clf

%Show the image (if desired)
if images_folder ~= 0 %A folder was chosen
    image_i_name = images(preview).name;
    
    try %Backslash for PCs
        image_i = [images_folder,'\',image_i_name];
    catch %Frontslash for Macs
        image_i = [images_folder,'/',image_i_name];
    end
    
    warning('off','images:initSize:adjustingMag');
    image_layer = imshow(image_i,'xdata',xdata,'ydata',ydata);
    freezeColors
end

hold on

% Transform the shape of disp_grad from one value at each DU node, to one value
% at each vertex of the square surrounding the DU node:
data_i = data(:,preview); %i'th image
data_i_trans = data_i'; %transpose from column to row vector
data_patch = [data_i_trans; data_i_trans; data_i_trans; data_i_trans]; %Same disp grad at four vertices of patch square

colormap('jet')
patch_layer = patch(gridx_patch,gridy_patch,data_patch,'EdgeColor','none','FaceAlpha',opacity);    
axis ij
axis equal
if images_folder == 0
    axis([xmin xmax ymin ymax])
end
title(['Contour plot of ',plot_title,sprintf(' (Current image #: %1g)',preview)],'fontsize',16,'fontweight','bold')
xlabel(['X ',unitXY], 'fontsize',16)
ylabel(['Y ',unitXY],'fontsize',16)
set(gca,'fontsize',12)
caxis([a(preview),b(preview)])
h = colorbar('Location','EastOutside');
title (h,unitE,'fontsize',12)

hold off

    