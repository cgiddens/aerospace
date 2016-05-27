%This function smoothes the displacement data based on a moving average
%across the matrix

function [dispx_smooth,dispy_smooth,smooth_setup] = smooth_moving_average_V2(...
    smooth_setup,grid_param,corr_setup,dispx,dispy,loop_type,N_threads)


%Get the smoothing parameters:
weighting_method = smooth_setup.weights_selection; %1=Gaussian; 2=Even
kernel_size = (smooth_setup.kernel_size-1)/2;
smooth_passes = smooth_setup.smooth_passes;
NaN_group_size = smooth_setup.NaN_group_size;

%Get the grid and correlation parameters
Nx = grid_param.Nx;
Ny = grid_param.Ny;
x_matrix = grid_param.x_matrix;
y_matrix = grid_param.y_matrix;
step = grid_param.step;
N_images_correlated = corr_setup.N_images_correlated;

%Fill in NaN values from deleted points and reshape displacements into matrices
ind_NUM = find(~isnan(x_matrix));
dispx_NaN = zeros(Nx*Ny,N_images_correlated)*NaN;
dispy_NaN = zeros(Nx*Ny,N_images_correlated)*NaN;
dispx_NaN(ind_NUM,:) = dispx;
dispy_NaN(ind_NUM,:) = dispy;
dispx_matrix = reshape(dispx_NaN,[Ny,Nx,N_images_correlated]);
dispy_matrix = reshape(dispy_NaN,[Ny,Nx,N_images_correlated]);

%Get the appropriate weight distribution:
if weighting_method==2 %Evenly distributed weights
    N_pts_avg = (kernel_size*2+1)^2;
    weights_ij = ones(kernel_size*2+1)/N_pts_avg;
elseif weighting_method==1 %Gaussian distribution of weights
    %Define the center point of the normal distribution:
    center_row = kernel_size + 1;
    center_col = kernel_size + 1;
    weights_ij = normal_distribution(center_row,center_col,kernel_size+1,ones(kernel_size*2+1));
end
weights_k = reshape(weights_ij,1,[]);
weights = repmat(weights_k,Nx*Ny,1);

% Get the indices of the top, bottom, left, and right boundaries of smooth
% kernel
boundaries = zeros(Ny*Nx,(kernel_size*2+1)^2);
k = 1;
for i = 1:Nx
    for j = 1:Ny
        
        %Define the location of the current point, in the padded
        %disp matrices
        row_j = j + kernel_size;
        col_i = i + kernel_size;

        %Define the boundaries of the area you want to average over
        top = row_j-kernel_size;
        bot = row_j+kernel_size;
        left = col_i-kernel_size;
        right = col_i+kernel_size;
        
        [col,row] = meshgrid([left:right],[top:bot]);
        row = reshape(row,[],1);
        col = reshape(col,[],1);
        boundaries_k = sub2ind([Ny+2*kernel_size,Nx+2*kernel_size],row,col);
        boundaries(k,:) = boundaries_k;

        k = k+1;
        
    end
end

%Prepare the matrices for extrapolating the displacements (for smoothing
%strain calculations at the borders of the ROI)
[x_matrix_large,y_matrix_large] = pad_disp_setup(Nx,Ny,...
    x_matrix,y_matrix,step,kernel_size);

%Save the smoothing parameters:
smooth_setup.kernel_size = kernel_size;
smooth_setup.smooth_passes = smooth_passes;
smooth_setup.NaN_group_size = NaN_group_size;

wait_smooth = waitbar(0,sprintf('Smoothing displacements (overall progress)'));

