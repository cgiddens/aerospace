%This function setups up the reduced grid information, correlates the
%reduced images (for large displacements) and calculates the rough
%displacements


function [gridx_reduced,gridy_reduced,grid_setup_reduced,corr_setup_reduced,...
    dispx_reduced,dispy_reduced,corr_coeff_reduced] = grid_reduced_setup_fun(...
    grid_setup_reduced,gridx_reduced,gridy_reduced,corr_setup_reduced,...
    reduced_grid_selection,reduction,N_images_correlated,...
    filenamelist,ref_image,subset_reduced,N_threads,loop_type,...
    corr_reduced_selection,dispx_reduced_previous,dispy_reduced_previous,...
    thresh_reduced,default_search_zone_reduced)


%Save the old grid_reduced as "previous" variables:
gridx_reduced_previous = gridx_reduced;
gridy_reduced_previous = gridy_reduced;

%Search zone for reduced images - default is 3 and it's recommend that it should not change.
%If reduced image correlation is not sufficient to capture large
%displacements, use several iterations of reduced image correlation rather
%than changing the search zone!
% def_search_zone = 3;

%The user doesn't want to define a new reduced grid AND there is
%already a reduced grid in the working directory
if reduced_grid_selection==1 && ~isempty(grid_setup_reduced) %No

    %Get parameters from previous grid
    N_pts_reduced = grid_setup_reduced.N_pts;
    search_zone_reduced = default_search_zone_reduced*ones(N_pts_reduced,N_images_correlated);
    initialx_reduced = zeros(N_pts_reduced,N_images_correlated);
    initialy_reduced = zeros(N_pts_reduced,N_images_correlated);

%The user wishes to define a new reduced grid OR there is no reduced grid already in the working directory
elseif reduced_grid_selection==2 || isempty(grid_setup_reduced) %reduced_grid_selection = yes
    [N_pts_reduced,gridx_reduced,gridy_reduced,grid_setup_reduced,...
        initialx_reduced,initialy_reduced,search_zone_reduced] = ...
        grid_reduced_define(reduction,N_images_correlated,subset_reduced,...
        filenamelist,default_search_zone_reduced);
end


%User wants to use previously correlated reduced images as input for
%current correlation of reduced images
if corr_reduced_selection==3
    
    reduction_fake = 1; %When iterating the reduced correlations, use the same reduction factor!!!
    iteration_count = corr_setup_reduced.iteration_count+1;
    
    %Scale the disp_reduced back from full grid coordinates to reduced grid
    %coordinates:
    dispx_reduced_previous = dispx_reduced_previous/reduction;
    dispy_reduced_previous = dispy_reduced_previous/reduction;
    
    [initialx_reduced,initialy_reduced] = grid_correlation(...
        gridx_reduced_previous,gridy_reduced_previous,gridx_reduced,gridy_reduced,...
        grid_setup_reduced,dispx_reduced_previous,dispy_reduced_previous,reduction_fake,...
        N_images_correlated,ref_image);
    
else
    iteration_count = 1;

end



%Correlate the reduced images
[validx_reduced,validy_reduced,corr_coeff_reduced] = automate_image_GUI_compatible...
    (filenamelist,reduction,gridx_reduced,gridy_reduced,ref_image,subset_reduced,...
    search_zone_reduced,N_images_correlated,N_pts_reduced,...
    initialx_reduced,initialy_reduced,N_threads,loop_type,thresh_reduced);

%Save the reduced correlation setup parameters
corr_setup_reduced.today = clock; %Get the current date and time
corr_setup_reduced.subset_reduced = subset_reduced;
corr_setup_reduced.ref_image = ref_image;
corr_setup_reduced.N_images_correlated = N_images_correlated;
corr_setup_reduced.search_zone = search_zone_reduced;
corr_setup_reduced.initialy = initialy_reduced;
corr_setup_reduced.initialx = initialx_reduced;
corr_setup_reduced.def_search_zone = default_search_zone_reduced;
corr_setup_reduced.reduction = reduction;
corr_setup_reduced.iteration_count = iteration_count;
corr_setup_reduced.thresh_reduced = thresh_reduced;
corr_setup_reduced.default_search_zone_reduced = default_search_zone_reduced;

%Compute the average displacements
%Note:  the reduced grids are in reduced pixels, but the reduced 
%displacements are in the full, unreduced pixels!
[dispx_reduced,dispy_reduced] = calc_disp_reduced(...
    N_pts_reduced,reduction,ref_image,N_images_correlated,...
    gridx_reduced,gridy_reduced,validx_reduced,validy_reduced);

    




function [N_pts_reduced,gridx_reduced,gridy_reduced,grid_setup_reduced,...
    initialx_inside,initialy_inside,search_zone_inside] = ...
    grid_reduced_define(reduction,N_images_correlated,subset_reduced,...
    filenamelist,def_search_zone)

msgboxwicon = msgbox('Define grid for reduced image size.');
waitfor(msgboxwicon)

%Generate the reduced grid.  Note, output is in terms of original
%image pixels!
[gridx_reduced,gridy_reduced,grid_setup_reduced] = grid_generator_GUI_compatible_3(reduction); 


% grid_setup.grid_param = grid_param_reduced;
N_pts_reduced = grid_setup_reduced.N_pts;
def_search_zone = def_search_zone*ones(N_pts_reduced,N_images_correlated);
initialx = zeros(N_pts_reduced,N_images_correlated);
initialy = zeros(N_pts_reduced,N_images_correlated);

%Remove points that are close to the boundary of the image
[N_pts_reduced,gridx_reduced,gridy_reduced,grid_setup_reduced,initialx_inside,initialy_inside,...
    search_zone_inside] = delete_grid_boundaries...
    (gridx_reduced,gridy_reduced,grid_setup_reduced,subset_reduced,initialx,initialy,def_search_zone,...
    filenamelist,reduction);

grid_setup_reduced.reduction = reduction;


