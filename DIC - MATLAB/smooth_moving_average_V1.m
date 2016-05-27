%This function smoothes the displacement data based on a moving average
%across the matrix

function [dispx_smooth,dispy_smooth,smooth_setup] = smooth_moving_average_V1(...
    smooth_setup,grid_param,corr_setup,dispx,dispy,loop_type,N_threads)


%Get the smoothing parameters:
weighting_method = smooth_setup.weights_selection; %1=Gaussian; 2=Even
kernel_size = (smooth_setup.kernel_size-1)/2;
smooth_passes = smooth_setup.smooth_passes;

%Get the grid and correlation parameters
Nx = grid_param.Nx;
Ny = grid_param.Ny;
x_matrix = grid_param.x_matrix;
N_images_correlated = corr_setup.N_images_correlated;

% Remove any NaN rows and columns from x_matrix (where points have been
% deleted using delete_data_GUI)
nan_col = sum(isnan(x_matrix)); %Number of NaN values in each column
nan_row = sum(isnan(x_matrix')); %Number of NaN values in each row

ind_col = find(nan_col == Ny); %Indices of columns that are all NaN
ind_row = find(nan_row == Nx); %Indices of rows that are all NaN

N_row = Ny - length(ind_row); %Number of rows, not counting the NaN values of deleted points
N_col = Nx - length(ind_col); %Number of columns, not counting the NaN values of deleted points

%Eliminate completely deleted rows and columns from x-matrix
x_matrix(:,ind_col) = [];
x_matrix(ind_row,:) = [];

% Get the indices of the top, bottom, left, and right boundaries of smooth
% kernel
boundaries = zeros(N_row*N_col,(kernel_size*2+1)^2);
weights = zeros(N_row*N_col,(kernel_size*2+1)^2);
k = 1;
for i = 1:N_col
    for j = 1:N_row
        
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
        boundaries_k = sub2ind([N_row+2*kernel_size,N_col+2*kernel_size],row,col);
        boundaries(k,:) = boundaries_k;

        %Define the center point of the normal distribution:
        center_row = kernel_size + 1;
        center_col = kernel_size + 1;
        
        %Get the appropriate weight distribution:
        if weighting_method==2 %Evenly distributed weights
            N_pts_avg = (kernel_size*2+1)^2;
            weights_ij = ones(kernel_size*2+1)/N_pts_avg;
            

        elseif weighting_method==1 %Gaussian distribution of weights
            weights_ij = normal_distribution(center_row,center_col,kernel_size+1,ones(kernel_size*2+1));

        end
        weights_k = reshape(weights_ij,[],1);
        weights(k,:) = weights_k;
        
        k = k+1;
        
    end
end

%Fill in NaN values from deleted points and reshape displacements into matrices
ind_NUM = find(~isnan(x_matrix));
dispx_NaN = zeros(N_col*N_row,N_images_correlated)*NaN;
dispy_NaN = zeros(N_col*N_row,N_images_correlated)*NaN;
dispx_NaN(ind_NUM,:) = dispx;
dispy_NaN(ind_NUM,:) = dispy;
dispx_matrix = reshape(dispx_NaN,[N_row,N_col,N_images_correlated]);
dispy_matrix = reshape(dispy_NaN,[N_row,N_col,N_images_correlated]);


%Save the smoothing parameters:
smooth_setup.kernel_size = kernel_size;
smooth_setup.smooth_passes = smooth_passes;

wait_smooth = waitbar(0,sprintf('Smoothing displacements (overall progress)'));

%Preallocate disp_smooth matrices
dispx_smooth_matrix = dispx_matrix;
dispy_smooth_matrix = dispy_matrix;
for m = 1:smooth_passes
    
    %Pad disp matrices around borders
    [dispx_padded,dispy_padded] = pad_disp_V1(N_row,N_col,...
        dispx_smooth_matrix,dispy_smooth_matrix,kernel_size,N_images_correlated);
    

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
                k,dispx_padded,dispy_padded,N_row,N_col,kernel_size,boundaries,weights);
            
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
                k,dispx_padded,dispy_padded,N_row,N_col,kernel_size,boundaries,weights);


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

%Reshape the smoothed displacements and remove data from deleted regions
ind_NaN = find(isnan(x_matrix));
dispx_smooth = reshape(dispx_smooth_matrix,[N_row*N_col,N_images_correlated,1]);
dispy_smooth = reshape(dispy_smooth_matrix,[N_row*N_col,N_images_correlated,1]);
dispx_smooth(ind_NaN,:) = [];
dispy_smooth(ind_NaN,:) = [];

%Close the overall wait bar
close(wait_smooth)


%This function contains the main body of the loop, that is common to both
%parallel and serial loops
function [dispx_smooth_matrix_k,dispy_smooth_matrix_k] = smooth_moving_average_loop(...
    k,dispx_padded,dispy_padded,N_row,N_col,kernel_size,boundaries,weights)

dispx_matrix_k = dispx_padded(:,:,k);
dispy_matrix_k = dispy_padded(:,:,k);

sub_dispx = dispx_matrix_k(boundaries);
sub_dispy = dispy_matrix_k(boundaries);

%Change disp and weights of NaN points to zero, then normalize the weights 
%AFTER removing NaN points so they do not affect the smoothing;
ind_nan = isnan(sub_dispx);
sub_dispx(ind_nan) = 0;
sub_dispy(ind_nan) = 0;
weights(ind_nan) = 0;
sum_weights = sum(weights,2);
normalized_weights = weights./repmat(sum_weights,1,(kernel_size*2+1)^2);

%Multiply the displacements by the weights:
weight_dispx = sub_dispx.*normalized_weights;
weight_dispy = sub_dispy.*normalized_weights;

%Sum the weighted displacements along the rows to get the average displacemetns
avg_dispx = sum(weight_dispx,2);
avg_dispy = sum(weight_dispy,2);

%Reshape the averaged displacements back into matrices
dispx_smooth_matrix_k = reshape(avg_dispx,N_row,N_col);
dispy_smooth_matrix_k = reshape(avg_dispy,N_row,N_col);



