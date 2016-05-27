%This function averages sorted DIC data over the entire image

function [data_DIC_avg,data_DIC_std,data_DIC_min,data_DIC_max] = average_image(data_DIC)

[N_row,N_col] = size(data_DIC);
data_DIC_avg = cell(N_row,N_col);
data_DIC_std = cell(N_row,N_col);
data_DIC_min = cell(N_row,N_col);
data_DIC_max = cell(N_row,N_col);
for i = 1:N_row
    
    for j = 1:N_col
        
        data_ij = data_DIC{i,j};
        
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
            for k = 1:N_images
                
                data_ijk = data_ij(k,:);
                %Remove the NaN values from data_ijk
                data_ijk = data_ijk(~isnan(data_ijk));
                
                %data_ijk really shouldn't be empty, unless a particular
                %image did not correlate AT ALL
                if ~isempty(data_ijk)
                    data_ijk_avg = mean(data_ijk);
                    data_ijk_std = std(data_ijk);
                    data_ijk_min = min(data_ijk);
                    data_ijk_max = max(data_ijk);
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
