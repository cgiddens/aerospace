%This function correlates the reduced grid (if there is one) with the full
%grid.  First, it groups points in the full grid with the closest point in
%the reduced grid.  Then, it assigns the appropriate value from the reduced
%displacements to the initial guess of displacements in the full
%correlation

function [initialx,initialy] = grid_correlation(gridx_reduced,gridy_reduced,...
    gridx,gridy,grid_param,dispx_reduced,dispy_reduced,reduction,N_images_correlated,...
    ref_image)


%Number of points in the full grid
N_pts = grid_param.N_pts;

%Define default initial guesses; if reduced images weren't correlated,
%these values will remain at zero
initialx = zeros(N_pts,N_images_correlated);
initialy = zeros(N_pts,N_images_correlated);

if ~isempty(gridx_reduced) %Reduced images were correlated
    
    %Expand the reduced grid back up to the full grid pixels
    gridx_reduced_expanded = gridx_reduced*reduction;
    gridy_reduced_expanded = gridy_reduced*reduction;
    
    for j = 1:N_images_correlated
        
        gridx_temp = gridx_reduced_expanded;
        gridy_temp = gridy_reduced_expanded;
        
        gridx_temp(isnan(dispx_reduced(:,j))) = NaN;
        gridy_temp(isnan(dispy_reduced(:,j))) = NaN;
        
        ind = zeros(N_pts,1);
        for i = 1:N_pts

            %Calculate the distance between the current full grid point and all of
            %the points in the reduced grid
            deltax = gridx_temp - gridx(i);
            deltay = gridy_temp - gridy(i);
            dist = sqrt(deltax.^2 + deltay.^2);

            %Find the point in the reduced grid that is the closest to the current
            %point in the full grid
            [dummy_value,ind(i)] = min(dist);

        end
        
        %Assign the appropriate reduced displacement to the initial displacement
        %guesses; note that disp_reduced are already in original, full
        %scale coordinates, so do NOT multiply by reduction
        
        %If using image 1 as reference, then set initial guesses to the
        %disp_reduced values directly; otherwise, set initial guesses to
        %the DIFFERENCE in disp_reduced from one image to the next
        if ref_image == 1
            initialx(:,j) = round(dispx_reduced(ind,j));
            initialy(:,j) = round(dispy_reduced(ind,j));
        elseif ref_image == 2 && j>1 %Keep initial guesses at zero for self-correlation of reference image
            initialx(:,j) = round(dispx_reduced(ind,j) - dispx_reduced(ind,j-1));
            initialy(:,j) = round(dispy_reduced(ind,j) - dispy_reduced(ind,j-1));
        end
                
    end 

    
end




