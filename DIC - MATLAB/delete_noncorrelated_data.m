%This function removes any non-correlated data regions, where the
%contiguous non-correlated regions are larger than a certain size, as
%determined by the user.  It also deletes smoothed data corresponding to 
% the raw data that the user deleted (using delete_data_GUI)

function [dispx_smooth,dispy_smooth] = delete_noncorrelated_data(x_matrix,...
    dispx_matrix,dispx_smooth_matrix,dispy_smooth_matrix,...
    Nx,Ny,N_images_correlated,...
    NaN_group_size)

%Threshold hold the original displacements, so that you have a logical
%matrix for "correlate" (not nan) or "not correlated" (isnan)
for k = 1:N_images_correlated
    dispx_smooth_matrix_k = dispx_smooth_matrix(:,:,k);
    dispy_smooth_matrix_k = dispy_smooth_matrix(:,:,k);
    
    ind_nan = isnan(dispx_matrix(:,:,k));
    CC = bwconncomp(ind_nan);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    ind_large_regions = find(numPixels>NaN_group_size);
    for m = 1:length(ind_large_regions)
        dispx_smooth_matrix_k(CC.PixelIdxList{ind_large_regions(m)}) = NaN;
        dispy_smooth_matrix_k(CC.PixelIdxList{ind_large_regions(m)}) = NaN;
    end
    
    dispx_smooth_matrix(:,:,k) = dispx_smooth_matrix_k;
    dispy_smooth_matrix(:,:,k) = dispy_smooth_matrix_k;
end

%Reshape the smoothed displacements and remove data from deleted regions
ind_NaN = find(isnan(x_matrix));
dispx_smooth = reshape(dispx_smooth_matrix,[Ny*Nx,N_images_correlated,1]);
dispy_smooth = reshape(dispy_smooth_matrix,[Ny*Nx,N_images_correlated,1]);
dispx_smooth(ind_NaN,:) = [];
dispy_smooth(ind_NaN,:) = [];


end

