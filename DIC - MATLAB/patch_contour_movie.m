function patch_contour_movie(figpos,N_images,skip,frame_rate,grid_param,scale,...
    N_Node,param_patch_contour,title_string,fig_type)


%Get the patch contour parameters:
unitXY = param_patch_contour.unitXY;
unitE = param_patch_contour.unitE;
data = param_patch_contour.data;
a = param_patch_contour.a;
b = param_patch_contour.b;
images_folder = param_patch_contour.images_folder;
opacity = param_patch_contour.opacity;
images = param_patch_contour.images;
xdata = param_patch_contour.xdata;
ydata = param_patch_contour.ydata;
gridx = param_patch_contour.gridx;
gridy = param_patch_contour.gridy;


%Get step size (in um):
step_pi = grid_param.step; %Step size in pixels
step = step_pi*scale; %Step size in um.

if size(gridx,2) == 1 %Reference grid, same grid for each image
    % Form the vertices of the squares surrounding the grid nodes
    gridx_patch = zeros(4,N_Node);
    gridy_patch = zeros(4,N_Node);
    for j = 1:N_Node
        gridx_patch(:,j) = [gridx(j) - step/2; gridx(j) - step/2;...
            gridx(j) + step/2; gridx(j) + step/2];
        gridy_patch(:,j) = [gridy(j) + step/2; gridy(j) - step/2;...
            gridy(j) - step/2; gridy(j) + step/2];
    end
end

%Set the axes of the patch contour plot
xmin = min(min(gridx)) - 0.05*max(max(gridx));
xmax = max(max(gridx)) + 0.05*max(max(gridx));
ymin = min(min(gridy)) - 0.05*max(max(gridy));
ymax = max(max(gridy)) + 0.05*max(max(gridy));

%Initialize the video and the frames
today = date;
file_name_string = [fig_type,' ',today];
writerObj = VideoWriter(file_name_string,'MPEG-4');
writerObj.FrameRate = frame_rate;
open(writerObj);
set(gcf,'Renderer','opengl');
% Frames(N_images) = struct('cdata',[],'colormap',[]);


for i = 1:skip:N_images
    
    if size(gridx,2) > 1 %Deformed grid, new grid for each image
        % Form the vertices of the squares surrounding the grid nodes
        gridx_patch = zeros(4,N_Node);
        gridy_patch = zeros(4,N_Node);
        for j = 1:N_Node
            gridx_patch(:,j) = [gridx(j,i) - step/2; gridx(j,i) - step/2;...
                gridx(j,i) + step/2; gridx(j,i) + step/2];
            gridy_patch(:,j) = [gridy(j,i) + step/2; gridy(j,i) - step/2;...
                gridy(j,i) - step/2; gridy(j,i) + step/2];
        end
    end
    
    m = figure('units','pixels','OuterPosition',figpos,...
        'windowstyle','normal','color','white');
    
    %Show the image (if desired)
    if images_folder ~= 0 %A folder was chosen
        image_i_name = images(i).name;
        image_i = [images_folder,'\',image_i_name];
        warning('off','images:initSize:adjustingMag');
        image_layer = imshow(image_i,'xdata',xdata,'ydata',ydata);
        freezeColors
        
    end
    
    hold on
    
    % Transform the shape of disp_grad from one value at each DU node, to one value
    % at each vertex of the square surrounding the DU node:
    data_i = data(:,i); %i'th image
    data_i_trans = data_i'; %transpose from column to row vector
    data_patch = [data_i_trans; data_i_trans; data_i_trans; data_i_trans]; %Same disp grad at four vertices of patch square
    
    colormap('jet')
    patch_layer = patch(gridx_patch,gridy_patch,data_patch,'EdgeColor','none','FaceAlpha',opacity);    
    axis ij
    axis equal
    if images_folder == 0
        axis([xmin xmax ymin ymax])
    end
    title(title_string,'fontsize',16,'fontweight','bold')
    xlabel(['X ',unitXY], 'fontsize',16)
    ylabel(['Y ',unitXY],'fontsize',16)
    set(gca,'fontsize',12)
    caxis([a(i),b(i)])
    h = colorbar('Location','EastOutside');
    title (h,unitE,'fontsize',12)
    
    hold off
    
%     if(i==1)
%        pause(5);
%        
%    else
%        pause(5);
%     end
       
    %Add the frame to the video
    pause(0.5)
    frameM = getframe(m);
    writeVideo(writerObj,frameM);
    pause(0.5)
    
    %Matlab movie
%     Frames(i) = getframe(m);
    close(m)

end
% pause(0.5)
%Close the video files
% save(file_name_string,'Frames')
close(writerObj);
