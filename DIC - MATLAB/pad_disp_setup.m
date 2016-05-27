%This function prepares the larger grid for extrapolation of the
%displacements

function [x_matrix_large,y_matrix_large] = pad_disp_setup(Nx,Ny,...
    x_matrix,y_matrix,step,kernel_size)

%% Pad a larger grid to extrapolate on, so that the strain calculations are better at the edges of the ROI:

%Find min and max of current grid matrices:
xmin = min(min(x_matrix));
xmax = max(max(x_matrix));
ymin = min(min(y_matrix));
ymax = max(max(y_matrix));

%See if any entire rows or columns of data were deleted (will have to
%adjust min and max values)
nan_col = sum(isnan(x_matrix)); %Number of NaN values in each column
nan_row = sum(isnan(x_matrix')); %Number of NaN values in each row

ind_col = find(nan_col == Ny); %Indices of columns that are all NaN
ind_row = find(nan_row == Nx); %Indices of rows that are all NaN

L = 1;
Ltemp = find(ind_col == L);
if isempty(Ltemp)
    add_L = 0;
else
    while ~isempty(Ltemp)
        L = L+1;
        Ltemp = find(ind_col == L);
    end
    add_L = L-1;
end

R = Nx;
Rtemp = find(ind_col == R);
if isempty(Rtemp)
    add_R = 0;
else
    while ~isempty(Rtemp)
        R = R-1;
        Rtemp = find(ind_col == R);
    end
    add_R = Nx - R;
end

T = 1;
Ttemp = find(ind_row == T);
if isempty(Ttemp)
    add_T = 0;
else
    while ~isempty(Ttemp)
        T = T+1;
        Ttemp = find(ind_row == T);
    end
    add_T = T-1;
end

B = Ny;
Btemp = find(ind_row == B);
if isempty(Btemp)
    add_B = 0;
else
    while ~isempty(Btemp)
        B = B-1;
        Btemp = find(ind_row == B);
    end
    add_B = Ny - B;
end

xmin = xmin - add_L*step;
xmax = xmax + add_R*step;
ymin = ymin - add_T*step;
ymax = ymax + add_B*step;

%Expand xmin and xmax based on kernel size:
xmin_large = xmin - kernel_size*step;
xmax_large = xmax + kernel_size*step;
ymin_large = ymin - kernel_size*step;
ymax_large = ymax + kernel_size*step;

%Create the expanded grid matrices:
xvec_large = xmin_large:step:xmax_large;
yvec_large = ymin_large:step:ymax_large;
[x_matrix_large,y_matrix_large] = meshgrid(xvec_large,yvec_large);

end

