% This function averages the DIC data over a line scan

function [data_DIC_avg,data_DIC_std,data_DIC_min,data_DIC_max] = ...
    average_line_GUI_compatible(data_DIC,gridx_DIC,grid_location,frac)

%Why do I set gridx, and not switch between gridx and gridy?

[N_row,N_col] = size(data_DIC);
data_DIC_avg = cell(N_row,N_col);
data_DIC_std = cell(N_row,N_col);
data_DIC_min = cell(N_row,N_col);
data_DIC_max = cell(N_row,N_col);
for i = 1:N_row %Loop over the number of cycles
    
    gridx = gridx_DIC{i,1};
    grid_location_i = grid_location{i,1};
    N_Node = length(gridx);
    
    %Check to see if there are grid points:
    if isempty(gridx) == 1 %No gridx points
        
        data_DIC_avg{i,1} = 0;
        data_DIC_avg{i,2} = 0;
        
    elseif isempty(gridx) == 0 %There are gridx_DU points
        
        %Find the median values of the x- and y- coordinates
        grid_location_sort = sort(grid_location_i); %Sort the values of the location-grid
        index = ceil(N_Node*frac); %index of the grid_other-value that is "location" fraction from the top of the ROI
        value = grid_location_sort(index); %grid_other-value that is "location" from the top/left of the ROI
        grid_index = find(grid_location_i == value); %index values of ALL the grid_other-entries that are the same value as y_value
        N_pts_scan = length(grid_index); %Number of points in the line scan

        for j = 1:N_col %Loop through the lithiation and delithiation columns

            data_ij = data_DIC{i,j}; %Data set for the i'th cycle, j'th step

            if isempty(data_ij) == 1
                data_ij_avg = 0;
                data_ij_std = 0;
                data_ij_min = 0;
                data_ij_max = 0;
            elseif isempty(data_ij) == 0

                N_images = size(data_ij,1);
                data_ij_avg = zeros(N_images,1);
                data_ij_std = zeros(N_images,1);
                data_ij_min = zeros(N_images,1);
                data_ij_max = zeros(N_images,1);
                for k = 1:N_images %Loop over the number of images in the i'th cycle, j'th step
                    data_ijk = data_ij(k,:); %Data for the k'th image of the i'th cycle, j'th step

                    data_scan = zeros(1,N_pts_scan);
                    for m = 1:N_pts_scan %Loop over the number of points in the scan
                        index_m = grid_index(m); %Get the i'th index
                        data_scan(1,m) = data_ijk(1,index_m); %Get the i'th data points in the scan
                    end

                    %Remove NaN points
                    data_scan = data_scan(~isnan(data_scan));
                  
                    %data_scan really shouldn't be empty, unless a particular
                    %image did not correlate AT ALL
                    if ~isempty(data_scan)
                        data_ijk_avg = mean(data_scan);
                        data_ijk_std = std(data_scan);
                        data_ijk_min = min(data_scan);
                        data_ijk_max = max(data_scan);
                    else
                        data_ijk_avg = NaN;
                        data_ijk_std = NaN;
                        data_ijk_min = NaN;
                        data_ijk_max = NaN;
                    end
                    
                    data_ij_avg(k) = data_ijk_avg;
                    data_ij_std(k) = data_ijk_std;
                    data_ij_min(k) = data_ijk_min;
                    data_ij_max(k) = data_ijk_max;
                    
                end
            end

            data_DIC_avg{i,j} = data_ij_avg;
            data_DIC_std{i,j} = data_ij_std;
            data_DIC_min{i,j} = data_ij_min;
            data_DIC_max{i,j} = data_ij_max;

        end
        
    end
    
end

