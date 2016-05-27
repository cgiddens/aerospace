%This function calculates the four displacement gradients (du/dx, du/dy,
%dv/dx, and dv/dy) from the DIC displacement results, using finite element
%shape functions to interpolate the displacements.  

%This code assumes 2D data

function [DU,D2U,gridx_DU,gridy_DU,FEM_setup] = calc_derivatives_GUI_compatible(...
    yesno_disp_grad,elem_order,grid_param,corr_setup,gridx,gridy,...
    dispx,dispy,scale,N_threads,loop_type)


if yesno_disp_grad == 0 %Do NOT calculate displacement gradients at this time
    %Get the current time and date:
    FEM_setup.today = clock;
    
    %Empty gradient data
    DU = [];
    D2U = [];
    gridx_DU = [];
    gridy_DU = [];
    
    %Empty FEM setup data
    FEM_setup.N_Dim = [];
    FEM_setup.N_Elem = [];
    FEM_setup.N_Node_Elem = [];
    FEM_setup.N_Elem_Order = [];
    FEM_setup.Elem_Node = [];
    FEM_setup.Coords = [gridx,gridy];
    FEM_setup.scale = scale;
    FEM_setup.avg_method = [];
    FEM_setup.N_Node_DU = [];


    
elseif yesno_disp_grad == 1 %DO calculate displacement gradients at this time

    %% FEM setup:
    %Set up the FEM mesh from the grid data
    t1 = clock;
    [N_Dim,N_Elem,N_Node_Elem,N_Elem_Order,Elem_Node,Coords,gridx_DU_Gauss,gridy_DU_Gauss,Bhat,B2hat] = ...
        FEM_strains_setup_GUI_compatible(elem_order,gridx,gridy,grid_param);
    t2 = clock;

    % Number of close points in the center of the grid / field of view 
    % (quadratic elements have clusters of 4 points; cubic elements have clusters of 9 points)
    N_Cluster = N_Elem_Order^2; 

    
    %Compute the grid data points for the disp grad locations
    
    %Linear elements - calculate strains at single Gauss point in center of
    %element, with no averaging
    
    %Quadratic elements:  Average at clusters of 4 Gauss points from
    %overlapping elements
    
    %Cubic elements:  Average at clusters of 9 Gauss points from
    %overlapping elements

    [N_pts_Gauss_avg,gridx_DU_Gauss_avg,gridy_DU_Gauss_avg] = grid_DU_Gauss_avg_close_pts(...
        N_Elem,N_Node_Elem,N_Elem_Order,Elem_Node,gridx,gridy);

    [N_pts_DU,gridx_DU,gridy_DU,ind_center] = grid_DU_Gauss_avg_close_pts_center(...
        grid_param,scale,gridx_DU_Gauss,gridy_DU_Gauss,N_Cluster,...
        N_pts_Gauss_avg,gridx_DU_Gauss_avg,gridy_DU_Gauss_avg);

    t3 = clock;
    
    %Save the FEM interpolation parameters:
    FEM_setup.today = clock;
    FEM_setup.N_Dim = N_Dim;
    FEM_setup.N_Elem = N_Elem;
    FEM_setup.N_Node_Elem = N_Node_Elem;
    FEM_setup.N_Elem_Order = N_Elem_Order;
    FEM_setup.Elem_Node = Elem_Node;
    FEM_setup.Coords = Coords;
    FEM_setup.scale = scale;
    FEM_setup.avg_method = 'Overlapping Gauss points in center of image';
    FEM_setup.N_Node_DU = N_pts_DU;


    %% Calculate the displacement gradients for each image
    
    N_images = corr_setup.N_images_correlated;
    
    % Initialize the JAVA progress bar
    try % Initialization
        percent = 1;
        do_debug = 1;
        ppm = ParforProgressStarter2('Calculate Strains Progress Bar', ...
            N_images, percent, do_debug);
    catch me % make sure "ParforProgressStarter2" didn't get moved to a different directory
        if strcmp(me.message, 'Undefined function or method ''ParforProgressStarter2'' for input arguments of type ''char''.')
            error('ParforProgressStarter2 not in path.');
        else
            % this should NEVER EVER happen.
            msg{1} = 'Unknown error while initializing "ParforProgressStarter2":';
            msg{2} = me.message;
            print_error_red(msg);
            % backup solution so that we can still continue.
            ppm.increment = nan(1, N_images_correlated);
        end
    end
    
    if N_Dim == 1
        a = 1;
    elseif N_Dim == 2
        a = 6;
    elseif N_Dim == 3
        a = 18;
    end
    
    %Initialize an empty matrix for the displacment gradients
    DU = zeros(N_pts_DU*N_Dim^2,N_images); 
    D2U = zeros(N_pts_DU*a,N_images);
    
    if strcmp(loop_type,'parallel') == 1 %Use parallel loops
        
        parfor (i = 1:N_images, N_threads) %Loop through the images

        %Calculate and average the strains at the Gauss points:
        [DU_avg_i,D2U_avg_i] = calc_strains_loop(i,dispx,dispy,N_Dim,N_Elem,...
            N_Node_Elem,N_Elem_Order,Elem_Node,Bhat,B2hat,N_Cluster,ind_center);
        
        
        %Store the average displacement gradients for image i (DU_avg_i) into
        %the matrix containing the all the displacement gradients for all
        %images (DU)
        DU(:,i) = DU_avg_i;
        D2U(:,i) = D2U_avg_i;
        
        %Mark that an image has been correlated
        ppm.increment(i);

        end
        
    elseif strcmp(loop_type,'serial') == 1 %Use serial loops
        
        for i = 1:N_images %Loop through the images
        
        %Calculate and average the strains at the Gauss points:
        [DU_avg_i,D2U_avg_i] = calc_strains_loop(i,dispx,dispy,N_Dim,N_Elem,...
            N_Node_Elem,N_Elem_Order,Elem_Node,Bhat,B2hat,N_Cluster,ind_center);

        %Store the average displacement gradients for image i (DU_avg_i) into
        %the matrix containing the all the displacement gradients for all
        %images (DU)
        DU(:,i) = DU_avg_i;
        D2U(:,i) = D2U_avg_i;

        %Mark that an image has been correlated
        ppm.increment(i);

        end
        
    end
    
    %Close the wait bar
    try % use try / catch here, since delete(struct) will raise an error.
        delete(ppm);
    catch me %#ok<NASGU>
    end

    t4 = clock;

    %Print the times for all the set up in the Command Window
    FEM_setup_time = etime(t2,t1)
    grid_DU_time = etime(t3,t2)    
    calc_strains_time = etime(t4,t3)
end





