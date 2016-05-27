% This function averages the DIC data over a line scan

function [data_DIC_avg,data_DIC_std,data_DIC_min,data_DIC_max] = ...
    average_box(data_DIC,gridx_DIC,gridy_DIC,frac)


[N_row,N_col] = size(data_DIC);
data_DIC_avg = cell(N_row,N_col);
data_DIC_std = cell(N_row,N_col);
data_DIC_min = cell(N_row,N_col);
data_DIC_max = cell(N_row,N_col);
for i = 1:N_row %Loop over the number of cycles
    
    gridx = gridx_DIC{i,1};
    gridy = gridy_DIC{i,1};
%     grid_location_i = grid_location{i,1};
    N_Node = length(gridx);
    
    %Check to see if there are grid points:
    if isempty(gridx) == 1 %No gridx points
        
        data_DIC_avg{i,1} = 0;
        data_DIC_avg{i,2} = 0;
        
    elseif isempty(gridx) == 0 %There are gridx_DU points
        
        %Find the values to average over
        gridx_sort = sort(gridx); %Sort the values of the gridx
        gridy_sort = sort(gridy); %Sort the values of the gridy
        
        index_middle = ceil(N_Node*0.5); %Index of middle of grid
        valuex_middle = gridx_sort(index_middle); %x-value at center of ROI
        valuey_middle = gridy_sort(index_middle); %y-value at center of ROI
        
        spanx_ROI = max(gridy) - min(gridy); %Total span of ROI in y-direction
        spany_ROI = max(gridx) - min(gridx); %Total span of ROI in x-direction
        
        %Span of the box you want to average over
        spanx_box = frac*spanx_ROI; 
        spany_box = frac*spany_ROI;
        
        %Min and max values of box you want to average over - EXACT VALUES
        boxx_min = valuex_middle - spanx_box/2;
        boxx_max = valuex_middle + spanx_box/2;
        boxy_min = valuey_middle - spany_box/2;
        boxy_max = valuey_middle + spany_box/2;
        
        %Index values of control points within the box.
        index_box = find(gridx>boxx_min & gridx<boxx_max & gridy>boxy_min & gridy<boxy_max);
        
%         index = ceil(N_Node*frac); %index of the grid_other-value that is "location" fraction from the top of the ROI
%         value = gridx_sort(index); %grid_other-value that is "location" from the top/left of the ROI
%         grid_index = find(grid_location_i == value); %index values of ALL the grid_other-entries that are the same value as y_value
%         N_pts_scan = length(grid_index); %Number of points in the line scan

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

%                     data_scan = zeros(1,N_pts_scan);
%                     for m = 1:N_pts_scan %Loop over the number of points in the scan
%                         index_m = grid_index(m); %Get the i'th index
%                         data_scan(1,m) = data_ijk(1,index_m); %Get the i'th data points in the scan
%                     end
                    data_box = data_ijk(index_box);

                    %Remove NaN points
                    data_box = data_box(~isnan(data_box));
                  
                    %data_scan really shouldn't be empty, unless a particular
                    %image did not correlate AT ALL
                    if ~isempty(data_box)
                        data_ijk_avg = mean(data_box);
                        data_ijk_std = std(data_box);
                        data_ijk_min = min(data_box);
                        data_ijk_max = max(data_box);
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

