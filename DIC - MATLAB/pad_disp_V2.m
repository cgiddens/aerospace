%This function interpolates over points that did not correlation (disp =
%NaN) and extrapolates the displacements at the edges of the ROI (for
%better strain calculations)

function [dispx_padded,dispy_padded] = pad_disp_V2(x_matrix,y_matrix,...
    x_matrix_large,y_matrix_large,dispx_matrix_k,dispy_matrix_k)

%Get the k'th set of displacements
dispx_k = reshape(dispx_matrix_k,[],1);
dispy_k = reshape(dispy_matrix_k,[],1);

xvec = reshape(x_matrix,[],1);
yvec = reshape(y_matrix,[],1);

%Remove all NaN values from the displacements
ind_nan = isnan(dispx_k);
dispx_k(ind_nan) = [];
dispy_k(ind_nan) = [];
xvec(ind_nan) = [];
yvec(ind_nan) = [];

%Remove any additional NaN values from the grid matrices (this is
%required if performing multiple smoothing passes since the
%displacements after the first smoothing pass have no NaN values, but
%the x_matrix and y_matrix do have NaN values if any grid points were
%deleted
ind_nan = isnan(xvec);
dispx_k(ind_nan) = [];
dispy_k(ind_nan) = [];
xvec(ind_nan) = [];
yvec(ind_nan) = [];

%Create the interpolate/extrapolated displacement structures:
dispx_interp_struct = scatteredInterpolant(xvec,yvec,dispx_k);
dispy_interp_struct = scatteredInterpolant(xvec,yvec,dispy_k);

%Interpolate over non-correlated data + extrapolate over larger grid:
dispx_padded = dispx_interp_struct(x_matrix_large,y_matrix_large);
dispy_padded = dispy_interp_struct(x_matrix_large,y_matrix_large);


end