%Preallocate disp_smooth matrices
dispx_smooth_matrix = dispx_matrix;
dispy_smooth_matrix = dispy_matrix;
for m = 1:smooth_passes

    %Temporary arrays for the m'th smooth pass:
    dispx_smooth_matrix_m = dispx_smooth_matrix;
    dispy_smooth_matrix_m = dispy_smooth_matrix;
    
    % Initialize the JAVA progress bar
    try % Initialization
        percent = 1;
        do_debug = 1;
        ppm = ParforProgressStarter2('Smooth Images (all images, one iteration)', N_images_correlated, percent, do_debug);
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
    
    %Decide which type of loop to run
    if strcmp(loop_type,'parallel') == 1
        parfor (k = 1:N_images_correlated,N_threads)
            %Run through the body of loop common to parallel and serial
            [dispx_smooth_matrix_k,dispy_smooth_matrix_k] = smooth_moving_average_loop(...
                k,x_matrix,y_matrix,x_matrix_large,y_matrix_large,...
                dispx_smooth_matrix_m,dispy_smooth_matrix_m,...
                Ny,Nx,boundaries,weights);
            
            % Put the smoothed disp vec into the appropriate column
            dispx_smooth_matrix(:,:,k) = dispx_smooth_matrix_k;
            dispy_smooth_matrix(:,:,k) = dispy_smooth_matrix_k;

            % mark that an image has been smoothed
            ppm.increment(k);
        end
        
    elseif strcmp(loop_type,'serial') == 1
        for k = 1:N_images_correlated
            %Run through the body of loop common to parallel and serial
            [dispx_smooth_matrix_k,dispy_smooth_matrix_k] = smooth_moving_average_loop(...
                k,x_matrix,y_matrix,x_matrix_large,y_matrix_large,...
                dispx_smooth_matrix_m,dispy_smooth_matrix_m,...
                Ny,Nx,boundaries,weights);

            dispx_smooth_matrix(:,:,k) = dispx_smooth_matrix_k;
            dispy_smooth_matrix(:,:,k) = dispy_smooth_matrix_k;

            % mark that an image has been smoothed
            ppm.increment(k);
        end
    end
       
    %Close the N_images_correlated wait bar
    try % use try / catch here, since delete(struct) will raise an error.
        delete(ppm);
    catch me %#ok<NASGU>
    end
    
    %Update overall wait bar
    figure(wait_smooth)
    waitbar(m/smooth_passes)
    
end

% Remove data from regions that did not correlate and from where the user deleted raw data
[dispx_smooth,dispy_smooth] = delete_noncorrelated_data(x_matrix,dispx_matrix,...
    dispx_smooth_matrix,dispy_smooth_matrix,Nx,Ny,N_images_correlated,NaN_group_size);

%Close the overall wait bar
close(wait_smooth)


%This function contains the main body of the loop, that is common to both
%parallel and serial loops
function [dispx_smooth_matrix_k,dispy_smooth_matrix_k] = smooth_moving_average_loop(...
    k,x_matrix,y_matrix,x_matrix_large,y_matrix_large,...
    dispx_smooth_matrix_m,dispy_smooth_matrix_m,...
    N_row,N_col,boundaries,weights)

dispx_matrix_k = dispx_smooth_matrix_m(:,:,k);
dispy_matrix_k = dispy_smooth_matrix_m(:,:,k);

%Pad disp matrices around borders
[dispx_padded,dispy_padded] = pad_disp_V2(x_matrix,y_matrix,x_matrix_large,y_matrix_large,...
    dispx_matrix_k,dispy_matrix_k);

%If the data couldn't be interpolated/extrapolated using
%scatteredInterpolant (i.e. because there aren't enough correlated data
%points), fill a matrix with NaN values:
if isempty(dispx_padded)
    dispx_padded = zeros(size(x_matrix_large))*NaN;
    dispy_padded = zeros(size(x_matrix_large))*NaN;
end

sub_dispx = dispx_padded(boundaries);
sub_dispy = dispy_padded(boundaries);

%Multiply the displacements by the weights:
weight_dispx = sub_dispx.*weights;
weight_dispy = sub_dispy.*weights;

%Sum the weighted displacements along the rows to get the average displacemetns
avg_dispx = sum(weight_dispx,2);
avg_dispy = sum(weight_dispy,2);

%Reshape the averaged displacements back into matrices
dispx_smooth_matrix_k = reshape(avg_dispx,N_row,N_col);
dispy_smooth_matrix_k = reshape(avg_dispy,N_row,N_col);



