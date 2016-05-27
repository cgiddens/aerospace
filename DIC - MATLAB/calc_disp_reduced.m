function [dispx_reduced,dispy_reduced] = calc_disp_reduced(...
    N_pts_reduced,reduction,ref_image,N_images_correlated,...
    gridx_reduced,gridy_reduced,validx_reduced,validy_reduced)

% Calculate the average displacements of reduced correlation
        
if ref_image == 1 %First image
    
    gridx_full = repmat(gridx_reduced,1,N_images_correlated);
    gridy_full = repmat(gridy_reduced,1,N_images_correlated);
    
    %x-displacement of rough correlation at each point in the small grid, in the original coord sys
    dispx = (validx_reduced - gridx_full)*reduction; 
    
    %y-displacement of rough correlation at each point in the small grid, in the original coord sys
    dispy = (validy_reduced - gridy_full)*reduction; 
    


elseif ref_image == 2 %Preceeding image

    %Initialize empty vectors for the incremental displacement
    dispx_succ = zeros(size(validx_reduced));
    dispy_succ = zeros(size(validy_reduced));

    %Self-correlation of the first image
    dispx_succ(:,1) = (validx_reduced(:,1) - gridx_reduced(:,1))*reduction;
    dispy_succ(:,1) = (validy_reduced(:,1) - gridy_reduced(:,1))*reduction;

    %Calculate the displacements between each image
    for i = 2:N_images_correlated
        dispx_succ(:,i) = (validx_reduced(:,i) - validx_reduced(:,i-1))*reduction;
        dispy_succ(:,i) = (validy_reduced(:,i) - validy_reduced(:,i-1))*reduction;
    end

    %Calculate the total displacement from the reference image
    dispx = zeros(size(validx_reduced));
    dispy = zeros(size(validy_reduced));
    dispx(:,1) = dispx_succ(:,1);
    dispy(:,1) = dispy_succ(:,1);
    
    for i = 2:N_images_correlated
        sumx = zeros(N_pts_reduced,1);
        sumy = zeros(N_pts_reduced,1);
        for j = 1:i
            sumx = sumx + dispx_succ(:,j);
            sumy = sumy + dispy_succ(:,j);
        end

        dispx(:,i) = sumx;
        dispy(:,i) = sumy;
    end
end

dispx_reduced = dispx;
dispy_reduced = dispy;
        

