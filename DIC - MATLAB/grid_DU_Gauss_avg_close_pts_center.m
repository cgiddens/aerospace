function [N_pts_Gauss_avg_center,gridx_DU_Gauss_avg_center,gridy_DU_Gauss_avg_center,...
    ind_Gauss_to_avg_center] = ...
    grid_DU_Gauss_avg_close_pts_center(grid_param,scale,gridx_DU_Gauss,gridy_DU_Gauss,...
    N_Cluster,N_pts_Gauss_avg,gridx_DU_Gauss_avg,gridy_DU_Gauss_avg)


%Eliminate points on the edge of the domain / keep only points in the center of the domain:


%Get the step size from DIC correlation setup parameters
step_pi = grid_param.step; %Step size in pixels
step_um = step_pi*scale; %Step size in um


gridx_DU_Gauss_avg_center = zeros(N_pts_Gauss_avg,1);
gridy_DU_Gauss_avg_center = zeros(N_pts_Gauss_avg,1);
ind_Gauss_to_avg_center = zeros(N_pts_Gauss_avg,N_Cluster);
ind_avg_all = cell(N_pts_Gauss_avg,1);
k = 1;
for i = 1:N_pts_Gauss_avg %Loop over all the Gauss averaged points

    % Get the coordinates of the i'th Gauss averaged pt
    x_G_avg = gridx_DU_Gauss_avg(i);
    y_G_avg = gridy_DU_Gauss_avg(i);
       
    %Compute the distance between all the points in the grid_DU_Gauss
        %matrix and the i'th grid_DU_Gauss_avg point:
    x_diff = gridx_DU_Gauss - x_G_avg;
    y_diff = gridy_DU_Gauss - y_G_avg;
    diff = sqrt(x_diff.^2 + y_diff.^2);
        
    %Find the indices of the grid_DU_Gauss points that are closer than
        %step/4 away from the i'th grid_DU_Gauss_avg point
    ind = find(diff < step_um/4);
        
    %Keep track of the indices of clusters
    ind_avg_all{i} = ind;
        
    %Keep only the points in the center of the grid, where there is a whole group of Gauss points    
    if length(ind) == N_Cluster
%         N_center = N_center + 1;
        gridx_DU_Gauss_avg_center(k) = gridx_DU_Gauss_avg(i);
        gridy_DU_Gauss_avg_center(k) = gridy_DU_Gauss_avg(i);
        ind_Gauss_to_avg_center(k,:) = ind;
        k = k + 1;
        
    end
       
    
end

%Remove extra zeros from gridx_DU_Gauss_avg_center
gridx_DU_Gauss_avg_center(k:end) = [];
gridy_DU_Gauss_avg_center(k:end) = [];
ind_Gauss_to_avg_center(k:end,:) = [];

N_pts_Gauss_avg_center = length(gridx_DU_Gauss_avg_center);




